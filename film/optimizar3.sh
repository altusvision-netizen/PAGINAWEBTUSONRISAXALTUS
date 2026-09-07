#!/bin/bash
set -eu
cd /Users/davidramirez/Desktop/Altus/tu-sonrisa-web
FF=./film/node_modules/ffmpeg-static/ffmpeg
SRC="/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
XP="aq-mode=3:psy-rd=1.0,0.15"
# 864x1536: cubre con margen los ~570px reales del marco de teléfono y del carrusel
sm(){ $FF -y -loglevel error ${3:+-ss $3} ${4:+-t $4} -i "$1" \
  -vf "scale=864:1536:force_original_aspect_ratio=increase,crop=864:1536" \
  -c:v libx264 -crf 26 -preset slower -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 96k -ac 2 "assets/video/$2"; }
i=1; for f in "01 " "02 " "03 " "04 " "05 " "06 "; do sm "$SRC/INDICACIONES A PACIENTES /$f.mp4" "ind-0$i.mp4"; i=$((i+1)); done
sm "$SRC/PACIENTES AL EXTRANGERO /LOOP VISITA USA .MOV" loop-usa.mp4
sm "$SRC/PACIENTES AL EXTRANGERO /02 HERMANOS LEJANOS .MOV" loop-hermanos.mp4 0 18
sm "$SRC/PACIENTES AL EXTRANGERO /Caso paciente EEUU 01.mp4" loop-caso-eeuu.mp4 4 18
echo "FASE 3 LISTA"
