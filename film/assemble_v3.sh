#!/bin/bash
# v3b: descarga clips, arma 3 MASTERS retimed 1.25x (crf17, 1080p) listos para Topaz 4K.
# Composición coherente: la escalera solo al final (bajada y salida).
set -eu
BASE=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web
HF="$BASE/film/node_modules/.bin/higgsfield"
FF="$BASE/film/node_modules/ffmpeg-static/ffmpeg"
CLIPS="$BASE/film/clips_v3"
mkdir -p "$CLIPS"

"$HF" generate list --json > "$BASE/film/jobs_v3/_list.json"

python3 - <<'PY'
import json, os, subprocess
base = '/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/film'
HF = f'{base}/node_modules/.bin/higgsfield'
jobs = json.load(open(f'{base}/jobs_v3/_list.json'))
by_id = {j['id']: j for j in jobs}
NEED = list(range(1,27)) + list(range(29,50)) + [51,52,53]
missing = []
for n in NEED:
    seg = f'seg_{n:02d}'
    dest = f'{base}/clips_v3/{seg}.mp4'
    if os.path.exists(dest) and os.path.getsize(dest) > 100000:
        continue
    jf = f'{base}/jobs_v3/{seg}.json'
    if not os.path.exists(jf):
        missing.append(f'{seg} (sin job)'); continue
    raw = json.load(open(jf))
    jid = raw[0] if isinstance(raw, list) else raw['id']
    job = by_id.get(jid, {})
    url = job.get('result_url')
    if not url:
        try:
            out = subprocess.run([HF, 'generate', 'wait', jid, '--json'], capture_output=True, text=True, timeout=420).stdout
            j = json.loads(out)
            url = j.get('result_url') if isinstance(j, dict) else None
        except Exception:
            url = None
    if not url:
        missing.append(f'{seg} ({jid}: {job.get("status","?")})'); continue
    print(f'bajando {seg}...')
    subprocess.run(['curl', '-sL', url, '-o', dest], check=True)
if missing:
    print('FALTAN:', ', '.join(missing))
    raise SystemExit(1)

TRACKS = {
  'A': list(range(1,12)),                      # fachada -> escalera arriba (11)
  'B': list(range(12,27)),                     # piso 2: pasillo -> mostaza completa (15)
  'C': [51] + list(range(29,50)) + [52,53]     # cubiculos -> lab -> gris -> bajada -> calle (24)
}
for t, ns in TRACKS.items():
    with open(f'{base}/clips_v3/lista_{t}.txt', 'w') as f:
        for n in ns:
            f.write(f"file '{base}/clips_v3/seg_{n:02d}.mp4'\n")
    print(t, len(ns), 'clips')
print('clips completos')
PY

mk_master(){
  echo "master $1..."
  "$FF" -y -loglevel error -f concat -safe 0 -i "$CLIPS/lista_$1.txt" \
    -vf "setpts=0.8*PTS" -r 24 \
    -c:v libx264 -crf 17 -preset fast -pix_fmt yuv420p -movflags +faststart -an "$BASE/film/master_$1.mp4"
  du -h "$BASE/film/master_$1.mp4"
}
mk_master A
mk_master B
mk_master C
echo "MASTERS LISTOS PARA TOPAZ"
