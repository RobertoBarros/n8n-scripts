#!/bin/zsh
set -eu

cd -- "${0:A:h}"

tunnel_log=$(mktemp)
tunnel_pid=''

cleanup() {
  if [[ -n "$tunnel_pid" ]]; then
    kill "$tunnel_pid" 2>/dev/null || true
    wait "$tunnel_pid" 2>/dev/null || true
  fi
  rm -f -- "$tunnel_log"
}

trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

cloudflared tunnel --url http://localhost:5678 >"$tunnel_log" 2>&1 &
tunnel_pid=$!

print 'Aguardando URL do túnel...'
tunnel_url=''
for attempt in {1..60}; do
  tunnel_url=$(sed -nE 's|.*(https://[a-z0-9-]+\.trycloudflare\.com).*|\1|p' "$tunnel_log" | head -n 1)
  [[ -n "$tunnel_url" ]] && break
  kill -0 "$tunnel_pid" 2>/dev/null || break
  sleep 1
done

if [[ -z "$tunnel_url" ]]; then
  print -u2 'Não foi possível obter a URL do túnel.'
  cat "$tunnel_log" >&2
  exit 1
fi

export TUNNEL_URL="$tunnel_url"

printf '%s' "$tunnel_url" | pbcopy
print "n8n: $tunnel_url (URL copiada para a área de transferência)"
docker compose up
