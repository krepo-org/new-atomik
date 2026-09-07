# Atomik

Ansible-based declarative system configuration for Fedora Atomic COSMIC.

## Requirements

4 GB RAM minimum. The system must already be running Fedora Cosmic Atomic.

## Setup

```bash
make deps          # install ansible-core and collections
make run CMD=core  # dry-run core configuration
make run CMD=core --apply  # apply core configuration
```

## Commands

```bash
make run CMD=core           # full system configuration
make run CMD=security       # security hardening, GPU tuning, thermald, udev, kernel
make run CMD=packages       # rpm-ostree package management
make run CMD=desktop        # desktop environment (COSMIC)
make run CMD=flatpak        # Flatpak apps and Electron overrides
make run CMD=gaming         # Discord, Heroic with Wayland
make run CMD=business       # Slack with Wayland
make run CMD=devtools       # rustup, pnpm, opencode
make run CMD=vscode         # VS Code with vsconf
make run CMD=lint           # syntax check all playbooks
make run CMD=test           # end-to-end test suite
make run CMD=install-deps   # ansible-core and collections via rpm-ostree
```

Default is dry-run. Add `--apply` to execute.

## Electron Flatpak Fix

All Electron-based Flatpak apps (Discord, Slack, Spotify, Signal, etc.) are affected by a sandbox regression in Flatpak 1.17.x where the fallback-x11 socket fails to forward $DISPLAY. Atomik detects every installed Electron app at runtime and applies the correct overrides: nosocket=fallback-x11, socket=wayland, socket=x11, and ELECTRON_OZONE_PLATFORM_HINT=x11. A systemd path unit monitors /var/lib/flatpak/app/ so overrides are reapplied automatically whenever a new app is installed.

## COSMIC Desktop

COSMIC receives special treatment to prevent glitches, freezes, and stuttering. GPU rendering is hardened with explicit Mesa, GL sync, and GBM environment variables. The AMDGPU driver is set to high performance mode on boot. The cosmic-comp compositor gets realtime CPU scheduling priority. xdg-desktop-portal is enabled for proper file chooser and screenshot support.

## Security

Firewalld, audit rules, hardened kernel parameters, SSH key-only auth, resource limits. All configurations persist across reboots via sysctl, udev rules, tmpfiles, and systemd units.

## Memory Management

ZRAM compressed swap, systemd-oomd with desktop-tuned thresholds, no earlyoom.

## Layout

The `ansible` directory contains playbooks and roles. The `extra` directory contains optional modules for vscode, devtools, flatpak, gaming, and business.

## Reset

Revert the system to baseline: uninstall custom packages, remove repositories, delete wallpapers, reset desktop settings.
