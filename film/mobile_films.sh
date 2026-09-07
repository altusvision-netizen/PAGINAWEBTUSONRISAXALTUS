#!/bin/bash
# Films móviles: 1280x720 all-intra, livianos para scrub fluido en teléfono.
set -eu
BASE=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web
FF="$BASE/film/node_modules/ffmpeg-static/ffmpeg"
for t in A B C D; do
  "$FF" -y -loglevel error -i "$BASE/public/TS_$t.mp4" -vf scale=1280:720 \
    -c:v libx264 -crf 30 -preset slow -g 1 -keyint_min 1 -sc_threshold 0 \
    -pix_fmt yuv420p -movflags +faststart -an "$BASE/public/TS_${t}_m.mp4"
  echo "TS_${t}_m = $(stat -f%z "$BASE/public/TS_${t}_m.mp4" | awk '{printf "%.1fMB",$1/1000000}')"
done
echo "FILMS MOVILES LISTOS"
