#!/usr/bin/env python3
"""MCP server exposing the OpenRA translation toolset.

Tools:
    list_languages          - discover available language codes
    check_translations      - report completeness for one or more languages
    get_issues              - structured list of issues for a language (JSON)
    translate_key           - set a single key's translation in an FTL file
    export_csv              - export issues to CSV files for batch translation
    import_csv              - import a filled CSV (or directory) back into FTL files
    create_stubs            - bootstrap FTL stubs for a new language

Registered in .mcp.json at the repo root.
"""

import json
import subprocess
import sys
from pathlib import Path

from mcp.server.fastmcp import FastMCP

REPO_ROOT = Path(__file__).parent.parent
TOOLS_DIR = REPO_ROOT / "tools"
PYTHON = sys.executable  # same venv that's running this server

mcp = FastMCP("openra-translations")


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _run(script: str, args: list[str]) -> str:
    """Run a tool script and return combined stdout+stderr."""
    result = subprocess.run(
        [PYTHON, str(TOOLS_DIR / script)] + args,
        capture_output=True,
        text=True,
        cwd=str(REPO_ROOT),
    )
    out = result.stdout
    if result.stderr:
        out += "\n" + result.stderr
    return out.strip()


# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------

@mcp.tool()
def list_languages() -> str:
    """List all language codes that have at least one FTL translation directory."""
    mods_dir = REPO_ROOT / "mods"
    import re
    langs: set[str] = set()
    for fluent_dir in mods_dir.rglob("fluent"):
        if not fluent_dir.is_dir():
            continue
        for child in fluent_dir.iterdir():
            if child.is_dir() and re.match(r"^[a-z]{2}(-[A-Z]{2})?$", child.name):
                langs.add(child.name)
    return json.dumps(sorted(langs))


@mcp.tool()
def get_registered_languages() -> str:
    """Return language support levels based on mod.yaml FluentTranslations.

    The engine has two translation tiers:
    - "full": language is in FluentTranslations — UI, rules, hotkeys AND mission strings
      are translated.
    - "map-only": language has translation files on disk but is NOT in FluentTranslations
      — only mission strings (campaign.ftl, lua.ftl) are translated automatically via the
      path convention; UI/rules strings remain English.

    Returns JSON: {"full": {"lang": ["mod1", ...]}, "map_only": ["lang", ...]}
    """
    mods_dir = REPO_ROOT / "mods"
    import re

    # Parse FluentTranslations from all mod.yaml files
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

    # Discover all languages with translation files
    all_langs: set[str] = set()
    for fluent_dir in mods_dir.rglob("fluent"):
        if not fluent_dir.is_dir():
            continue
        for child in fluent_dir.iterdir():
            if child.is_dir() and re.match(r"^[a-z]{2}(-[A-Z]{2})?$", child.name):
                all_langs.add(child.name)

    full = {lang: sorted(mods) for lang, mods in sorted(registrations.items())}
    map_only = sorted(lang for lang in all_langs if lang not in registrations)

    return json.dumps({"full": full, "map_only": map_only}, ensure_ascii=False, indent=2)


@mcp.tool()
def check_translations(
    langs: list[str] | None = None,
    missing_only: bool = False,
) -> str:
    """Report translation completeness.

    Args:
        langs: Language codes to check (e.g. ["sk", "pl"]). Omit for all languages.
        missing_only: Only report missing files, skip per-key details.
    """
    args = ["--no-color"]
    if missing_only:
        args.append("--missing-only")
    if langs:
        args.extend(langs)
    return _run("check_translations.py", args)


@mcp.tool()
def get_issues(
    langs: list[str] | None = None,
    status_filter: str | None = None,
) -> str:
    """Return translation issues as a JSON array for programmatic use.

    Each item has: lang, file, key, status (MISSING|UNTRANSLATED), english, current.

    Args:
        langs: Language codes to check. Omit for all.
        status_filter: "MISSING" or "UNTRANSLATED" to filter; omit for both.
    """
    args = ["--no-color", "--json"]
    if langs:
        args.extend(langs)
    raw = _run("check_translations.py", args)
    # raw is JSON array printed to stdout; strip any leading summary text
    start = raw.find("[")
    if start == -1:
        return "[]"
    issues = json.loads(raw[start:])
    if status_filter:
        issues = [i for i in issues if i["status"] == status_filter.upper()]
    return json.dumps(issues, ensure_ascii=False, indent=2)


@mcp.tool()
def translate_key(
    lang: str,
    key: str,
    value: str,
    mod: str | None = None,
    file: str | None = None,
    map_name: str | None = None,
    dry_run: bool = False,
) -> str:
    """Set a single translation entry in an FTL file.

    Args:
        lang:     Language code (e.g. "sk").
        key:      FTL key, optionally with attribute suffix (e.g. "checkbox-fog-of-war.label").
        value:    The translated string.
        mod:      Limit search to a specific mod directory (e.g. "common", "cnc").
        file:     Limit search to a specific filename (e.g. "chrome.ftl").
        map_name: Limit search to a specific map directory (e.g. "gdi02", "soviet-01").
                  Use this for map briefing translations where the key "briefing" is shared.
        dry_run:  Show what would change without writing.
    """
    args = ["--no-color", lang, key, value]
    if mod:
        args += ["--mod", mod]
    if map_name:
        args += ["--map", map_name]
    if file:
        args += ["--file", file]
    if dry_run:
        args.append("--dry-run")
    return _run("translate.py", args)


@mcp.tool()
def export_csv(
    langs: list[str] | None = None,
    csv_dir: str = ".translation_work",
    limit: int = 100,
    export_all: bool = False,
) -> str:
    """Export translation issues to CSV files for batch translation.

    Creates one file per language (or paginated files when export_all=True).
    Each CSV has columns: file, key, status, english, current, translation.
    Fill in the 'translation' column and then call import_csv.

    Args:
        langs:      Language codes to export. Omit for all.
        csv_dir:    Output directory for CSV files.
        limit:      Max rows per CSV file (default 100).
        export_all: Create multiple paginated files instead of truncating.
    """
    args = ["--no-color", "--csv", csv_dir, "--limit", str(limit)]
    if export_all:
        args.append("--export-all")
    if langs:
        args.extend(langs)
    return _run("check_translations.py", args)


@mcp.tool()
def import_csv(
    path: str,
    dry_run: bool = False,
) -> str:
    """Import translations from a filled CSV file (or directory of CSV files).

    Only rows where the 'translation' column is non-empty are applied.
    Missing attributes on a message are appended; existing values are updated in-place.

    Args:
        path:    Path to a .csv file or a directory containing *.csv files.
        dry_run: Show what would change without writing FTL files.
    """
    args = ["--no-color", path]
    if dry_run:
        args.append("--dry-run")
    return _run("import_translations.py", args)


@mcp.tool()
def create_stubs(langs: list[str]) -> str:
    """Bootstrap FTL stub files for one or more new (or missing) languages.

    Copies every base English FTL file into mods/**/fluent/{lang}/ so the
    language is immediately functional. All keys will be flagged as UNTRANSLATED
    until real translations are provided.

    Args:
        langs: Language codes to bootstrap (e.g. ["de", "fr"]).
    """
    if not langs:
        return "Error: at least one language code is required."
    args = ["--no-color", "--create-stubs"] + langs
    return _run("check_translations.py", args)


# ---------------------------------------------------------------------------

if __name__ == "__main__":
    mcp.run()
