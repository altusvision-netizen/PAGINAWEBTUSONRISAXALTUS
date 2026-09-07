#!/bin/bash
# Encode final all-intra de los 3 capítulos desde los masters 4K de Topaz.
# 2048x1152 crf adaptativo: si un archivo pasa de 95MB, se re-encodea +2 crf.
set -eu
BASE=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web
FF="$BASE/film/node_modules/ffmpeg-static/ffmpeg"
PUB="$BASE/public"

enc(){
  local t=$1 crf=$2
  echo "TS_$t: encode 2048x1152 crf $crf..."
  "$FF" -y -loglevel error -i "$BASE/film/ts${t}_4k.mp4" -vf scale=2048:1152 \
    -c:v libx264 -crf "$crf" -preset slow -g 1 -keyint_min 1 -sc_threshold 0 \
    -pix_fmt yuv420p -movflags +faststart -an "$PUB/TS_$t.mp4"
  local mb=$(( $(stat -f%z "$PUB/TS_$t.mp4") / 1048576 ))
  echo "TS_$t = ${mb}MB"
  if [ "$mb" -gt 95 ]; then
    echo "TS_$t supera 95MB, re-encode crf $((crf+2))"
    enc "$t" $((crf+2))
  fi
}
enc A 26
enc B 26
enc C 27
# TS_scroll.mp4 se conserva un ciclo más por caches de clientes
ls -la "$PUB"/TS_*.mp4
echo "ENCODE FINAL LISTO"
