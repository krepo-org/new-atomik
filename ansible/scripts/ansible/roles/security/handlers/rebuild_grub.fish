#!/usr/bin/env fish
# On ostree/Atomic systems with composefs, grub2-mkconfig cannot probe the root filesystem.
# Bootloader arguments are read dynamically via BLS and /etc/default/grub.d.
if test -f /run/ostree-booted
    echo "Ostree booted system detected (composefs); skipping grub2-mkconfig (managed via BLS)"
    exit 0
end

if command -v grub2-mkconfig >/dev/null 2>&1
    grub2-mkconfig -o /boot/grub2/grub.cfg
else if command -v grub-mkconfig >/dev/null 2>&1
    grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "No grub-mkconfig found"
end
