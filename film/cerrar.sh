#!/bin/bash
set -u
cd /Users/davidramirez/Desktop/Altus/tu-sonrisa-web
until ! pgrep -f "ffmpeg" >/dev/null 2>&1; do sleep 20; done
echo "== encodes terminados, regenerando pósters =="
bash film/posters.sh
echo ""
echo "== VERIFICANDO REFERENCIAS =="
python3 - <<'PY'
import re, os
faltan=[]
for h in ["index.html","precios.html","recorrido.html"]:
    s=open(h).read()
    for m in set(re.findall(r'["\'](assets/[^"\']+|public/[^"\']+)["\']', s)):
        if not os.path.exists(m): faltan.append(f"{h}: {m}")
print("\n".join(faltan) if faltan else "todas las referencias resuelven OK")
PY
echo ""
echo "== PESO FINAL DEL SITIO =="
du -sh public assets/video assets/img anchors3
ls -la assets/video/*.mp4 public/*.mp4 | awk '{s+=$5} END {printf "TOTAL VIDEO: %.0f MB\n", s/1048576}'
echo ""
echo "== DEPLOY A PRODUCCIÓN =="
/private/tmp/claude-501/-Users-davidramirez-Desktop-Altus/f17eb7d2-a7e5-4bcd-8cd0-6da43fdb5426/scratchpad/node_modules/.bin/vercel --prod --yes 2>&1 | grep -Ei "aliased|error" | head -3
