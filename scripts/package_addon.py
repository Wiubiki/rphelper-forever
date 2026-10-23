#!/usr/bin/env python3
"""Build and validate the deterministic RPHelper prerelease archive."""

from __future__ import annotations

import argparse
import hashlib
import os
from pathlib import Path, PurePosixPath
import re
import tempfile
import zipfile


REPOSITORY = Path(__file__).resolve().parents[1]
ADDON_NAME = "RPHelper"
ADDON_DIR = REPOSITORY / ADDON_NAME
TOC_PATH = ADDON_DIR / f"{ADDON_NAME}.toc"
DIST_DIR = REPOSITORY / "dist"
FIXED_TIMESTAMP = (1980, 1, 1, 0, 0, 0)
NOTICES = {
    REPOSITORY / "LICENSE": PurePosixPath(ADDON_NAME, "Documentation", "LICENSE"),
    REPOSITORY / "CONTENT_RIGHTS.txt": PurePosixPath(
        ADDON_NAME, "Documentation", "CONTENT_RIGHTS.txt"
    ),
    REPOSITORY / "CREDITS.txt": PurePosixPath(
        ADDON_NAME, "Documentation", "CREDITS.txt"
    ),
}
DISALLOWED_PARTS = {
    ".git",
    ".github",
    "tests",
    "tmp",
    "scripts",
    "audits",
    "__pycache__",
}


class PackageError(RuntimeError):
    """A source or archive cannot satisfy the package contract."""


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def display_path(path: Path) -> str:
    try:
        return str(path.relative_to(REPOSITORY))
    except ValueError:
        return str(path)


def safe_local_lua(raw: str) -> PurePosixPath:
    if "\\" in raw or raw.startswith("/") or raw != raw.strip():
        raise PackageError(f"invalid local Lua manifest entry: {raw!r}")
    path = PurePosixPath(raw)
    if (
        path.suffix != ".lua"
        or not path.parts
        or any(part in {"", ".", ".."} for part in path.parts)
    ):
        raise PackageError(f"invalid local Lua manifest entry: {raw!r}")
    if path.as_posix() != raw:
        raise PackageError(f"non-normalized Lua manifest entry: {raw!r}")
    return path


def read_manifest() -> tuple[dict[str, str], list[PurePosixPath]]:
    if not TOC_PATH.is_file() or TOC_PATH.is_symlink():
        raise PackageError(f"missing or unsafe addon manifest: {TOC_PATH}")
    metadata: dict[str, str] = {}
    entries: list[PurePosixPath] = []
    seen: set[PurePosixPath] = set()
    for number, raw_line in enumerate(
        TOC_PATH.read_text(encoding="utf-8").splitlines(), 1
    ):
        if raw_line.startswith("##"):
            match = re.fullmatch(r"##\s*([^:]+):\s*(.*?)\s*", raw_line)
            if not match:
                raise PackageError(f"malformed TOC metadata on line {number}: {raw_line!r}")
            metadata[match.group(1).strip()] = match.group(2)
            continue
        stripped = raw_line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        entry = safe_local_lua(raw_line)
        if entry in seen:
            raise PackageError(f"duplicate Lua manifest entry: {entry}")
        source = ADDON_DIR.joinpath(*entry.parts)
        if not source.is_file() or source.is_symlink():
            raise PackageError(f"missing or unsafe manifest source: {entry}")
        seen.add(entry)
        entries.append(entry)
    if not entries:
        raise PackageError("manifest contains no Lua files")
    if entries[-1] != PurePosixPath(f"{ADDON_NAME}.lua"):
        raise PackageError(f"manifest startup entry must remain last: {ADDON_NAME}.lua")
    version = metadata.get("Version", "")
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9._-]*", version):
        raise PackageError(f"missing or unsafe TOC Version metadata: {version!r}")
    return metadata, entries


def package_sources() -> tuple[str, list[tuple[Path, PurePosixPath]]]:
    metadata, entries = read_manifest()
    sources: list[tuple[Path, PurePosixPath]] = [
        (TOC_PATH, PurePosixPath(ADDON_NAME, TOC_PATH.name))
    ]
    sources.extend(
        (ADDON_DIR.joinpath(*entry.parts), PurePosixPath(ADDON_NAME).joinpath(entry))
        for entry in entries
    )
    for source, member in NOTICES.items():
        if not source.is_file() or source.is_symlink():
            raise PackageError(f"missing or unsafe distribution notice: {source.name}")
        sources.append((source, member))
    member_names = [member.as_posix() for _, member in sources]
    if len(member_names) != len(set(member_names)):
        raise PackageError("package source selection contains duplicate members")
    return metadata["Version"], sorted(sources, key=lambda item: item[1].as_posix())


def write_archive(output: Path) -> None:
    _, sources = package_sources()
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(
        output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9, strict_timestamps=True
    ) as archive:
        for source, member in sources:
            info = zipfile.ZipInfo(member.as_posix(), FIXED_TIMESTAMP)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(
                info,
                source.read_bytes(),
                compress_type=zipfile.ZIP_DEFLATED,
                compresslevel=9,
            )


def default_archive() -> Path:
    version, _ = package_sources()
    return DIST_DIR / f"{ADDON_NAME}-{version}.zip"


def build(output: Path) -> Path:
    output = output.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(
        prefix="rphelper-package-", dir=output.parent
    ) as temporary:
        candidate = Path(temporary) / output.name
        write_archive(candidate)
        if output.exists():
            if not output.is_file() or output.is_symlink():
                raise PackageError(f"refusing to replace unexpected output: {output}")
            if output.read_bytes() != candidate.read_bytes():
                raise PackageError(f"refusing to overwrite different existing archive: {output}")
            print(f"unchanged {display_path(output)}")
            return output
        os.replace(candidate, output)
    print(f"built {display_path(output)}")
    return output


def validate_member_name(name: str) -> PurePosixPath:
    if not name or "\\" in name or name.startswith("/"):
        raise PackageError(f"unsafe ZIP member path: {name!r}")
    path = PurePosixPath(name)
    if path.as_posix() != name or any(part in {"", ".", ".."} for part in path.parts):
        raise PackageError(f"unsafe ZIP member path: {name!r}")
    if path.parts[0] != ADDON_NAME:
        raise PackageError(f"unexpected ZIP root for member: {name}")
    lowered = {part.lower() for part in path.parts}
    if (
        lowered & DISALLOWED_PARTS
        or name.endswith((".py", ".pyc"))
        or "RPHelper2" in name
    ):
        raise PackageError(f"development or historical artifact in ZIP: {name}")
    return path


def validate(archive_path: Path) -> tuple[str, list[str]]:
    archive_path = archive_path.resolve()
    if not archive_path.is_file() or archive_path.is_symlink():
        raise PackageError(f"archive not found or unsafe: {archive_path}")
    _, sources = package_sources()
    expected = [member.as_posix() for _, member in sources]
    with zipfile.ZipFile(archive_path, "r") as archive:
        infos = archive.infolist()
        names = [info.filename for info in infos]
        if len(names) != len(set(names)):
            raise PackageError("ZIP contains duplicate member names")
        for info in infos:
            validate_member_name(info.filename)
            if info.is_dir():
                raise PackageError(f"unexpected explicit directory entry: {info.filename}")
            if info.date_time != FIXED_TIMESTAMP:
                raise PackageError(f"non-deterministic timestamp: {info.filename}")
        if names != expected:
            missing = sorted(set(expected) - set(names))
            unexpected = sorted(set(names) - set(expected))
            raise PackageError(
                f"ZIP inventory mismatch; missing={missing}, unexpected={unexpected}"
            )
        toc_member = f"{ADDON_NAME}/{ADDON_NAME}.toc"
        if archive.read(toc_member) != TOC_PATH.read_bytes():
            raise PackageError("packaged TOC does not match the source manifest")
        for notice in ("LICENSE", "CONTENT_RIGHTS.txt", "CREDITS.txt"):
            if f"{ADDON_NAME}/Documentation/{notice}" not in names:
                raise PackageError(f"required distribution notice missing: {notice}")
        with tempfile.TemporaryDirectory(prefix="rphelper-extract-") as temporary:
            destination = Path(temporary)
            archive.extractall(destination)
            roots = sorted(path.name for path in destination.iterdir())
            if roots != [ADDON_NAME]:
                raise PackageError(f"extracted archive has unexpected roots: {roots}")
            if not (destination / ADDON_NAME / f"{ADDON_NAME}.toc").is_file():
                raise PackageError("extracted addon folder has no matching TOC")

    with tempfile.TemporaryDirectory(prefix="rphelper-determinism-") as temporary:
        first = Path(temporary) / "first.zip"
        second = Path(temporary) / "second.zip"
        write_archive(first)
        write_archive(second)
        first_hash, second_hash = sha256(first), sha256(second)
        if first_hash != second_hash or first.read_bytes() != second.read_bytes():
            raise PackageError("two source-identical builds are not byte-identical")
        if archive_path.read_bytes() != first.read_bytes():
            raise PackageError("validated archive does not match a fresh source build")
    digest = sha256(archive_path)
    print(f"validated {display_path(archive_path)}")
    print(f"sha256 {digest}")
    print(f"members {len(expected)}")
    return digest, expected


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("build", help="build the deterministic prerelease ZIP")
    validate_parser = subparsers.add_parser(
        "validate", help="validate a built archive"
    )
    validate_parser.add_argument(
        "archive", nargs="?", type=Path, help="archive to validate"
    )
    args = parser.parse_args()
    if args.command == "build":
        build(default_archive())
    else:
        validate((args.archive or default_archive()).resolve())
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, PackageError, zipfile.BadZipFile) as error:
        raise SystemExit(f"package error: {error}")
