#!/usr/bin/env bash
# Mostra de novo o QR pra conectar (ou reconectar) o WhatsApp do cérebro.
set -euo pipefail
. /opt/core-os/.env
EST=$(curl -fsS -H "apikey: $EVO_KEY" http://127.0.0.1:8080/instance/connectionState/cerebro | jq -r '.instance.state // .state')
[ "$EST" = open ] && { echo "WhatsApp já está conectado."; exit 0; }
CODE=$(curl -fsS -H "apikey: $EVO_KEY" http://127.0.0.1:8080/instance/connect/cerebro | jq -r '.code // empty')
[ -n "$CODE" ] || { echo "A Evolution não devolveu QR. Tente de novo em 10 segundos."; exit 1; }
echo "WhatsApp > Aparelhos conectados > Conectar aparelho, e leia:"; qrencode -t ANSIUTF8 "$CODE"
