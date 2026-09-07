#!/bin/bash
# Reencode óptimo desde los masters 4K. Misma calidad medida, ~1/3 del peso.
set -eu
cd /Users/davidramirez/Desktop/Altus/tu-sonrisa-web
FF=./film/node_modules/ffmpeg-static/ffmpeg
XP="aq-mode=3:psy-rd=1.0,0.15"

# --- Recorrido: scrub por scroll (GOP corto, salto ~3ms más que all-intra) ---
tour(){ # salida, fuente, escala, crf, [ss], [t]
  local out=$1 src=$2 sc=$3 crf=$4 ss=${5:-} t=${6:-}
  $FF -y -loglevel error ${ss:+-ss $ss} ${t:+-t $t} -i "$src" -vf "scale=$sc" \
    -c:v libx264 -crf "$crf" -preset veryslow -g 12 -keyint_min 12 -sc_threshold 0 \
    -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart -an "public/$out"
  echo "  $out = $(du -m "public/$out" | cut -f1)MB"
}
echo "== RECORRIDO (escritorio 1600x900) =="
tour TS_A.mp4 film/tsA_4k.mp4 1600:900 26
tour TS_B.mp4 film/tsB_4k.mp4 1600:900 26
tour TS_C.mp4 film/tsC_4k.mp4 1600:900 26 0  40
tour TS_D.mp4 film/tsC_4k.mp4 1600:900 26 40

echo "== RECORRIDO (móvil 1152x648) =="
tour TS_A_m.mp4 film/tsA_4k.mp4 1152:648 28
tour TS_B_m.mp4 film/tsB_4k.mp4 1152:648 28
tour TS_C_m.mp4 film/tsC_4k.mp4 1152:648 28 0  40
tour TS_D_m.mp4 film/tsC_4k.mp4 1152:648 28 40

echo "== HERO y MÁQUINA =="
$FF -y -loglevel error -i film/hero_4k.mp4 -vf scale=1600:900 -c:v libx264 -crf 24 -preset veryslow \
  -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart -an assets/video/hero.mp4
echo "  hero = $(du -m assets/video/hero.mp4 | cut -f1)MB"
$FF -y -loglevel error -i film/maquina_4k.mp4 -vf scale=1600:900 -c:v libx264 -crf 25 -preset veryslow \
  -g 12 -keyint_min 12 -sc_threshold 0 -x264-params "$XP" -pix_fmt yuv420p -movflags +faststart -an assets/video/maquina.mp4
echo "  maquina = $(du -m assets/video/maquina.mp4 | cut -f1)MB"
echo "OPTIMIZACION FASE 1 LISTA"
