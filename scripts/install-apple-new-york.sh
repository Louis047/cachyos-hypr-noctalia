#!/usr/bin/env bash
# Installs or uninstalls Apple New York (NY) serif fonts (OTF only) system-wide on Arch Linux.
set -euo pipefail

FONTS=(NY)
BASE_URL="https://devimages-cdn.apple.com/design/resources/download"
TARGET_DIR="/usr/share/fonts/apple-new-york"

show_usage() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Installs Apple New York (NY) OTF fonts only."
  echo ""
  echo "Options:"
  echo "  --uninstall    Uninstall Apple New York fonts from the system"
  echo "  -h, --help     Show this help message"
}

UNINSTALL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --uninstall)
      UNINSTALL=true
      shift
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_usage
      exit 1
      ;;
  esac
done

if [[ "$UNINSTALL" = true ]]; then
  if [[ ! -d "$TARGET_DIR" ]] || [[ -z "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]]; then
    echo "==> Apple New York fonts are not installed in the system."
    exit 1
  fi

  echo "==> Uninstalling Apple New York fonts..."
  sudo rm -rf "$TARGET_DIR"
  echo "==> Rebuilding font cache"
  sudo fc-cache -f
  echo "==> Apple New York fonts have been uninstalled successfully."
  exit 0
fi

WORKDIR="$(mktemp -d /tmp/apple-ny.XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "==> Checking dependencies"
missing=()
command -v curl >/dev/null || missing+=(curl)
command -v 7z >/dev/null || missing+=(7zip)
command -v bsdtar >/dev/null || missing+=(libarchive)

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "==> Missing packages: ${missing[*]}"
  echo "==> Install with: sudo pacman -S ${missing[*]}"
  exit 1
fi

sudo mkdir -p "$TARGET_DIR"

failed=()
installed=0

for name in "${FONTS[@]}"; do
  echo "==> $name: downloading"
  if ! curl -fL --retry 3 -o "$WORKDIR/$name.dmg" "$BASE_URL/$name.dmg"; then
    echo "==> $name: FAILED (download)"
    failed+=("$name")
    continue
  fi

  echo "==> $name: extracting"
  tmp="$WORKDIR/tmp_$name"
  mkdir -p "$tmp"
  7z x "$WORKDIR/$name.dmg" -o"$tmp" -y >/dev/null
  # Newer Apple pkgs often fail with 7z; fall back to bsdtar (see apple-fonts AUR comments).
  while IFS= read -r -d '' pkg; do
    bsdtar -xf "$pkg" -C "$tmp" >/dev/null 2>&1 || 7z x "$pkg" -o"$tmp" -y >/dev/null
  done < <(find "$tmp" -iname "*.pkg" -print0)
  while IFS= read -r -d '' payload; do
    bsdtar -xf "$payload" -C "$tmp" "Library/Fonts" >/dev/null 2>&1 || 7z x "$payload" -o"$tmp" -y >/dev/null
  done < <(find "$tmp" -iname "Payload*" -print0)

  count=$(find "$tmp" -iname "*.otf" | wc -l)
  if [[ "$count" -eq 0 ]]; then
    echo "==> $name: FAILED (no OTF font files found)"
    failed+=("$name")
    continue
  fi

  find "$tmp" -iname "*.otf" -exec sudo cp {} "$TARGET_DIR/" \;
  echo "==> $name: OK ($count files)"
  installed=$((installed + 1))
done

echo "==> Rebuilding font cache"
sudo fc-cache -f "$TARGET_DIR" >/dev/null

echo ""
echo "==> Summary"
echo "Installed: $installed / ${#FONTS[@]} font families"
echo "Total files in $TARGET_DIR: $(find "$TARGET_DIR" -type f | wc -l)"

if [[ ${#failed[@]} -gt 0 ]]; then
  echo "Failed: ${failed[*]}"
fi
