# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a custom QMK firmware keymap for the Corne (crkbd) keyboard with RP2040 microcontroller. The keymap includes custom OLED animations that respond to typing speed (WPM-based).

## Hardware Configuration

- **Keyboard**: Keebd Corne (https://keebd.com/es-es/products/corne-mx-asembled-keyboard)
- **Controllers**: 0xCB Helios (RP2040-based Pro Micro replacement)
- **Layout**: Split 3x6 + 3 thumb keys
- **Features**:
  - RGBLIGHT (WS2812 LEDs, **54 total - 27 per side**)
  - OLED displays on both halves (128x32)
  - Master side: Left half (configured via MASTER_LEFT)
  - RP2040 bootloader with double-tap reset support
  - WPM tracking synchronized between sides

**IMPORTANT**: Use `CONVERT_TO=helios` for proper Helios controller support with correct pin mappings.

## Building and Flashing

**IMPORTANTE**: Este keymap es para **Keebd Corne con controladores 0xCB Helios**.

### Build the firmware (MÉTODO CORRECTO)
```bash
# Desde el directorio raíz de QMK
cd /home/llibert/qmk_firmware
qmk compile -kb crkbd -km lliwi -e CONVERT_TO=helios
```

Esto genera: `crkbd_rev1_lliwi_helios.uf2`

### Flash to keyboard

#### Método recomendado: Script automático
```bash
cd /home/llibert/qmk_firmware/keyboards/crkbd/keymaps/lliwi
./flash_rp2040.sh
```

#### Método manual (desde Arch Linux)
```bash
# 1. Entra en modo bootloader (mantén RESET presionado >500ms en Helios)
# 2. Espera a que aparezca la unidad en /run/media/$USER/RPI-RP2
# 3. Copia el firmware
cp /home/llibert/qmk_firmware/crkbd_rev1_lliwi_helios.uf2 /run/media/$USER/RPI-RP2/
```

### Clean build artifacts
```bash
qmk clean
```

### Por qué usar CONVERT_TO=rp2040_ce

Usamos CONVERT_TO porque no existe una definición específica de "Keebd Corne" en QMK. Esto significa:
- Usamos la base de crkbd rev1 con conversión a RP2040
- Pin WS2812: Actualmente configurado como **D5 → GP12**
- Si no funciona, probar: D3 (GP0), B0 (GP13), D1 (GP2), D0 (GP3), D4 (GP4)
- El pin real del hardware es probablemente GP16, pero no es accesible via CONVERT_TO
- LEDs: **42 totales (21 por lado)** - definidos en keyboard.json custom
- El conversor mapea todos los pines de Pro Micro a RP2040

## Code Architecture

### Layer Structure
The keymap defines 4 layers in [keymap.c](keymap.c:12-17):
- `_QWERTY` (0): Base QWERTY layer
- `_FN1` (1): Numbers and function keys
- `_FN2` (2): Navigation and symbols
- `_MEDIA` (3): RGB controls and media keys

### OLED Animation System

The keymap includes three custom OLED animations, all based on a shared animation framework:

**Animation Framework** ([animation-utils.c](animation-utils.c)):
- Provides `oled_render_anim_frame()` function that handles frame timing and rendering
- Supports WPM (words per minute) detection to switch between idle and fast typing animations
- Configurable via preprocessor defines (FAST_TYPE_WPM, ANIM_FRAME_TIME, etc.)
- Optional WPM display sidebar
- Supports scrolling and bouncing animations

**Available Animations**:
1. **Demon Animation** ([demon.c](demon.c)) - 32x36px demon sprite with 4 idle and 4 running frames
2. **Crab Animation** ([crab.c](crab.c)) - 72x32px crab sprite with 6 idle and 6 running frames, includes scrolling and bouncing
3. **Music Bars** ([music-bars.c](music-bars.c)) - 128x32px full-screen music equalizer bars that animate based on typing speed

**To switch animations**:
- Animation files are self-contained with `#pragma once` and define their own `oled_render_anim()` function
- Include the desired animation file directly in your keymap code
- Each animation has different frame dimensions (ANIM_FRAME_WIDTH) and rotation requirements specified in comments

### Configuration Files

**[config.h](config.h)** - Hardware and feature configuration:
- RGB Matrix settings (54 LEDs, maximum brightness 150)
- RGBLIGHT effects (if enabled)
- WS2812 pin configuration (GP0)
- RP2040 bootloader double-tap settings
- Master/slave configuration

**[rules.mk](rules.mk)** - Feature compilation flags:
- Enables: RGB_MATRIX, OLED, NKRO, EXTRAKEY, LTO
- Disables: RGBLIGHT, MOUSEKEY, TAP_DANCE
- Sets board type and bootloader

## Development Guidelines

### Adding New Animations

To create a new OLED animation:
1. Use the animation framework from [animation-utils.c](animation-utils.c)
2. Define frame data as `const char PROGMEM` arrays
3. Create separate frame arrays for fast and slow typing
4. Implement `oled_render_anim()` function that calls `oled_render_anim_frame()`
5. Configure animation settings via `#define` directives:
   - `ANIM_FRAME_WIDTH` - width of each animation frame
   - `ANIM_SIZE` - total size of animation data
   - `FAST_TYPE_WPM` - WPM threshold for switching to fast animation
   - `ANIM_SCROLL` - enable horizontal scrolling
   - `ANIM_BOUNCE` - enable bounce effect at edges

### RGB Matrix Configuration

RGB settings are controlled via the MEDIA layer and can be adjusted in [config.h](config.h:56-70):
- Total LED count: 54 (27 per side)
- Maximum brightness: 150 (can be increased up to 255)
- Default mode: SOLID_COLOR
- Enabled effects: BREATHING, CYCLE_ALL, RAINBOW_MOVING_CHEVRON

### Keymap Modifications

The keymap is auto-generated from JSON ([keymap.c](keymap.c:7-11)) but can be edited directly. The layout uses QMK's `LAYOUT_split_3x6_3` macro for the Corne's 42-key configuration.

## File Structure

```
lliwi/
├── keymap.c              # Main keymap definition with layer layouts
├── config.h              # Hardware configuration and feature settings
├── rules.mk              # Compilation rules and feature flags
├── animation-utils.c     # Shared animation framework
├── demon.c               # Demon sprite animation (32x36px)
├── crab.c                # Crab sprite animation (72x32px)
├── music-bars.c          # Music equalizer animation (128x32px)
└── keymap.c.bak2         # Backup of previous keymap
```

## QMK-Specific Notes

- This keymap uses the RP2040 vendor WS2812 driver for RGB control
- LTO (Link Time Optimization) is enabled to reduce firmware size
- The keyboard can be reset to bootloader by double-tapping the reset button within 200ms
- GPIO pin GP12 (D5 in Pro Micro mapping) is currently configured for WS2812 LED data line

## RGB Matrix Configuration

### Current Status

The firmware includes RGB Matrix with **42 LEDs (21 per side)** configured for Keebd Corne hardware.

**Test Firmware**: The current build includes diagnostic code that blinks all LEDs red/green every 500ms to verify the RGB Matrix is working.

**Custom Files**:
- `keyboard.json`: Defines the 42 LED layout specific to Keebd Corne
- `keymap.c`: Contains test functions `keyboard_post_init_user()` and `housekeeping_task_user()`
- `config.h`: WS2812 pin configuration (currently D5/GP12)

### Pin Testing

If RGB doesn't work with the current pin (D5/GP12), try these alternatives in `config.h`:

```c
// Option 1 (current): D5 → GP12
#define WS2812_DI_PIN D5

// Option 2: D3 → GP0 (crkbd rev1 standard)
#define WS2812_DI_PIN D3

// Option 3: B0 → GP13
#define WS2812_DI_PIN B0

// Option 4: D1 → GP2
#define WS2812_DI_PIN D1

// Option 5: D0 → GP3
#define WS2812_DI_PIN D0

// Option 6: D4 → GP4
#define WS2812_DI_PIN D4
```

After changing the pin, recompile and flash to test.

### RGB Controls (Layer MEDIA)

Access by holding FN1 + FN2 simultaneously, then:

- **Q**: RGB On
- **W**: RGB Off
- **Caps Lock**: Toggle RGB
- **A**: Increase Hue
- **Z**: Decrease Hue
- **S**: Increase Saturation
- **X**: Decrease Saturation
- **D**: Increase Brightness
- **C**: Decrease Brightness
- **Left Ctrl**: Next Effect

### Troubleshooting

See [KEEBD_CORNE_FIX.md](KEEBD_CORNE_FIX.md) for detailed troubleshooting steps and pin testing procedures.

**Quick diagnosis**:
1. Flash firmware
2. Observe if LEDs blink red/green
3. If yes: RGB works! Disable test code and enjoy
4. If no: Try different pins in order: D3, B0, D1, D0, D4
