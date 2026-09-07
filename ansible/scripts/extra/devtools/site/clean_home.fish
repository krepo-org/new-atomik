#!/usr/bin/env fish

set -l home "$HOME"

# AI assistant junk
rm -rf "$home/.config/github-copilot"
rm -rf "$home/.copilot"
rm -rf "$home/.config/claude"
rm -rf "$home/.claude"
rm -rf "$home/.config/google-gemini"
rm -rf "$home/.gemini"
rm -rf "$home/.config/anthropic"
rm -rf "$home/.config/continue"
rm -rf "$home/.continue"
rm -rf "$home/.aider*"
rm -rf "$home/.config/aider"
rm -rf "$home/.cursor"
rm -rf "$home/.config/Cursor"
rm -rf "$home/.codeium"
rm -rf "$home/.config/codeium"
rm -rf "$home/.supermaven"
rm -rf "$home/.config/supermaven"
rm -rf "$home/.tabnine"
rm -rf "$home/.config/tabnine"
rm -rf "$home/.amazonq"
rm -rf "$home/.config/amazonq"

# IDE/editor caches
rm -rf "$home/.cache/vscode-*"
rm -rf "$home/.config/Code/Cache"
rm -rf "$home/.config/Code/CachedData"
rm -rf "$home/.config/Code/CachedExtensionVSIXs"
rm -rf "$home/.config/Code/CachedExtensions"
rm -rf "$home/.config/Code/Code Cache"
rm -rf "$home/.config/Code/GPUCache"
rm -rf "$home/.config/Code/logs"
rm -rf "$home/.config/Code/Service Worker"
rm -rf "$home/.config/Code/sessionStorage"
rm -rf "$home/.config/Code/blob_storage"
rm -rf "$home/.vscode/Cache"
rm -rf "$home/.vscode/CachedData"
rm -rf "$home/.vscode/GPUCache"
rm -rf "$home/.vscode/logs"

# Electron app caches
rm -rf "$home/.cache/electron"
rm -rf "$home/.cache/electron-builder"

# Flatpak app data caches
for app_dir in "$home/.var/app"/*;
    test -d "$app_dir" || continue
    rm -rf "$app_dir/cache"
    rm -rf "$home/.var/app/(basename $app_dir)/config/discord/GPUCache"
    rm -rf "$home/.var/app/(basename $app_dir)/config/discord/Cache"
end

# Browser caches
rm -rf "$home/.cache/chromium"
rm -rf "$home/.cache/google-chrome"
rm -rf "$home/.mozilla/firefox/*/Cache"
rm -rf "$home/.mozilla/firefox/*/cached2"
rm -rf "$home/.config/BraveSoftware/Brave-Browser/Default/Cache"
rm -rf "$home/.config/BraveSoftware/Brave-Browser/Default/GPUCache"
rm -rf "$home/.config/BraveSoftware/Brave-Browser/Default/Service Worker/CacheStorage"

# Trash
rm -rf "$home/.local/share/Trash/files"
rm -rf "$home/.local/share/Trash/info"

# Misc caches
rm -rf "$home/.cache/thumbnails"
rm -rf "$home/.cache/mesa_shader_cache"
rm -rf "$home/.cache/pip"
rm -rf "$home/.cache/huggingface"
rm -rf "$home/.cache/poetry"
rm -rf "$home/.cache/yarn"
rm -rf "$home/.cache/npm"
rm -rf "$home/.cache/nx"
rm -rf "$home/.cache/turbopack"
rm -rf "$home/.cache/ms-playwright"
rm -rf "$home/.cache/fnm"
rm -rf "$home/.cache/pnpm"
rm -rf "$home/.cache/bun"
rm -rf "$home/.cache/deno"
rm -rf "$home/.cache/sccache"
rm -rf "$home/.cache/rust-analyzer"
rm -rf "$home/.cache/go-build"
rm -rf "$home/.cache/JetBrains"
rm -rf "$home/.cache/gradle"
rm -rf "$home/.cache/maven"
rm -rf "$home/.cache/man-db"
rm -rf "$home/.cache/fish"
rm -rf "$home/.cache/fish_history"

# Local caches
rm -rf "$home/.local/share/gnome-software/cache"
rm -rf "$home/.local/share/preview-window-icon"
rm -rf "$home/.local/share/telemetry"
rm -rf "$home/.local/state/wireplumber"
rm -rf "$home/.local/share/recently-used.xbel"
rm -rf "$home/.local/share/mime/mime.cache"

echo "Home cleanup complete."
