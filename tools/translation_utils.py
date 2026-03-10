"""Shared utilities for OpenRA translation tools."""

from pathlib import Path


def get_base_files(mods_dir: Path, *, mod_filter: str | None = None,
                   file_filter: str | None = None,
                   map_filter: str | None = None) -> list[tuple[Path, Path]]:
    """Return list of (rel_path, abs_path) for base (English) FTL files.

    Discovers two kinds of base files:
    - Fluent files: mods/**/fluent/*.ftl (not in a lang subdir)
    - Map briefings: mods/**/maps/*/map.ftl
    """
    result = []
    for ftl in sorted(mods_dir.rglob("*.ftl")):
        rel = ftl.relative_to(mods_dir)
        parts = rel.parts
        mod_name = parts[0]
        if mod_filter and mod_name != mod_filter:
            continue
        # Fluent files: directly under fluent/ (no lang subdir)
        if "fluent" in parts:
            fi = parts.index("fluent")
            if len(parts) != fi + 2:
                continue  # skip lang subdirs
            filename = parts[fi + 1]
            if file_filter and filename != file_filter:
                continue
            if map_filter:
                continue  # --map only applies to map files
            result.append((rel, ftl))
            continue
        # Map briefings: mods/**/maps/*/map.ftl
        if ftl.name == "map.ftl" and "maps" in parts:
            if file_filter and file_filter != "map.ftl":
                continue
            mi = parts.index("maps")
            if map_filter and (mi + 1 >= len(parts) or parts[mi + 1] != map_filter):
                continue
            result.append((rel, ftl))
    return result


def lang_file_for(mods_dir: Path, base_rel: Path, lang: str) -> tuple[Path, Path]:
    """Return (rel_path, abs_path) for the language file corresponding to a base file.

    Fluent files: mods/cnc/fluent/chrome.ftl -> mods/cnc/fluent/<lang>/chrome.ftl
    Map files:    mods/cnc/maps/gdi02/map.ftl -> mods/cnc/maps/gdi02/map.<lang>.ftl
    """
    parts = list(base_rel.parts)
    if "fluent" in parts:
        fi = parts.index("fluent")
        lang_parts = parts[:fi + 1] + [lang] + [parts[fi + 1]]
        lang_abs = mods_dir / Path(*lang_parts)
    else:
        # map.ftl -> map.<lang>.ftl in the same directory
        lang_abs = mods_dir / base_rel.parent / f"map.{lang}.ftl"
    return lang_abs.relative_to(mods_dir), lang_abs
