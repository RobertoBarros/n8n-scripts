#!/bin/zsh
set -eu

cd -- "${0:A:h}"

docker compose pull n8n
exec ./start.zsh
