#!/usr/bin/env fish
udevadm control --reload-rules
udevadm trigger
