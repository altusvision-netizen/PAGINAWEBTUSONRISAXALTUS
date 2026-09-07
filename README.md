# Clínica Dental Tu Sonrisa — Sitio web oficial

Sitio oficial de **Clínica Dental Tu Sonrisa** (San Salvador, El Salvador).
Producido por **Altus Vision**.

**En vivo:** https://tu-sonrisa-web.vercel.app

---

## Páginas

| Archivo | Qué es |
|---|---|
| `index.html` | Home: hero, especialidades, proceso CAD/CAM en 6 pasos, recorrido virtual embebido, tecnología, equipo, casos antes/después, serie de la doctora, pacientes internacionales, precios y agenda |
| `precios.html` | Tarifario completo: 172 procedimientos en 21 categorías, buscador, filtros y carrito de consulta |
| `recorrido.html` | Recorrido virtual narrado: 50 espacios reales de la clínica en 4 capítulos controlados por scroll |

Todo es HTML/CSS/JS sin dependencias ni build. Se sirve estático.

## Características

- **Bilingüe ES/EN** completo (incluye los 172 nombres de servicios y los mensajes de WhatsApp).
- **Carrito de consulta**: el paciente arma su lista de tratamientos y se genera un mensaje de WhatsApp con el detalle y el total estimado. No hay cobros en línea.
- **Recorrido virtual scroll-film**: el scroll mueve la cámara por la clínica. Versión ligera (720p) automática en teléfono.
- **Antes/después** con comparador deslizable: el blanqueamiento es un caso real de la clínica; los demás están marcados como simulación digital.
- **Agenda por WhatsApp** al +503 7021 1900.

## Estructura

```
index.html, precios.html, recorrido.html   páginas
assets/img/     fotografías del sitio
assets/video/   reels, hero, serie de la doctora, loops de pacientes
public/         films del recorrido (TS_A–TS_D + variantes _m para móvil)
anchors3/       las 50 fotos ancla del recorrido, en orden de recorrido
film/           scripts de producción del film (generación, ensamblado, encodes)
```

Los archivos intermedios de producción (clips por segmento, masters 4K, frames
extraídos) no se versionan: se regeneran con los scripts de `film/`.

## Desarrollo

```bash
npx serve -l 5173 .
```

## Despliegue

```bash
vercel --prod
```

## Pendiente de confirmar con la clínica

- Dirección exacta y enlace de Google Maps
- Correo institucional
- Redes sociales (Instagram, Facebook, TikTok)

---

© Clínica Dental Tu Sonrisa · Sitio por [Altus Vision](mailto:altusvision@altusagency.io)
