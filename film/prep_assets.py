#!/usr/bin/env python3
# Optimiza fotos del material a assets web (JPEG progresivo, max 1800px lado largo).
from PIL import Image, ImageOps
import os

BASE = "/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/MULTIMEDIA MEDICINA "
SCOUT = "/Users/davidramirez/Desktop/Altus/PAGINA WEB CLINICA DENTAL TU SORNISA/scouting-extract"
OUT = "/Users/davidramirez/Desktop/Altus/tu-sonrisa-web/assets/img"
os.makedirs(OUT, exist_ok=True)

# (origen, destino, lado_max)
PICKS = [
    # clínica / scouting
    (f"{SCOUT}/p01_X4.jpg",  "fachada.jpg", 1800),
    (f"{SCOUT}/p03_X14.jpg", "lobby.jpg", 1800),
    (f"{SCOUT}/p04_X18.jpg", "recepcion-cadcam.jpg", 1800),
    (f"{SCOUT}/p05_X22.jpg", "neon-rosa.jpg", 1800),
    (f"{SCOUT}/p08_X33.jpg", "lounge-p2.jpg", 1800),
    (f"{SCOUT}/p09_X38.jpg", "sala-azul.jpg", 1800),
    (f"{SCOUT}/p12_X49.jpg", "sala-mostaza.jpg", 1800),
    (f"{SCOUT}/p15_X61.jpg", "cubiculo.jpg", 1800),
    (f"{SCOUT}/p20_X81.jpg", "sala-juntas.jpg", 1800),
    (f"{SCOUT}/p22_X90.jpg", "axeos.jpg", 1800),
    (f"{SCOUT}/p21_X86.jpg", "radiologia-control.jpg", 1800),
    (f"{SCOUT}/p23_X94.jpg", "lab-fresadoras.jpg", 1800),
    (f"{SCOUT}/p24_X98.jpg", "lab-hornos.jpg", 1800),
    (f"{SCOUT}/p24_X97.jpg", "inlab-macro.jpg", 1600),
    # equipo
    (f"{BASE}/TEAM/clinica-01.jpg", "equipo-grupo.jpg", 2000),
    (f"{BASE}/TEAM/ALEL6757-Mejorado-NR-Editar.jpg", "tec-cadcam-dra.jpg", 1600),
    (f"{BASE}/TEAM/ALEL6801.jpg", "tec-scanner.jpg", 1400),
    (f"{BASE}/TEAM/ALEL3762.JPG", "esp-cirugia.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7387.JPG", "equipo-doctoras.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7636.JPG", "esp-general.jpg", 1400),
    (f"{BASE}/TEAM/ALEL7730.JPG", "esp-operatoria.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7898.JPG", "esp-endodoncia.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7882.JPG", "esp-periodoncia.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7820.JPG", "pac-tomografo.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7590.JPG", "plan-tratamiento.jpg", 1600),
    (f"{BASE}/TEAM/ALEL7575.JPG", "tec-pantalla.jpg", 1400),
    (f"{BASE}/TEAM/ALEL9285.JPG", "tec-dra-scanner.jpg", 1400),
    (f"{BASE}/TEAM/clinica-05.jpg", "esp-implante-macro.jpg", 1400),
    (f"{BASE}/TEAM/clinica-03.jpg", "manos-dientes.jpg", 1400),
    # dra stephannie
    (f"{BASE}/DRA. STEPHANNIE PALACIOS/ALEL6409.JPG", "dra-stephanie.jpg", 1600),
    (f"{BASE}/DRA. STEPHANNIE PALACIOS/ALEL4050.JPG", "dra-radiografia.jpg", 1400),
    (f"{BASE}/DRA. STEPHANNIE PALACIOS/ALEL3975.JPG", "dra-lounge.jpg", 1600),
    (f"{BASE}/DRA. STEPHANNIE PALACIOS/clinica-08.jpg", "dra-retrato.jpg", 1400),
    # blanqueamiento / estética
    (f"{BASE}/BLANQUEAMIENTO /1V6A5399.JPG", "sonrisa-modelo.jpg", 1400),
    (f"{BASE}/BLANQUEAMIENTO /1V6A5366.JPG", "blanq-espejo.jpg", 1600),
    (f"{BASE}/BLANQUEAMIENTO /1V6A5357.JPG", "blanq-proceso.jpg", 1600),
    (f"{BASE}/BLANQUEAMIENTO /1V6A5376.JPG", "blanq-macro.jpg", 1400),
    (f"{BASE}/BLANQUEAMIENTO /1V6A5450.JPG", "recepcion-modelo.jpg", 1600),
    (f"{BASE}/BLANQUEAMIENTO /1V6A5711.JPG", "rotulo-sol.jpg", 1400),
    (f"{BASE}/BLANQUEAMIENTO /1V6A5294.JPG", "blanq-uv.jpg", 1400),
    # pacientes
    (f"{BASE}/PACIENTES/ALEL7913.JPG", "pac-senora.jpg", 1400),
    (f"{BASE}/PACIENTES/ALEL7944.JPG", "pac-sonrisa-macro.jpg", 1400),
    (f"{BASE}/PACIENTES/ALEL7867.JPG", "pac-hermanas.jpg", 1400),
    (f"{BASE}/PACIENTES/ALEL7840.JPG", "pac-retenedor.jpg", 1400),
    (f"{BASE}/VIDEOS HORIZONTALES/ALEL6717.jpg", "tec-primescan.jpg", 1600),
    (f"{BASE}/VIDEOS HORIZONTALES/197A0938.JPG", "tec-sirona.jpg", 1600),
]

for src, dst, mx in PICKS:
    try:
        im = Image.open(src)
        im = ImageOps.exif_transpose(im)
        im.thumbnail((mx, mx), Image.LANCZOS)
        im = im.convert("RGB")
        im.save(f"{OUT}/{dst}", quality=80, progressive=True, optimize=True)
        print(f"ok {dst} {im.size}")
    except Exception as e:
        print(f"ERROR {dst}: {e}")
print("fotos listas")
