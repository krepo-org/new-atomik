#!/usr/bin/env bash
set -euo pipefail

OVERRIDES=(
  --nosocket=fallback-x11
  --socket=wayland
  --socket=x11
  --env=ELECTRON_OZONE_PLATFORM_HINT=wayland
  --filesystem=xdg-cache:create
  --filesystem=xdg-config:create
)

flatpak-spawn --host flatpak list --app --columns=application 2>/dev/null | while read -r app; do
  if flatpak-spawn --host flatpak info --show-metadata "$app" 2>/dev/null | grep -q "org.electronjs.Electron2.BaseApp"; then
    flatpak-spawn --host flatpak override --user --reset "$app"
    flatpak-spawn --host flatpak override --user "${OVERRIDES[@]}" "$app"
  fi
done