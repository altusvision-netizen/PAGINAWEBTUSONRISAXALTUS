#!/bin/bash
# Reencodea los reels del material a versiones web (vertical 720x1280) + posters.
set -u
FF=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/film/node_modules/ffmpeg-static/ffmpeg
SRC="/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
OUT=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/assets/video
mkdir -p "$OUT"

enc_v() { # vertical reel con audio
  "$FF" -y -loglevel error -i "$1" -vf "scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280" \
    -c:v libx264 -crf 28 -preset slow -pix_fmt yuv420p -movflags +faststart \
    -c:a aac -b:a 96k -ac 2 "$OUT/$2"
  echo "ok $2"
}
poster() { # poster jpg del segundo indicado
  "$FF" -y -loglevel error -ss "$3" -i "$1" -frames:v 1 -vf "scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280" -q:v 4 "$OUT/$2"
  echo "ok $2"
}

enc_v "$SRC/EXPERIENCIA TU SONRISA .mp4" "reel-experiencia.mp4"
poster "$SRC/EXPERIENCIA TU SONRISA .mp4" "reel-experiencia.jpg" 2
enc_v "$SRC/UNA SOLA CITA .mp4" "reel-unacita.mp4"
poster "$SRC/UNA SOLA CITA .mp4" "reel-unacita.jpg" 2
enc_v "$SRC/Blanqueamiento 10 min.mp4" "reel-blanqueamiento.mp4"
poster "$SRC/Blanqueamiento 10 min.mp4" "reel-blanqueamiento.jpg" 2
enc_v "$SRC/No hacemos diseños de sonrisa falsos.mp4" "reel-sonrisas-reales.mp4"
poster "$SRC/No hacemos diseños de sonrisa falsos.mp4" "reel-sonrisas-reales.jpg" 2
enc_v "$SRC/PACIENTES AL EXTRANGERO /CDTS - Pacientes EEUU.mp4" "reel-eeuu.mp4"
poster "$SRC/PACIENTES AL EXTRANGERO /CDTS - Pacientes EEUU.mp4" "reel-eeuu.jpg" 2

# loop mudo corto para la sección internacional
"$FF" -y -loglevel error -i "$SRC/PACIENTES AL EXTRANGERO /LOOP VISITA USA .MOV" \
  -vf "scale=720:1280:force_original_aspect_ratio=increase,crop=720:1280" \
  -c:v libx264 -crf 28 -preset slow -pix_fmt yuv420p -movflags +faststart -an "$OUT/loop-usa.mp4"
echo "ok loop-usa.mp4"

ls -la "$OUT"
echo "videos listos"
