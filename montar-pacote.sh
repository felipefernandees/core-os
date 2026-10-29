#!/usr/bin/env bash
# Monta dist/core-os.tar.gz e dist/core-os.zip (entrega pública): skill + painel (sem node_modules) + cérebro de demonstração.
set -euo pipefail
R="$(cd "$(dirname "$0")" && pwd)"
D="$R/dist/core-os"
rm -rf "$R/dist"; mkdir -p "$D"
cp -a "$R/skill/." "$D/"
rsync -a --exclude node_modules --exclude data "$R/painel/" "$D/painel/"
rsync -a --exclude '.DS_Store' "$R/cerebro-demo/" "$D/cerebro/"
find "$D" -name '.DS_Store' -delete
tar -C "$R/dist" -czf "$R/dist/core-os.tar.gz" core-os
(cd "$R/dist" && zip -qr core-os.zip core-os)
du -sh "$R/dist/core-os.tar.gz" "$R/dist/core-os.zip"
