#!/usr/bin/env python3
"""Recorta las simulaciones antes/después al mismo macro cerrado del caso real
de blanqueamiento: la diferencia del tratamiento tiene que verse grande."""
from PIL import Image
import os

OUT = "assets/img"

# (origen, destino, (x0,y0,x1,y1) en fracción) — mismo encuadre para el par
CROPS = [
    ("film/gen_implante_antes.png",   "ba-implante-antes.jpg",   (0.20, 0.40, 0.80, 0.85)),
    ("film/gen_implante_despues.png", "ba-implante-despues.jpg", (0.20, 0.40, 0.80, 0.85)),
    ("film/gen_corona_antes.png",     "ba-corona-antes.jpg",     (0.22, 0.44, 0.78, 0.86)),
    ("film/gen_corona_despues.png",   "ba-corona-despues.jpg",   (0.22, 0.44, 0.78, 0.86)),
    ("film/gen_carillas_antes.png",   "ba-carillas-antes.jpg",   (0.18, 0.42, 0.82, 0.88)),
    ("film/gen_carillas_despues.png", "ba-carillas-despues.jpg", (0.18, 0.42, 0.82, 0.88)),
]

TARGET = 4 / 3

for src, dst, box in CROPS:
    im = Image.open(src).convert("RGB")
    w, h = im.size
    x0, y0, x1, y1 = int(w*box[0]), int(h*box[1]), int(w*box[2]), int(h*box[3])
    cw, ch = x1 - x0, y1 - y0
    # ajustar a 4:3 creciendo el lado corto, centrado en el recorte pedido
    if cw / ch > TARGET:
        nh = int(cw / TARGET)
        cy = (y0 + y1) // 2
        y0, y1 = max(0, cy - nh//2), min(h, cy + nh//2)
    else:
        nw = int(ch * TARGET)
        cx = (x0 + x1) // 2
        x0, x1 = max(0, cx - nw//2), min(w, cx + nw//2)
    im = im.crop((x0, y0, x1, y1)).resize((1600, 1200), Image.LANCZOS)
    im.save(f"{OUT}/{dst}", quality=88, progressive=True, optimize=True)
    print(dst, im.size)

print("CROPS LISTOS")
