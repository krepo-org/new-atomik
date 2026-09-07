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

# Controlla se siamo dentro Toolbx/Container
if [ -f /.dockerenv ] || [ -f /run/.toolboxenv ] || grep -q "toolbox" /proc/1/cgroup 2>/dev/null; then
  FLATPAK_SPawn_CMD="flatpak-spawn --host pkexec"
else
  FLATPAK_SPawn_CMD="flatpak-spawn --host flatpak"
fi

$FLATPAK_SPawn_CMD list --app --columns=application 2>/dev/null | while read -r app; do
  if $FLATPAK_SPawn_CMD info --show-metadata "$app" 2>/dev/null | grep -q "org.electronjs.Electron2.BaseApp"; then
    $FLATPAK_SPawn_CMD override --user --reset "$app"
    $FLATPAK_SPawn_CMD override --user "${OVERRIDES[@]}" "$app"
  fi
done