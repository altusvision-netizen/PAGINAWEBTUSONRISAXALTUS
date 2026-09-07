#!/bin/bash
# v2: hero con los clips horizontales reales + reels de indicaciones a pacientes.
set -u
FF=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/film/node_modules/ffmpeg-static/ffmpeg
SRC="/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
OUT=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/assets/video
TMP=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/film
mkdir -p "$OUT"

# --- HERO: letrero (12.6s) + fresado macro y pantalla CAD (primeros 13s del otro) ---
"$FF" -y -loglevel error -i "$SRC/hero VIDEOS HORIZONTALES/20241030_195840000_iOS.MP4" \
  -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720,fps=24" \
  -c:v libx264 -crf 20 -preset fast -an "$TMP/hero_a.mp4"
"$FF" -y -loglevel error -ss 0 -t 13 -i "$SRC/hero VIDEOS HORIZONTALES/20241005_020046000_iOS.MP4" \
  -vf "scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720,fps=24" \
  -c:v libx264 -crf 20 -preset fast -an "$TMP/hero_b.mp4"
printf "file '%s'\nfile '%s'\n" "$TMP/hero_a.mp4" "$TMP/hero_b.mp4" > "$TMP/hero_list.txt"
"$FF" -y -loglevel error -f concat -safe 0 -i "$TMP/hero_list.txt" \
  -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p -movflags +faststart -an "$OUT/hero.mp4"
"$FF" -y -loglevel error -ss 1 -i "$OUT/hero.mp4" -frames:v 1 -q:v 4 /Users/davidramirez/Desktop/Altus/tu-sonrisa-web/assets/img/hero-poster.jpg
echo "hero listo: $(du -h "$OUT/hero.mp4" | cut -f1)"

# --- INDICACIONES A PACIENTES: 6 reels verticales con audio ---
i=1
for f in "01 " "02 " "03 " "04 " "05 " "06 "; do
  "$FF" -y -loglevel error -i "$SRC/INDICACIONES A PACIENTES /$f.mp4" \
    -vf "scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280" \
    -c:v libx264 -crf 28 -preset slow -pix_fmt yuv420p -movflags +faststart \
    -c:a aac -b:a 96k -ac 2 "$OUT/ind-0$i.mp4"
  "$FF" -y -loglevel error -ss 1 -i "$OUT/ind-0$i.mp4" -frames:v 1 -q:v 5 "$OUT/ind-0$i.jpg"
  echo "ind-0$i ok"
  i=$((i+1))
done
ls -la "$OUT" | grep -E "hero|ind"
echo "prep v2 listo"
