#!/bin/bash
# Descarga los clips terminados, concatena en orden y reencodea para scrub (-g 1).
set -eu
BASE=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web
HF="$BASE/film/node_modules/.bin/higgsfield"
FF="$BASE/film/node_modules/ffmpeg-static/ffmpeg"
CLIPS="$BASE/film/clips"
PUB="$BASE/public"
mkdir -p "$CLIPS" "$PUB"

"$HF" generate list --json > "$BASE/film/jobs/_list.json"

python3 - <<'PY'
import json, os, subprocess
base = '/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/film'
jobs = json.load(open(f'{base}/jobs/_list.json'))
by_id = {j['id']: j for j in jobs}
missing = []
HF = f'{base}/node_modules/.bin/higgsfield'
for n in range(1, 19):
    seg = f'seg_{n:02d}'
    raw = json.load(open(f'{base}/jobs/{seg}.json'))
    jid = raw[0] if isinstance(raw, list) else raw['id']
    job = by_id.get(jid, raw if isinstance(raw, dict) else {})
    dest = f'{base}/clips/{seg}.mp4'
    # el clip local manda: los jobs viejos caen fuera de la primera página del listado
    if os.path.exists(dest) and os.path.getsize(dest) > 100000:
        continue
    url = job.get('result_url')
    if not url:
        # job viejo fuera de la página: recuperar por uuid
        try:
            out = subprocess.run([HF, 'generate', 'wait', jid, '--json'], capture_output=True, text=True, timeout=300).stdout
            j = json.loads(out)
            url = j.get('result_url') if isinstance(j, dict) else None
        except Exception:
            url = None
    if not url:
        missing.append(f'{seg} ({jid}: {job.get("status","?")})')
        continue
    print(f'bajando {seg}...')
    subprocess.run(['curl', '-sL', url, '-o', dest], check=True)
if missing:
    print('FALTAN:', ', '.join(missing))
    raise SystemExit(1)
with open(f'{base}/clips/lista.txt', 'w') as f:
    for n in range(1, 19):
        f.write(f"file '{base}/clips/seg_{n:02d}.mp4'\n")
print('clips completos')
PY

# reencode siempre: concat -c copy entre clips generados por separado puede salir corrupto
echo "concatenando master..."
"$FF" -y -loglevel error -f concat -safe 0 -i "$CLIPS/lista.txt" -c:v libx264 -crf 18 -preset fast -an "$BASE/film/TS_master.mp4"

echo "reencode desktop 1792x1008 all-intra (limite Vercel 100MB)..."
"$FF" -y -loglevel error -i "$BASE/film/TS_master.mp4" -vf scale=1792:1008 -c:v libx264 -crf 27 -preset slow \
  -g 1 -keyint_min 1 -sc_threshold 0 -pix_fmt yuv420p -movflags +faststart -an "$PUB/TS_scroll.mp4"

ls -la "$PUB"/TS_scroll*.mp4
echo "ensamblaje listo"
