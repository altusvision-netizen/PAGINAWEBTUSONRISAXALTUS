#!/bin/bash
# Regenera los pósters desde los videos ya optimizados, en WebP.
set -eu
cd /Users/davidramirez/Desktop/Altus/tu-sonrisa-web
FF=./film/node_modules/ffmpeg-static/ffmpeg
pos(){ $FF -y -loglevel error -ss "$2" -i "assets/video/$1.mp4" -frames:v 1 -q:v 3 "/tmp/p_$1.jpg" \
  && python3 -c "
from PIL import Image
im=Image.open('/tmp/p_$1.jpg').convert('RGB')
im.save('assets/video/$1.webp','WEBP',quality=84,method=6)" && rm -f "/tmp/p_$1.jpg"; }
for r in experiencia unacita blanqueamiento sonrisas-reales eeuu; do pos "reel-$r" 2; done
for i in 1 2 3 4 5 6; do pos "ind-0$i" 1; done
for l in usa hermanos caso-eeuu; do pos "loop-$l" 1.5; done
$FF -y -loglevel error -ss 0.8 -i assets/video/hero.mp4 -frames:v 1 -q:v 3 /tmp/hp.jpg
python3 -c "
from PIL import Image
Image.open('/tmp/hp.jpg').convert('RGB').save('assets/img/hero-poster.webp','WEBP',quality=86,method=6)"
$FF -y -loglevel error -ss 0 -i assets/video/maquina.mp4 -frames:v 1 -q:v 3 /tmp/mp.jpg
python3 -c "
from PIL import Image
Image.open('/tmp/mp.jpg').convert('RGB').save('assets/img/mq-poster.webp','WEBP',quality=86,method=6)"
echo "POSTERS REGENERADOS"
