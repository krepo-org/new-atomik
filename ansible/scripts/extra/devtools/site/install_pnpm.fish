#!/usr/bin/env fish
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not test -d "$PNPM_HOME"
  curl -fsSL https://get.pnpm.io/install.sh | sh -
end
