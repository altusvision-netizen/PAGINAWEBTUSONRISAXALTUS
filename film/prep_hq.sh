#!/bin/bash
# Re-exportación en ALTA CALIDAD: fotos 2000-2400px q86, reels 1080x1920 crf25, mosaico EE.UU.
set -u
FF=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/film/node_modules/ffmpeg-static/ffmpeg
SRC="/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
OUT=/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/assets/video
cd /Users/davidramirez/Desktop/Altus/tu-sonrisa-web

# ---------- FOTOS ----------
python3 - <<'EOF'
from PIL import Image, ImageOps
BASE = "/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
SCOUT = "/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/scouting-extract"
OUT = "assets/img"
def save(src, dst, mx, q=86, crop=None):
    im = Image.open(src); im = ImageOps.exif_transpose(im).convert("RGB")
    if crop:
        w,h = im.size
        im = im.crop((int(w*crop[0]), int(h*crop[1]), int(w*crop[2]), int(h*crop[3])))
    im.thumbnail((mx,mx), Image.LANCZOS)
    im.save(f"{OUT}/{dst}", quality=q, progressive=True, optimize=True)
    print(dst, im.size)
P = [
 (f"film/gen_fachada.png","fachada.jpg",2400),
 (f"{SCOUT}/p03_X14.jpg","lobby.jpg",2200),
 (f"{SCOUT}/p04_X18.jpg","recepcion-cadcam.jpg",2200),
 (f"{SCOUT}/p05_X22.jpg","neon-rosa.jpg",2400),
 (f"{SCOUT}/p08_X33.jpg","lounge-p2.jpg",2200),
 (f"{SCOUT}/p09_X38.jpg","sala-azul.jpg",2200),
 (f"{SCOUT}/p12_X49.jpg","sala-mostaza.jpg",2200),
 (f"{SCOUT}/p15_X61.jpg","cubiculo.jpg",2200),
 (f"{SCOUT}/p20_X81.jpg","sala-juntas.jpg",2200),
 (f"{SCOUT}/p22_X90.jpg","axeos.jpg",2200),
 (f"{SCOUT}/p21_X86.jpg","radiologia-control.jpg",2200),
 ("film/gen_fresadoras.png","lab-fresadoras.jpg",2200),
 ("film/gen_hornos.png","lab-hornos.jpg",2200),
 (f"{SCOUT}/p24_X97.jpg","inlab-macro.jpg",2000),
 ("film/gen_axeosfront.png","axeos-frontal.jpg",2200),
 (f"{BASE}/TEAM/clinica-01.jpg","equipo-grupo.jpg",2600),
 (f"{BASE}/TEAM/ALEL6757-Mejorado-NR-Editar.jpg","tec-cadcam-dra.jpg",2000),
 (f"{BASE}/TEAM/ALEL6801.jpg","tec-scanner.jpg",2000),
 (f"{BASE}/TEAM/ALEL3762.JPG","esp-cirugia.jpg",2000),
 (f"{BASE}/TEAM/ALEL7387.JPG","equipo-doctoras.jpg",2000),
 (f"{BASE}/TEAM/ALEL7636.JPG","esp-general.jpg",2000),
 (f"{BASE}/TEAM/ALEL7730.JPG","esp-operatoria.jpg",2000),
 (f"{BASE}/TEAM/ALEL7898.JPG","esp-endodoncia.jpg",2000),
 (f"{BASE}/TEAM/ALEL7882.JPG","esp-periodoncia.jpg",2000),
 (f"{BASE}/TEAM/ALEL7820.JPG","pac-tomografo.jpg",2000),
 (f"{BASE}/TEAM/ALEL7590.JPG","plan-tratamiento.jpg",2000),
 (f"{BASE}/TEAM/ALEL7575.JPG","tec-pantalla.jpg",2000),
 (f"{BASE}/TEAM/ALEL9285.JPG","tec-dra-scanner.jpg",2000),
 (f"{BASE}/TEAM/clinica-05.jpg","esp-implante-macro.jpg",2000),
 (f"{BASE}/TEAM/clinica-03.jpg","manos-dientes.jpg",2000),
 (f"{BASE}/DRA. STEPHANNIE PALACIOS/ALEL6409.JPG","dra-stephanie.jpg",2200),
 (f"{BASE}/DRA. STEPHANNIE PALACIOS/ALEL4050.JPG","dra-radiografia.jpg",2000),
 (f"{BASE}/DRA. STEPHANNIE PALACIOS/ALEL3975.JPG","dra-lounge.jpg",2200),
 (f"{BASE}/DRA. STEPHANNIE PALACIOS/clinica-08.jpg","dra-retrato.jpg",2000),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5399.JPG","sonrisa-modelo.jpg",2000),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5366.JPG","blanq-espejo.jpg",2200),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5357.JPG","blanq-proceso.jpg",2200),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5376.JPG","blanq-macro.jpg",2000),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5450.JPG","recepcion-modelo.jpg",2000),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5711.JPG","rotulo-sol.jpg",2000),
 (f"{BASE}/BLANQUEAMIENTO /1V6A5294.JPG","blanq-uv.jpg",2000),
 (f"{BASE}/PACIENTES/ALEL7913.JPG","pac-senora.jpg",2000),
 (f"{BASE}/PACIENTES/ALEL7944.JPG","pac-sonrisa-macro.jpg",2000),
 (f"{BASE}/PACIENTES/ALEL7867.JPG","pac-hermanas.jpg",2000),
 (f"{BASE}/PACIENTES/ALEL7840.JPG","pac-retenedor.jpg",2000),
 (f"{BASE}/hero VIDEOS HORIZONTALES/ALEL6717.jpg","tec-primescan.jpg",2000),
 (f"{BASE}/hero VIDEOS HORIZONTALES/197A0938.JPG","tec-sirona.jpg",2000),
 ("film/gen_implante_antes.png","ba-implante-antes.jpg",2000),
 ("film/gen_implante_despues.png","ba-implante-despues.jpg",2000),
 ("film/gen_corona_antes.png","ba-corona-antes.jpg",2000),
 ("film/gen_corona_despues.png","ba-corona-despues.jpg",2000),
 ("film/gen_carillas_antes.png","ba-carillas-antes.jpg",2000),
 ("film/gen_carillas_despues.png","ba-carillas-despues.jpg",2000),
]
for src,dst,mx in P:
    try: save(src,dst,mx)
    except Exception as e: print("ERR",dst,e)
# antes/después blanqueamiento real, re-crop en alta
im = Image.open(f"{BASE}/BLANQUEAMIENTO /Mesa de trabajo 1.jpg")
W,H = im.size; third = H//3
def crop43(top,name):
    seg = im.crop((0,top,W,top+third))
    tw = int(third*4/3)
    if tw <= W:
        x=(W-tw)//2; seg = seg.crop((x,0,x+tw,third))
    seg.save(f"assets/img/{name}", quality=90, progressive=True)
    print(name, seg.size)
crop43(0,"ba-antes.jpg"); crop43(H-third,"ba-despues.jpg")
print("FOTOS HQ OK")
EOF

# ---------- REELS 1080x1920 crf25 ----------
enc_v(){ "$FF" -y -loglevel error -i "$1" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 25 -preset slow -pix_fmt yuv420p -movflags +faststart -c:a aac -b:a 128k -ac 2 "$OUT/$2" && echo "ok $2"; }
enc_v "$SRC/EXPERIENCIA TU SONRISA .mp4" "reel-experiencia.mp4"
enc_v "$SRC/UNA SOLA CITA .mp4" "reel-unacita.mp4"
enc_v "$SRC/Blanqueamiento 10 min.mp4" "reel-blanqueamiento.mp4"
enc_v "$SRC/No hacemos diseños de sonrisa falsos.mp4" "reel-sonrisas-reales.mp4"
enc_v "$SRC/PACIENTES AL EXTRANGERO /CDTS - Pacientes EEUU.mp4" "reel-eeuu.mp4"

# ---------- INDICACIONES 1080 ----------
i=1
for f in "01 " "02 " "03 " "04 " "05 " "06 "; do
  enc_v "$SRC/INDICACIONES A PACIENTES /$f.mp4" "ind-0$i.mp4"
  "$FF" -y -loglevel error -ss 1 -i "$OUT/ind-0$i.mp4" -frames:v 1 -q:v 4 "$OUT/ind-0$i.jpg"
  i=$((i+1))
done

# ---------- MOSAICO EE.UU. (loops mudos 1080) ----------
"$FF" -y -loglevel error -i "$SRC/PACIENTES AL EXTRANGERO /LOOP VISITA USA .MOV" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 25 -preset slow -pix_fmt yuv420p -movflags +faststart -an "$OUT/loop-usa.mp4" && echo "ok loop-usa"
"$FF" -y -loglevel error -ss 0 -t 18 -i "$SRC/PACIENTES AL EXTRANGERO /02 HERMANOS LEJANOS .MOV" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p -movflags +faststart -an "$OUT/loop-hermanos.mp4" && echo "ok loop-hermanos"
"$FF" -y -loglevel error -ss 4 -t 18 -i "$SRC/PACIENTES AL EXTRANGERO /Caso paciente EEUU 01.mp4" -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p -movflags +faststart -an "$OUT/loop-caso-eeuu.mp4" && echo "ok loop-caso-eeuu"

# posters de reels en alta
for r in experiencia unacita blanqueamiento sonrisas-reales eeuu; do
  "$FF" -y -loglevel error -ss 2 -i "$OUT/reel-$r.mp4" -frames:v 1 -q:v 4 "$OUT/reel-$r.jpg"
done

# ---------- HERO master hq (para Topaz) ----------
"$FF" -y -loglevel error -f concat -safe 0 -i film/hero_list.txt -c:v libx264 -crf 18 -preset fast -an film/hero_master.mp4 && echo "hero_master ok"

du -sh "$OUT"
echo "PREP HQ LISTO"
