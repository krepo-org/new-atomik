#!/usr/bin/env fish
if test -n "$SUDO_USER"
  echo "$SUDO_USER"
else if test -n "$PKEXEC_UID"
  getent passwd "$PKEXEC_UID" | cut -d: -f1
else
  echo "$USER"
end
