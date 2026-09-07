#!/usr/bin/env fish
podman ps -a --filter label=com.github.containers.toolbox=true --format '{{.Names}}' 2>/dev/null | sort | string join ' '
