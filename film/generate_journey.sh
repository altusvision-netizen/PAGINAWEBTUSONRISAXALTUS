#!/bin/bash
# Envía los segmentos del recorrido Tu Sonrisa a Kling 3.0 pro (start_image -> end_image).
# Fase submit: crea todos los jobs sin esperar; guarda jobs/seg_NN.json con el id.
# Idempotente: se salta segmentos que ya tienen json con id.
set -u
BASE=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web
HF="$BASE/film/node_modules/.bin/higgsfield"
ANCHORS="$BASE/anchors"
OUT="$BASE/film/jobs"
mkdir -p "$OUT"

PREFIX="One continuous cinematic camera shot connecting two real photographs of the same modern dental clinic, Clinica Dental Tu Sonrisa in San Salvador."
SUFFIX="Do not change or invent architecture, dental equipment, machines, furniture, materials, or layout — it is a real clinic. Only camera movement and subtle natural motion: soft light shifts, screens glowing, plants swaying gently. Cinematic 35mm film grain, no text, no people looking at camera. Camera always advances forward, never backward."

while IFS=$'\t' read -r num start end move; do
  [ -z "$num" ] && continue
  if [ -s "$OUT/seg_$num.json" ] && grep -qE '[0-9a-f]{8}-[0-9a-f]{4}' "$OUT/seg_$num.json"; then
    echo "seg $num: ya enviado, salto"
    continue
  fi
  echo "=== seg $num: $start -> $end ==="
  "$HF" generate create kling3_0 \
    --prompt "$PREFIX $move $SUFFIX" \
    --start-image "$ANCHORS/$start" \
    --end-image "$ANCHORS/$end" \
    --duration 5 --mode pro --aspect_ratio "16:9" --sound off \
    --json > "$OUT/seg_$num.json" 2> "$OUT/seg_$num.err"
  if [ $? -ne 0 ] || ! grep -qE '[0-9a-f]{8}-[0-9a-f]{4}' "$OUT/seg_$num.json"; then
    echo "seg $num: FALLO al enviar (ver $OUT/seg_$num.err)"
    rm -f "$OUT/seg_$num.json"
  else
    echo "seg $num: enviado $(tr -d '[]\" \n' < "$OUT/seg_$num.json")"
  fi
done < "$BASE/film/${SEG_FILE:-segments.tsv}"
echo "submit listo"
