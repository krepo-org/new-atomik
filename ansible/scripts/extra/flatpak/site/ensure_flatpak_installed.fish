#!/usr/bin/env fish
if not test -x /usr/bin/flatpak
    rpm-ostree install -y --idempotent --allow-inactive flatpak
end
