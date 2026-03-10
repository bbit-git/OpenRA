#!/usr/bin/env python3
"""Import translations from CSV files back into FTL files.

Reads CSV files produced by check_translations.py --csv, applies every row
where the 'translation' column is non-empty.

Usage:
    import_translations.py <csv_file_or_dir> [options]

Arguments:
    csv_file_or_dir   A single .csv file or a directory containing *.csv files

Options:
    --dry-run       Show what would change without writing
    --no-color      Disable ANSI colour output

CSV columns expected:
    file            Relative path to the translation FTL file (e.g. common/fluent/sk/chrome.ftl)
    key             FTL key, optionally with attribute (e.g. checkbox-fog-of-war.label)
    translation     The new translated value (rows with empty value are skipped)

Examples:
    import_translations.py exports/sk.csv
    import_translations.py exports/
    import_translations.py exports/sk.csv --dry-run
"""

import csv
import sys
from pathlib import Path

try:
    from fluent.syntax import FluentParser, FluentSerializer
    from fluent.syntax import ast as fast
except ImportError:
    print("fluent.syntax not found. Run: pip install fluent.syntax")
    sys.exit(1)

MODS_DIR = Path(__file__).parent.parent / "mods"
PARSER = FluentParser(with_spans=True)
SERIALIZER = FluentSerializer()

RED    = "\033[91m"
YELLOW = "\033[93m"
GREEN  = "\033[92m"
CYAN   = "\033[96m"
BOLD   = "\033[1m"
DIM    = "\033[2m"
RESET  = "\033[0m"

NO_COLOR = not sys.stdout.isatty() or "--no-color" in sys.argv
DRY_RUN  = "--dry-run" in sys.argv


def c(color, text):
    return text if NO_COLOR else f"{color}{text}{RESET}"


# ---------------------------------------------------------------------------
# FTL helpers (mirrors translate.py)
# ---------------------------------------------------------------------------

def find_entry(resource, key: str):
    for entry in resource.body:
        if isinstance(entry, (fast.Message, fast.Term)) and entry.id.name == key:
            return entry
    return None


def set_value(entry, attr: str | None, new_text: str):
    new_pattern = fast.Pattern(elements=[fast.TextElement(value=new_text)])
    if attr is None:
        entry.value = new_pattern
    else:
        for a in entry.attributes:
            if a.id.name == attr:
                a.value = new_pattern
                return
        # Attribute missing — append it
        entry.attributes.append(
            fast.Attribute(id=fast.Identifier(name=attr), value=new_pattern)
        )


def serialize_entry(entry) -> str:
    return SERIALIZER.serialize(fast.Resource(body=[entry])).strip()


# ---------------------------------------------------------------------------
# Per-file batched editing
# ---------------------------------------------------------------------------

def apply_to_file(ftl_path: Path, edits: list[tuple[str, str | None, str]]) -> tuple[int, list[str]]:
    """Apply multiple (key, attr, value) edits to one FTL file.

    Returns (applied_count, list_of_error_messages).
    Edits targeting the same key are batched together so the entry is
    serialized only once, avoiding duplicate attributes.
    Batches are applied right-to-left by span so earlier offsets stay valid.
    """
    src = ftl_path.read_text(encoding="utf-8")
    resource = PARSER.parse(src)

    # Group edits by key, preserving order of first appearance
    by_key: dict[str, list[tuple[str | None, str]]] = {}
    for key, attr, value in edits:
        by_key.setdefault(key, []).append((attr, value))

    # Resolve to (entry, [(attr, value)]) and collect errors
    pending = []   # (entry, [(attr, value)])
    errors  = []

    for key, attr_vals in by_key.items():
        entry = find_entry(resource, key)
        if entry is None:
            errors.append(f"key '{key}' not found")
            continue
        pending.append((entry, attr_vals))

    if not pending:
        return 0, errors

    # Apply right-to-left so earlier spans stay valid
    pending.sort(key=lambda t: t[0].span.start, reverse=True)

    applied = 0
    for entry, attr_vals in pending:
        for attr, value in attr_vals:
            set_value(entry, attr, value)
            applied += 1
        new_text = serialize_entry(entry)
        src = src[: entry.span.start] + new_text + src[entry.span.end :]

    if not DRY_RUN:
        ftl_path.write_text(src, encoding="utf-8")

    return applied, errors


# ---------------------------------------------------------------------------
# CSV reader
# ---------------------------------------------------------------------------

def read_csv(path: Path) -> list[dict]:
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def import_csv(csv_path: Path) -> tuple[int, int, int]:
    """Process one CSV file. Returns (applied, skipped, errors)."""
    try:
        rows = read_csv(csv_path)
    except Exception as e:
        print(c(RED, f"  Error reading {csv_path}: {e}"))
        return 0, 0, 1

    if not rows:
        return 0, 0, 0

    # Validate expected columns
    required = {"file", "key", "translation"}
    if not required.issubset(rows[0].keys()):
        missing_cols = required - rows[0].keys()
        print(c(RED, f"  {csv_path.name}: missing columns: {', '.join(missing_cols)}"))
        return 0, 0, 1

    # Group edits by target FTL file
    by_file: dict[Path, list[tuple[str, str | None, str, str]]] = {}
    skipped = 0

    for row in rows:
        translation = row.get("translation", "").strip()
        if not translation:
            skipped += 1
            continue

        ftl_rel = row["file"].strip()
        keyspec  = row["key"].strip()
        key, attr = (keyspec.split(".", 1) if "." in keyspec else (keyspec, None))

        ftl_abs = MODS_DIR / ftl_rel
        by_file.setdefault(ftl_abs, []).append((key, attr, translation, keyspec))

    total_applied = 0
    total_errors  = 0

    for ftl_abs, edits in sorted(by_file.items()):
        ftl_rel = ftl_abs.relative_to(MODS_DIR)

        if not ftl_abs.exists():
            print(c(RED, f"  MISSING: {ftl_rel}"))
            total_errors += len(edits)
            continue

        edit_tuples = [(k, a, v) for k, a, v, _ in edits]
        applied, errors = apply_to_file(ftl_abs, edit_tuples)

        tag = c(YELLOW, "[dry-run] ") if DRY_RUN else ""
        print(c(CYAN, f"  {ftl_rel}"))
        for _, _, value, keyspec in edits:
            status = c(GREEN, "  ✓") if not errors else c(RED, "  ✗")
            print(f"    {status} {keyspec}  →  {value}")
        for err in errors:
            print(c(RED, f"    ✗ {err}"))

        total_applied += applied
        total_errors  += len(errors)

    return total_applied, skipped, total_errors


# ---------------------------------------------------------------------------

def collect_csv_files(target: Path) -> list[Path]:
    if target.is_file():
        return [target]
    if target.is_dir():
        files = sorted(target.glob("*.csv"))
        if not files:
            print(c(YELLOW, f"No *.csv files found in {target}"))
        return files
    print(c(RED, f"Error: '{target}' is not a file or directory"))
    sys.exit(1)


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        print(__doc__)
        sys.exit(1)

    target = Path(args[0])
    csv_files = collect_csv_files(target)

    if not MODS_DIR.exists():
        print(c(RED, f"Error: mods/ not found at {MODS_DIR}"))
        sys.exit(1)

    grand_applied = grand_skipped = grand_errors = 0

    for csv_path in csv_files:
        print(c(BOLD, f"\n{csv_path.name}"))
        applied, skipped, errors = import_csv(csv_path)
        grand_applied += applied
        grand_skipped += skipped
        grand_errors  += errors

    print()
    print(c(BOLD, "=" * 50))
    dry = c(YELLOW, "  [dry-run]") if DRY_RUN else ""
    print(f"  Applied:  {c(GREEN, str(grand_applied))}{dry}")
    print(f"  Skipped:  {c(DIM,  str(grand_skipped))}  (empty translation column)")
    if grand_errors:
        print(f"  Errors:   {c(RED, str(grand_errors))}")
    print(c(BOLD, "=" * 50))


if __name__ == "__main__":
    main()
