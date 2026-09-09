# Agents

Every configuration applied by Atomik must survive a reboot. No temporary workarounds, no session-only changes. Every systemd service, sysctl, udev rule, tmpfiles entry, sysfs write, and user config must persist across reboots by design.

## Electron Flatpak Override Agent

The fix-electron-overrides script runs via a systemd path unit that monitors /var/lib/flatpak/app/ for changes. Every time a Flatpak app is installed or updated, the path unit triggers the service which detects all apps using the Electron base app and applies the correct sandbox overrides. A timer also runs 30 seconds after boot to ensure overrides are applied. The overrides remove fallback-x11, enable wayland and x11 sockets, set ELECTRON_OZONE_PLATFORM_HINT=wayland, and expose host fonts via a symlinked directory at ~/.local/share/flatpak-fonts/ (Flatpak blocks /usr in overrides). The fix-electron-host script must use flatpak directly — flatpak-spawn is for escaping Flatpak sandboxes, not for running on the host. Font emoji (Noto Color Emoji) require the symlink trick because host-fonts is not supported in flatpak override --filesystem.

## Battery Charge Threshold

The atomik-battery-threshold service sets charge_control_end_threshold to the configured value (default 85%) on all detected batteries at boot. The script lives at /usr/local/bin/atomik-battery-threshold.sh and the systemd unit at /etc/systemd/system/atomik-battery-threshold.service. This allows permanent AC connection without battery degradation.

## COSMIC Compositor Boost

The cosmic-comp-boost systemd user service sets the COSMIC compositor process to realtime FIFO scheduling priority 50 after the session starts. This ensures frame delivery is never delayed by lower-priority processes.

## AMDGPU Performance Service

The amdgpu-performance systemd system service runs once at boot and sets power_dpm_force_performance_level to high for all AMDGPU cards. This prevents the GPU from entering lower power states that cause frame drops and stuttering in the compositor.

## flatpak-spawn vs flatpak

flatpak-spawn is a tool designed to escape Flatpak sandbox contexts — it forwards commands to the host D-Bus from inside a sandbox. It must never be used to run commands directly on the host. Systemd user services run on the host natively and should use flatpak (or any other binary) directly. Using flatpak-spawn from a systemd service on the host causes exit code 127 (command not found) because the D-Bus session helper is not available outside a sandbox. The fix-electron-overrides-host script (deployed to ~/.local/bin/) runs on the host via systemd and must call flatpak directly, never flatpak-spawn.
