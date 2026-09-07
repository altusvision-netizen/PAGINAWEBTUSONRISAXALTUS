#!/bin/bash
set -eu
cd /Users/davidramirez/Desktop/Altus/tu-sonrisa-web
FF=./film/node_modules/ffmpeg-static/ffmpeg
SRC="/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
XP="aq-mode=3:psy-rd=1.0,0.15"
# reels y serie: reproducción normal (no scrub) -> GOP largo, mucho más eficiente
rv(){ $FF -y -loglevel error -i "$1" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" \
  -c:v libx264 -crf 27 -preset slower -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 "assets/video/$2" && echo "  $2 = $(du -m assets/video/$2|cut -f1)MB"; }
echo "== REELS =="
rv "$SRC/EXPERIENCIA TU SONRISA .mp4" reel-experiencia.mp4
rv "$SRC/UNA SOLA CITA .mp4" reel-unacita.mp4
rv "$SRC/Blanqueamiento 10 min.mp4" reel-blanqueamiento.mp4
rv "$SRC/No hacemos diseños de sonrisa falsos.mp4" reel-sonrisas-reales.mp4
rv "$SRC/PACIENTES AL EXTRANGERO /CDTS - Pacientes EEUU.mp4" reel-eeuu.mp4
echo "== SERIE DE LA DOCTORA =="
i=1; for f in "01 " "02 " "03 " "04 " "05 " "06 "; do rv "$SRC/INDICACIONES A PACIENTES /$f.mp4" "ind-0$i.mp4"; i=$((i+1)); done
echo "== LOOPS EE.UU. =="
rv "$SRC/PACIENTES AL EXTRANGERO /LOOP VISITA USA .MOV" loop-usa.mp4
$FF -y -loglevel error -ss 0 -t 18 -i "$SRC/PACIENTES AL EXTRANGERO /02 HERMANOS LEJANOS .MOV" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 27 -preset slower -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart -c:a aac -b:a 96k -ac 2 assets/video/loop-hermanos.mp4
$FF -y -loglevel error -ss 4 -t 18 -i "$SRC/PACIENTES AL EXTRANGERO /Caso paciente EEUU 01.mp4" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 27 -preset slower -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart -c:a aac -b:a 96k -ac 2 assets/video/loop-caso-eeuu.mp4
echo "  loops = $(du -mc assets/video/loop-*.mp4|tail -1|cut -f1)MB"
echo "OPTIMIZACION FASE 2 LISTA"
