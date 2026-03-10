#!/usr/bin/env python3
"""Set a single translation in an FTL file.

Usage:
    translate.py <lang> <key>[.<attr>] <value> [options]

Arguments:
    lang        Language code (e.g. sk, pl, cs)
    key[.attr]  FTL message key, optionally with attribute (e.g. checkbox-fog-of-war.label)
    value       Translated string

Options:
    --mod <mod>     Limit search to a specific mod directory (e.g. common, cnc, ra)
    --file <file>   Limit search to a specific filename (e.g. chrome.ftl, rules.ftl)
    --map <map>     Limit search to a specific map directory (e.g. gdi02, soviet-01)
    --dry-run       Show what would change without writing

Examples:
    translate.py sk label-assetbrowser-title "Prehliadač súborov"
    translate.py sk checkbox-fog-of-war.label "Hmla vojny" --mod common
    translate.py pl actor-heli.name "Apache" --file rules.ftl --dry-run
    translate.py cs briefing "Braňte pozici..." --map gdi02
"""

import sys
from pathlib import Path

try:
    from fluent.syntax import FluentParser, FluentSerializer
    from fluent.syntax import ast as fast
except ImportError:
    print("fluent.syntax not found. Run: pip install fluent.syntax")
    sys.exit(1)

from translation_utils import get_base_files, lang_file_for

MODS_DIR = Path(__file__).parent.parent / "mods"
PARSER = FluentParser(with_spans=True)
SERIALIZER = FluentSerializer()

# ANSI
RED = "\033[91m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
CYAN = "\033[96m"
BOLD = "\033[1m"
DIM = "\033[2m"
RESET = "\033[0m"

NO_COLOR = not sys.stdout.isatty() or "--no-color" in sys.argv


def c(color, text):
    return text if NO_COLOR else f"{color}{text}{RESET}"


# ---------------------------------------------------------------------------

def parse_file(path: Path):
    """Parse FTL file, return (source_text, resource)."""
    src = path.read_text(encoding="utf-8")
    return src, PARSER.parse(src)


def find_entry(resource, key: str):
    """Find a Message or Term in the resource by key name."""
    for entry in resource.body:
        if isinstance(entry, (fast.Message, fast.Term)) and entry.id.name == key:
            return entry
    return None


def set_value(entry, attr: str | None, new_text: str):
    """Mutate entry to set the value or named attribute to new_text."""
    new_pattern = fast.Pattern(elements=[fast.TextElement(value=new_text)])
    if attr is None:
        entry.value = new_pattern
    else:
        for a in entry.attributes:
            if a.id.name == attr:
                a.value = new_pattern
                return
        raise ValueError(f"Attribute '{attr}' not found on key '{entry.id.name}'")


def serialize_entry(entry) -> str:
    """Serialize a single entry to FTL text (no trailing newline)."""
    resource = fast.Resource(body=[entry])
    return SERIALIZER.serialize(resource).strip()


def apply_change(src: str, entry, new_entry_text: str) -> str:
    """Replace the entry's span in src with new_entry_text."""
    return src[: entry.span.start] + new_entry_text + src[entry.span.end :]


# ---------------------------------------------------------------------------

def key_exists_in_base(mods_dir: Path, key: str, attr: str | None,
                        mod_filter: str | None, file_filter: str | None,
                        map_filter: str | None = None) -> list[Path]:
    """Return list of base files that contain the given key."""
    matches = []
    for rel, abs_path in get_base_files(mods_dir, mod_filter=mod_filter, file_filter=file_filter, map_filter=map_filter):
        _, resource = parse_file(abs_path)
        entry = find_entry(resource, key)
        if entry is None:
            continue
        if attr is not None:
            if not any(a.id.name == attr for a in entry.attributes):
                continue
        matches.append(rel)
    return matches


def run(lang: str, keyspec: str, value: str,
        mod_filter: str | None, file_filter: str | None, map_filter: str | None,
        dry_run: bool):

    # Split key and optional attribute
    if "." in keyspec:
        key, attr = keyspec.split(".", 1)
    else:
        key, attr = keyspec, None

    display_key = keyspec

    # Find which base files contain this key
    base_matches = key_exists_in_base(MODS_DIR, key, attr, mod_filter, file_filter, map_filter)

    if not base_matches:
        print(c(RED, f"Error: key '{display_key}' not found in any base English file"))
        if mod_filter or file_filter:
            print(c(DIM, "  (check --mod / --file filters)"))
        sys.exit(1)

    if len(base_matches) > 1:
        print(c(YELLOW, f"Key '{display_key}' found in {len(base_matches)} files:"))
        for rel in base_matches:
            print(c(DIM, f"  {rel}"))
        print(c(YELLOW, "Use --mod, --file, or --map to narrow down."))
        sys.exit(1)

    base_rel = base_matches[0]
    lang_rel, lang_abs = lang_file_for(MODS_DIR, base_rel, lang)

    auto_created = False
    if not lang_abs.exists():
        # For map briefings, auto-create the lang file from the English base
        if base_rel.name == "map.ftl":
            base_src = None
            for _, abs_path in get_base_files(MODS_DIR):
                if abs_path.relative_to(MODS_DIR) == base_rel:
                    base_src = abs_path.read_text(encoding="utf-8")
                    break
            if base_src:
                if dry_run:
                    print(c(YELLOW, f"  Would create {lang_rel} from {base_rel}"))
                else:
                    lang_abs.write_text(base_src, encoding="utf-8")
                    print(c(YELLOW, f"  Created {lang_rel} from {base_rel}"))
                auto_created = True
            else:
                print(c(RED, f"Error: translation file does not exist: {lang_rel}"))
                sys.exit(1)
        else:
            print(c(RED, f"Error: translation file does not exist: {lang_rel}"))
            print(c(DIM, "  Run check_translations.py --create-stubs first."))
            sys.exit(1)

    if dry_run and auto_created:
        # Parse the English base directly — the lang file wasn't written
        base_abs = MODS_DIR / base_rel
        src, resource = parse_file(base_abs)
    else:
        src, resource = parse_file(lang_abs)
    entry = find_entry(resource, key)

    if entry is None:
        print(c(RED, f"Error: key '{key}' not found in {lang_rel}"))
        print(c(DIM, "  The translation file may be out of sync with the base file."))
        sys.exit(1)

    # Show current value
    if attr is None:
        if entry.value:
            cur_text = "".join(
                e.value if isinstance(e, fast.TextElement) else "{…}"
                for e in entry.value.elements
            ).strip()
        else:
            cur_text = "(no value)"
    else:
        cur_attr = next((a for a in entry.attributes if a.id.name == attr), None)
        if cur_attr is None:
            print(c(RED, f"Error: attribute '.{attr}' not found on '{key}' in {lang_rel}"))
            sys.exit(1)
        cur_text = "".join(
            e.value if isinstance(e, fast.TextElement) else "{…}"
            for e in cur_attr.value.elements
        ).strip()

    print(c(CYAN, f"  file:  {lang_rel}"))
    print(c(DIM,  f"  key:   {display_key}"))
    print(c(DIM,  f"  from:  {cur_text}"))
    print(c(GREEN, f"  to:    {value}"))

    if dry_run:
        print(c(YELLOW, "\n  [dry-run] no changes written"))
        return

    # Mutate and write back using span replacement
    set_value(entry, attr, value)
    new_entry_text = serialize_entry(entry)
    new_src = apply_change(src, entry, new_entry_text)
    lang_abs.write_text(new_src, encoding="utf-8")

    print(c(GREEN, "\n  Written."))


# ---------------------------------------------------------------------------

def parse_args():
    args = sys.argv[1:]

    def pop_flag(flag):
        if flag in args:
            args.remove(flag)
            return True
        return False

    def pop_option(flag):
        if flag in args:
            i = args.index(flag)
            val = args[i + 1]
            del args[i:i + 2]
            return val
        return None

    dry_run = pop_flag("--dry-run")
    pop_flag("--no-color")
    mod_filter = pop_option("--mod")
    file_filter = pop_option("--file")
    map_filter = pop_option("--map")

    if len(args) < 3:
        print(__doc__)
        sys.exit(1)

    lang, keyspec, *rest = args
    value = " ".join(rest)
    return lang, keyspec, value, mod_filter, file_filter, map_filter, dry_run


def main():
    if not MODS_DIR.exists():
        print(f"Error: mods/ not found at {MODS_DIR}")
        sys.exit(1)

    lang, keyspec, value, mod_filter, file_filter, map_filter, dry_run = parse_args()
    run(lang, keyspec, value, mod_filter, file_filter, map_filter, dry_run)


if __name__ == "__main__":
    main()
