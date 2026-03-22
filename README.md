# Keymap lliwi — Corne (crkbd) con 0xCB Helios

Keymap personalizado para teclado split Corne (3x6 + 3 thumb) con controladores 0xCB Helios (RP2040). Incluye animaciones OLED, RGB Matrix por capa, tracking de WPM y un sistema de macros dinámicas con persistencia en EEPROM.

## Hardware

| Componente | Detalle |
|---|---|
| Teclado | Keebd Corne — split 3x6 + 3 thumb (42 teclas) |
| Controladores | 0xCB Helios (RP2040, reemplazo Pro Micro) |
| LEDs | 42 RGB (21/lado) vía WS2812, pin GP9 |
| OLEDs | 128x32 en ambos lados |
| Lado master | Izquierdo |

## Compilación y flasheo

Todos los comandos desde `/home/llibert/qmk_firmware`:

```bash
# Compilar (genera crkbd_rev1_lliwi_helios.uf2)
qmk compile -kb crkbd -km lliwi -e CONVERT_TO=helios

# Compilar + flashear automáticamente
./keyboards/crkbd/keymaps/lliwi/flash_rp2040.sh

# Limpiar artefactos
qmk clean
```

> **Importante**: Siempre usar `CONVERT_TO=helios`. Para entrar en bootloader, mantener RESET >500ms (aparece como `RPI-RP2`).

---

## Capas y teclas

### Capa 0 — QWERTY (base)

```
┌──────┬──────┬──────┬──────┬──────┬──────┐         ┌──────┬──────┬──────┬──────┬──────┬──────┐
│ Tab  │  Q   │  W   │  E   │  R   │  T   │         │  Y   │  U   │  I   │  O   │  P   │ Bksp │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│Sft/Cp│  A   │  S   │  D   │  F   │  G   │         │  H   │  J   │  K   │  L   │  ;   │  '   │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│ Ctrl │  Z   │  X   │  C   │  V   │  B   │         │  N   │  M   │  ,   │  .   │  /   │ Esc  │
└──────┴──────┴──────┴──────┴──────┴──────┘         └──────┴──────┴──────┴──────┴──────┴──────┘
                            ┌──────┬──────┬──────┐ ┌──────┬──────┬──────┐
                            │ GUI  │MO(1) │Space │ │Enter │MO(2) │ RAlt │
                            └──────┴──────┴──────┘ └──────┴──────┴──────┘
```

- **Sft/Cp**: Mod-tap — tap = CapsLock, hold = Left Shift
- **MO(1)**: Mantener para activar capa NUMS
- **MO(2)**: Mantener para activar capa SYMBOLS

### Capa 1 — NUMS (números y teclas de función)

```
┌──────┬──────┬──────┬──────┬──────┬──────┐         ┌──────┬──────┬──────┬──────┬──────┬──────┐
│  1   │  2   │  3   │  4   │  5   │  6   │         │  7   │  8   │  9   │  0   │  -   │ Bksp │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│Sft/F1│  F2  │  F3  │  F4  │  F5  │  F6  │         │  F7  │  F8  │  F9  │ F10  │ F11  │ F12  │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│ Ctrl │      │      │ Ctrl │ Alt  │ Del  │         │      │      │  ▽   │  ▽   │  ▽   │  ▽   │
└──────┴──────┴──────┴──────┴──────┴──────┘         └──────┴──────┴──────┴──────┴──────┴──────┘
                            ┌──────┬──────┬──────┐ ┌──────┬──────┬──────┐
                            │ GUI  │  ▽   │Space │ │Enter │MO(3) │ RAlt │
                            └──────┴──────┴──────┘ └──────┴──────┴──────┘
```

- **▽** = Transparente (pasa a la capa inferior)
- **MO(3)**: Mantener para activar capa MEDIA (desde NUMS)
- **RGB**: Todos los LEDs naranja

### Capa 2 — SYMBOLS (navegación y símbolos)

```
┌──────┬──────┬──────┬──────┬──────┬──────┐         ┌──────┬──────┬──────┬──────┬──────┬──────┐
│ Tab  │  @   │  ↑   │  $   │  %   │  ^   │         │  &   │  *   │  (   │  )   │  -   │  =   │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│Sft/Cp│  ←   │  ↓   │  →   │      │      │         │      │      │      │  [   │  ]   │  \   │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│ Ctrl │      │      │      │      │      │         │      │      │  ¥   │  <   │      │  `   │
└──────┴──────┴──────┴──────┴──────┴──────┘         └──────┴──────┴──────┴──────┴──────┴──────┘
                            ┌──────┬──────┬──────┐ ┌──────┬──────┬──────┐
                            │ GUI  │MO(3) │Space │ │Enter │  ▽   │ RAlt │
                            └──────┴──────┴──────┘ └──────┴──────┴──────┘
```

- **Flechas** en posición WASD (←↓↑→)
- **MO(3)**: Mantener para activar capa MEDIA (desde SYMBOLS)
- **RGB**: WASD blanco, resto amarillo

### Capa 3 — MEDIA (multimedia, RGB, workspaces y macros)

```
┌──────┬──────┬──────┬──────┬──────┬──────┐         ┌──────┬──────┬──────┬──────┬──────┬──────┐
│GUI+1 │GUI+2 │GUI+3 │GUI+4 │GUI+5 │GUI+6 │         │Bri ↓ │Bri ↑ │      │      │      │      │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│RShift│RGB ⏼ │Sat ↑ │Val ↑ │      │      │         │ Mute │Vol ↓ │Vol ↑ │ F20  │      │      │
├──────┼──────┼──────┼──────┼──────┼──────┤         ├──────┼──────┼──────┼──────┼──────┼──────┤
│ Ctrl │RGB → │Sat ↓ │Val ↓ │      │      │         │ Play │ Stop │Macr1 │Macr2 │Macr3 │Macr4 │
└──────┴──────┴──────┴──────┴──────┴──────┘         └──────┴──────┴──────┴──────┴──────┴──────┘
                            ┌──────┬──────┬──────┐ ┌──────┬──────┬──────┐
                            │ GUI  │  ▽   │Space │ │Enter │  ▽   │ RAlt │
                            └──────┴──────┴──────┘ └──────┴──────┴──────┘
```

- **GUI+1..6**: Cambiar workspace (Super+número)
- **RGB ⏼ / → / Sat / Val**: Control de RGB Matrix (toggle, siguiente efecto, saturación, brillo)
- **Bri ↑/↓**: Brillo de pantalla
- **Macr1–4**: Teclas de macro dinámica (ver sección siguiente)

---

## Sistema de macros dinámicas

4 slots de macro (MACRO1–MACRO4), cada uno con buffer de 128 teclas. Las macros se guardan en EEPROM y sobreviven reinicios.

| Acción | Gesto |
|---|---|
| **Reproducir** | Tap simple en la tecla de macro |
| **Grabar** | Mantener la tecla >200ms — inicia/detiene grabación |
| **Borrar** | Doble tap rápido (<300ms) |

### Comportamiento durante grabación

- Se capturan todos los eventos de tecla (press/release)
- Las teclas de cambio de capa y de macro se excluyen de la grabación
- Los mod-tap se convierten a modificadores base durante la reproducción
- Todos los LEDs parpadean en rojo como indicador visual
- El OLED master muestra "REC: M*n*"

---

## Indicadores RGB por capa

| Estado | Color |
|---|---|
| QWERTY (base) | Efecto rainbow cíclico (CYCLE_ALL) |
| NUMS | Todos naranja |
| SYMBOLS | WASD blanco, resto amarillo |
| CapsLock activo | Todos blanco suave |
| Grabando macro | Parpadeo rojo |

---

## OLEDs

- **Lado izquierdo (master)**: Capa activa, estado CapsLock, modificadores activos (S/C/A/G), estado de grabación de macro
- **Lado derecho (slave)**: Animación (configurable — actualmente Bongo Cat)

### Animaciones disponibles

| Animación | Define | Descripción |
|---|---|---|
| Bongo Cat | `USE_BONGO_ANIM` | **Activa** — gato animado que responde al WPM |
| Demon | `USE_DEMON_ANIM` | Sprite 32x36px con scroll |
| Crab | `USE_CRAB_ANIM` | Sprite 72x32px con scroll y rebote |
| Music Bars | `USE_MUSIC_BARS_ANIM` | Ecualizador a pantalla completa |

Para cambiar la animación, editar el `#define USE_*_ANIM` en `keymap.c`.

---

## Configuración destacada

| Parámetro | Valor | Descripción |
|---|---|---|
| `TAPPING_TERM` | 250ms | Tiempo para distinguir tap vs hold |
| `QUICK_TAP_TERM` | 100ms | Permite taps rápidos consecutivos |
| `RGB_MATRIX_MAXIMUM_BRIGHTNESS` | 120 | Brillo máximo de LEDs |
| `NKRO_ENABLE` | yes | N-Key Rollover |
| `LTO_ENABLE` | yes | Link-Time Optimization (firmware más pequeño) |
| `SPLIT_WPM_ENABLE` | yes | Sincroniza WPM entre ambos lados |
| `SPLIT_LAYER_STATE_ENABLE` | yes | Sincroniza estado de capas entre lados |
| `EECONFIG_USER_DATA_SIZE` | 776 bytes | Espacio EEPROM para persistencia de macros |

---

## Acceso a capa MEDIA

La capa MEDIA se activa desde NUMS o SYMBOLS mediante una combinación de dos capas:

```
Pulgar izquierdo [MO(1)] + Pulgar derecho [MO(3)]  →  MEDIA
Pulgar derecho [MO(2)] + Pulgar izquierdo [MO(3)]  →  MEDIA
```

En la práctica: mantener ambos pulgares internos activará la capa MEDIA.
