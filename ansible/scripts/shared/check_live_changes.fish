#!/usr/bin/env fish
rpm-ostree status --json | python3 -c '
import json, sys
d = json.load(sys.stdin).get("deployments", [])
b = [x for x in d if x.get("booted")]
pkgs = b[0].get("packages", []) + b[0].get("requested-packages", []) if b else []
sys.exit(0 if pkgs else 1)
'
