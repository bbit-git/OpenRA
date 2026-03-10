#!/usr/bin/env python3
"""Check translation completeness for OpenRA FTL files.

Usage:
    python3 check_translations.py [lang ...] [options]

Options:
    --missing-only          Only show missing files, skip per-key details
    --create-stubs          Copy English files as stubs for missing lang files
    --csv [dir]             Export issues to CSV files (one per language, default dir: .)
    --limit N               Max rows per CSV export (default: 100)
    --no-color              Disable ANSI colour output

Examples:
    python3 check_translations.py
    python3 check_translations.py sk pl
    python3 check_translations.py sk --csv exports/
    python3 check_translations.py --csv --limit 50
"""

import csv
import json
import re
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

try:
    from fluent.syntax import FluentParser
    from fluent.syntax import ast as fast
    from fluent.syntax import serialize
except ImportError:
    print("fluent.syntax not found. Run: pip install fluent.syntax")
    sys.exit(1)

from translation_utils import get_base_files, lang_file_for

MODS_DIR = Path(__file__).parent.parent / "mods"
PARSER = FluentParser(with_spans=False)

# ANSI colors
RED = "\033[91m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
CYAN = "\033[96m"
BOLD = "\033[1m"
DIM = "\033[2m"
RESET = "\033[0m"

NO_COLOR = not sys.stdout.isatty() or "--no-color" in sys.argv
MISSING_ONLY = "--missing-only" in sys.argv
CREATE_STUBS = "--create-stubs" in sys.argv


def c(color, text):
    return text if NO_COLOR else f"{color}{text}{RESET}"


@dataclass
class Issue:
    lang: str
    file: str        # relative path of the translation file
    key: str         # key[.attr]
    status: str      # "MISSING" or "UNTRANSLATED"
    english: str     # English source value
    current: str     # current translation value (empty if missing)


def value_to_text(value) -> str:
    """Extract plain text from a FTL Pattern (for identical-value detection)."""
    if value is None:
        return ""
    parts = []
    for elem in value.elements:
        if isinstance(elem, fast.TextElement):
            parts.append(elem.value)
        else:
            parts.append("{…}")  # placeable
    return "".join(parts).strip()


def parse_ftl(path: Path) -> dict[str, dict]:
    """Parse FTL file. Returns dict of:
        key -> {
            "value": str,          # plain text of top-level value (or "")
            "attrs": {name: str},  # plain text of each attribute
        }
    """
    with open(path, encoding="utf-8") as f:
        resource = PARSER.parse(f.read())

    entries = {}
    for entry in resource.body:
        if not isinstance(entry, (fast.Message, fast.Term)):
            continue
        key = entry.id.name
        entries[key] = {
            "value": value_to_text(entry.value),
            "attrs": {
                attr.id.name: value_to_text(attr.value)
                for attr in entry.attributes
            },
        }
    return entries


def discover_languages(mods_dir: Path) -> list[str]:
    """Find all language codes present as subdirs under any fluent/ directory."""
    langs = set()
    for fluent_dir in mods_dir.rglob("fluent"):
        if not fluent_dir.is_dir():
            continue
        for child in fluent_dir.iterdir():
            if child.is_dir() and re.match(r"^[a-z]{2}(-[A-Z]{2})?$", child.name):
                langs.add(child.name)
    return sorted(langs)


# Keys that are intentionally the same in all languages
SKIP_IDENTICAL = frozenset({"ok", "id", ""})

# Single-word / abbreviation values that may be the same across languages
SKIP_IDENTICAL_RE = re.compile(r"^[A-Z][a-z]?$|^\d+$|^[A-Z]+$")


def is_likely_untranslated(key: str, en_val: str, tr_val: str) -> bool:
    if en_val == tr_val and en_val.lower() not in SKIP_IDENTICAL:
        if not SKIP_IDENTICAL_RE.match(en_val):
            return True
    return False


FIELDNAMES = ["file", "key", "status", "english", "current", "translation"]


def _write_single_csv(path: Path, rows: list[Issue]):
    with open(path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writeheader()
        for issue in rows:
            writer.writerow({
                "file": issue.file,
                "key": issue.key,
                "status": issue.status,
                "english": issue.english,
                "current": issue.current,
                "translation": "",
            })


def write_csv(issues: list[Issue], langs: list[str], out_dir: Path, limit: int, export_all: bool):
    out_dir.mkdir(parents=True, exist_ok=True)
    for lang in langs:
        lang_issues = [i for i in issues if i.lang == lang]
        if not lang_issues:
            continue
        total = len(lang_issues)

        if export_all and total > limit:
            pages = range(0, total, limit)
            for page_idx, offset in enumerate(pages, start=1):
                chunk = lang_issues[offset : offset + limit]
                path = out_dir / f"{lang}_{page_idx}.csv"
                _write_single_csv(path, chunk)
                print(c(CYAN, f"  CSV: {path}") + c(DIM, f"  {len(chunk)} rows  (page {page_idx}/{len(pages)})"))
        else:
            rows = lang_issues[:limit]
            path = out_dir / f"{lang}.csv"
            _write_single_csv(path, rows)
            truncated = f" (showing {limit}/{total}, use --export-all for more)" if total > limit else ""
            print(c(CYAN, f"  CSV: {path}") + c(DIM, f"  {len(rows)} rows{truncated}"))


def parse_mod_yamls(mods_dir: Path) -> dict[str, set[str]]:
    """Return {lang: {mod_name, ...}} for languages registered in FluentTranslations.

    A language is "registered" for a mod if it appears in that mod's FluentTranslations
    section in mod.yaml. Registered languages get full mod-level (UI/rules) translations
    loaded by the engine. Unregistered languages only benefit from map-level translations
    (campaign.ftl, lua.ftl) via the automatic path convention in FluentProvider.
    """
    registrations: dict[str, set[str]] = {}
    for mod_dir in sorted(mods_dir.iterdir()):
        if not mod_dir.is_dir():
            continue
        yaml_path = mod_dir / "mod.yaml"
        if not yaml_path.exists():
            continue
        mod_name = mod_dir.name
        in_section = False
        with open(yaml_path, encoding="utf-8") as f:
            for line in f:
                stripped = line.rstrip()
                if not stripped or stripped.lstrip().startswith("#"):
                    continue
                depth = len(stripped) - len(stripped.lstrip("\t"))
                content = stripped.strip()
                if depth == 0:
                    in_section = content == "FluentTranslations:"
                elif depth == 1 and in_section and content.endswith(":"):
                    registrations.setdefault(content[:-1], set()).add(mod_name)
    return registrations


def check_translations(mods_dir: Path, filter_langs: list[str] | None = None) -> list[Issue]:
    base_files = get_base_files(mods_dir)
    all_langs = discover_languages(mods_dir)

    if filter_langs:
        unknown = [l for l in filter_langs if l not in all_langs]
        if unknown and not CREATE_STUBS:
            print(c(YELLOW, f"Warning: unknown language(s): {', '.join(unknown)}"))
        # When creating stubs, keep unknown langs — they are the point of the operation
        langs = filter_langs if CREATE_STUBS else [l for l in filter_langs if l in all_langs]
    else:
        langs = all_langs

    print(c(BOLD, f"Base files: {len(base_files)}  |  Languages: {', '.join(langs)}\n"))

    all_issues: list[Issue] = []

    # Per-lang cumulative stats
    stats: dict[str, dict] = {
        lang: {"total": 0, "translated": 0, "missing_files": 0, "missing_keys": 0, "untranslated": 0}
        for lang in langs
    }

    for rel, abs_base in base_files:
        base_kvs = parse_ftl(abs_base)
        if not base_kvs:
            continue

        # Flatten keys to (key, subkey) pairs for counting
        # subkey is None for top-level value, or attribute name
        flat_base: list[tuple[str, str | None, str]] = []
        for key, info in base_kvs.items():
            if info["value"]:
                flat_base.append((key, None, info["value"]))
            for attr_name, attr_val in info["attrs"].items():
                flat_base.append((key, attr_name, attr_val))

        total = len(flat_base)
        file_header_printed = False

        def print_file_header():
            nonlocal file_header_printed
            if not file_header_printed:
                print(c(CYAN, f"  {rel}") + c(DIM, f"  ({total} keys)"))
                file_header_printed = True

        for lang in langs:
            lang_rel, lang_abs = lang_file_for(mods_dir, rel, lang)

            stats[lang]["total"] += total

            if not lang_abs.exists():
                print_file_header()
                if CREATE_STUBS:
                    lang_abs.parent.mkdir(parents=True, exist_ok=True)
                    lang_abs.write_text(abs_base.read_text(encoding="utf-8"), encoding="utf-8")
                    print(c(YELLOW, f"    [{lang}] CREATED STUB: {lang_rel}"))
                    stats[lang]["missing_files"] += 1
                    stats[lang]["untranslated"] += total
                    for key, subkey, en_val in flat_base:
                        display = f"{key}" if subkey is None else f"{key}.{subkey}"
                        all_issues.append(Issue(lang, str(lang_rel), display, "UNTRANSLATED", en_val, en_val))
                else:
                    print(c(RED, f"    [{lang}] MISSING FILE: {lang_rel}"))
                    stats[lang]["missing_files"] += 1
                    stats[lang]["missing_keys"] += total
                    for key, subkey, en_val in flat_base:
                        display = f"{key}" if subkey is None else f"{key}.{subkey}"
                        all_issues.append(Issue(lang, str(lang_rel), display, "MISSING", en_val, ""))
                continue

            lang_kvs = parse_ftl(lang_abs)
            missing = []
            untranslated = []

            for key, subkey, en_val in flat_base:
                display = f"{key}" if subkey is None else f"{key}.{subkey}"

                if key not in lang_kvs:
                    missing.append((display, en_val))
                    continue

                lang_info = lang_kvs[key]
                if subkey is None:
                    tr_val = lang_info["value"]
                else:
                    if subkey not in lang_info["attrs"]:
                        missing.append((display, en_val))
                        continue
                    tr_val = lang_info["attrs"][subkey]

                if is_likely_untranslated(display, en_val, tr_val):
                    untranslated.append((display, en_val, tr_val))

            ok = total - len(missing) - len(untranslated)
            stats[lang]["translated"] += ok
            stats[lang]["missing_keys"] += len(missing)
            stats[lang]["untranslated"] += len(untranslated)

            for display, en_val in missing:
                all_issues.append(Issue(lang, str(lang_rel), display, "MISSING", en_val, ""))
            for display, en_val, tr_val in untranslated:
                all_issues.append(Issue(lang, str(lang_rel), display, "UNTRANSLATED", en_val, tr_val))

            has_issues = missing or untranslated
            if has_issues and not MISSING_ONLY:
                print_file_header()
                pct = 100 * ok // total if total else 100
                col = GREEN if pct >= 90 else YELLOW if pct >= 50 else RED
                print(f"    [{lang}] " + c(col, f"{pct:3d}%") + c(DIM, f"  ({ok}/{total})"))
                for display, en_val in missing:
                    print(c(RED, f"      - MISSING:      {display}"))
                for display, en_val, tr_val in untranslated:
                    short = en_val[:70] + ("…" if len(en_val) > 70 else "")
                    print(c(YELLOW, f"      ~ UNTRANSLATED: {display}") + c(DIM, f"  = {short}"))

        if file_header_printed:
            print()

    # Summary
    registrations = parse_mod_yamls(mods_dir)  # lang -> set of mod names

    print(c(BOLD, "=" * 84))
    print(c(BOLD, "SUMMARY"))
    print(c(BOLD, "=" * 84))
    print(c(DIM,
        f"{'Language':<12}  {'Files':>12}  {'Keys':>8}  {'Translated':>12}  {'Missing':>8}  {'Identical':>9}  {'%':>4}  {'Support':<10}"
    ))
    print(c(DIM, "-" * 84))

    for lang in langs:
        s = stats[lang]
        total = s["total"]
        tr = s["translated"]
        pct = 100 * tr // total if total else 100
        col = GREEN if pct >= 90 else YELLOW if pct >= 50 else RED
        files_ok = len(base_files) - s["missing_files"]
        mods_reg = registrations.get(lang, set())
        support = c(GREEN, "full") if mods_reg else c(YELLOW, "map-only")
        print(
            f"{lang:<12}"
            f"  {files_ok:>5}/{len(base_files):<5}"
            f"  {total:>8}"
            f"  {tr:>12}"
            f"  {s['missing_keys']:>8}"
            f"  {s['untranslated']:>9}"
            f"  {c(col, f'{pct:3d}%')}"
            f"  {support}"
        )

    map_only = [l for l in langs if not registrations.get(l)]
    if map_only:
        print()
        print(c(YELLOW, f"Map-only languages ({', '.join(map_only)}):"))
        print(c(DIM,    "  Mission strings (campaign.ftl, lua.ftl) are translated automatically."))
        print(c(DIM,    "  UI/rules strings won't be translated until added to FluentTranslations in mod.yaml."))

    return all_issues, langs


def parse_flag(flag: str, default=None):
    """Extract --flag [value] from sys.argv. Returns (value_or_True, cleaned_argv)."""
    args = sys.argv[1:]
    if flag not in args:
        return default
    i = args.index(flag)
    # If next token exists and doesn't start with --, treat as value
    if i + 1 < len(args) and not args[i + 1].startswith("--"):
        return args[i + 1]
    return True  # flag present but no value


def main():
    args = sys.argv[1:]

    def pop_flag(flag):
        if flag in args:
            args.remove(flag)
            return True
        return False

    def pop_option(flag, default=None):
        if flag in args:
            i = args.index(flag)
            if i + 1 < len(args) and not args[i + 1].startswith("--"):
                val = args[i + 1]
                del args[i:i + 2]
                return val
            del args[i]
            return True  # flag without value
        return default

    pop_flag("--no-color")
    pop_flag("--missing-only")
    pop_flag("--create-stubs")
    export_all = pop_flag("--export-all")
    json_out   = pop_flag("--json")

    csv_out = pop_option("--csv", default=None)  # None = no CSV, True = cwd, str = path
    limit_raw = pop_option("--limit", default=None)
    limit = int(limit_raw) if limit_raw and limit_raw is not True else 100

    filter_langs = args if args else None

    if not MODS_DIR.exists():
        print(f"Error: mods/ not found at {MODS_DIR}")
        sys.exit(1)

    if json_out:
        import io
        _real_stdout, sys.stdout = sys.stdout, io.StringIO()
        issues, langs = check_translations(MODS_DIR, filter_langs)
        sys.stdout = _real_stdout
        print(json.dumps([asdict(i) for i in issues], ensure_ascii=False, indent=2))
        return

    issues, langs = check_translations(MODS_DIR, filter_langs)

    if csv_out is not None:
        out_dir = Path(".") if csv_out is True else Path(csv_out)
        print()
        write_csv(issues, langs, out_dir, limit, export_all)


if __name__ == "__main__":
    main()
