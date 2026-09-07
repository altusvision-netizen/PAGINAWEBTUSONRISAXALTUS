#!/usr/bin/env python3
# Emite una línea por segmento al llegar a estado terminal; sale cuando todos terminaron.
import json, glob, subprocess, time, sys, os

BASE = '/Users/davidramirez/Desktop/Altus/tu-sonrisa-web'
HF = f'{BASE}/film/node_modules/.bin/higgsfield'
JOBS = f'{BASE}/film/jobs'
TERMINAL_OK = {'completed'}
TERMINAL_BAD = {'failed', 'error', 'nsfw', 'canceled', 'cancelled'}

segs = {}
for f in sorted(glob.glob(f'{JOBS}/seg_[0-9][0-9].json')):
    raw = json.load(open(f))
    segs[os.path.basename(f)[:-5]] = raw[0] if isinstance(raw, list) else raw['id']

print(f'{len(segs)} segmentos a vigilar', flush=True)
done = set()
while True:
    try:
        out = subprocess.run([HF, 'generate', 'list', '--json'], capture_output=True, text=True, timeout=120).stdout
        jobs = {j['id']: j for j in json.loads(out)}
    except Exception:
        time.sleep(60)
        continue
    for seg, jid in segs.items():
        if seg in done:
            continue
        st = jobs.get(jid, {}).get('status', '')
        if st in TERMINAL_OK:
            done.add(seg); print(f'{seg} TERMINADO', flush=True)
        elif st in TERMINAL_BAD:
            done.add(seg); print(f'{seg} FALLO ({st})', flush=True)
    if len(done) == len(segs):
        print('TODOS_TERMINADOS', flush=True)
        sys.exit(0)
    time.sleep(60)
