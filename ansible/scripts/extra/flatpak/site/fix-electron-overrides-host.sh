#!/usr/bin/env bash
set -euo pipefail

FONTS_LINK="$HOME/.local/share/flatpak-fonts"
mkdir -p "$FONTS_LINK"
for d in /usr/share/fonts/* /usr/local/share/fonts/*; do
  [ -d "$d" ] && ln -sfn "$d" "$FONTS_LINK/" 2>/dev/null || true
done

OVERRIDES=(
  --nosocket=fallback-x11
  --socket=wayland
  --socket=x11
  --env=ELECTRON_OZONE_PLATFORM_HINT=wayland
  --filesystem=xdg-cache:create
  --filesystem=xdg-config:create
  --filesystem=xdg-data/flatpak-fonts:ro
  --filesystem=xdg-data/fontconfig:ro
)

flatpak list --app --columns=application 2>/dev/null | while read -r app; do
  if flatpak info --show-metadata "$app" 2>/dev/null | grep -q "org.electronjs.Electron2.BaseApp"; then
    flatpak override --user --reset "$app"
    flatpak override --user "${OVERRIDES[@]}" "$app"
  fi
done