# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Custom QMK firmware keymap for the Corne (crkbd) split keyboard with 0xCB Helios controllers (RP2040-based). Features OLED animations, RGB Matrix, WPM tracking, and a custom dynamic macro system with EEPROM persistence.

## Hardware

- **Keyboard**: Keebd Corne (split 3x6 + 3 thumb keys, 42 keys total)
- **Controllers**: 0xCB Helios (RP2040-based Pro Micro replacement)
- **LEDs**: 42 RGB LEDs (21 per side) via WS2812, pin B5/GP9 (configured as `9U` in config.h)
- **OLEDs**: 128x32 on both halves
- **Master side**: Left (MASTER_LEFT)

**IMPORTANT**: Always use `CONVERT_TO=helios` when compiling. There is no native Keebd Corne definition in QMK, so we use crkbd rev1 with Helios conversion.

## Build & Flash Commands

All commands run from `/home/llibert/qmk_firmware`:

```bash
# Standard build (produces crkbd_rev1_lliwi_helios.uf2)
qmk compile -kb crkbd -km lliwi -e CONVERT_TO=helios

# Compile + flash via automated script (waits for bootloader, mounts, copies)
./keyboards/crkbd/keymaps/lliwi/flash_rp2040.sh

# Clean build artifacts
qmk clean

# Alternative: build for rev4_1 (different hardware variant)
./keyboards/crkbd/keymaps/lliwi/build.sh
```

To enter bootloader mode on Helios: hold RESET button >500ms. The device appears as `RPI-RP2`.

## Code Architecture

### Layer Structure (keymap.c)

4 layers defined in `enum layer_names`:
- `_QWERTY` (0): Base layer. Shift/CapsLock as mod-tap on left home row.
- `_NUMS` (1): Numbers row + F1-F12. Accessed via `MO(1)` on left thumb.
- `_SYMBOLS` (2): Navigation arrows (WASD position) + symbols. Accessed via `MO(2)` on right thumb.
- `_MEDIA` (3): RGB controls, media keys, brightness, workspace switching (GUI+1-6), and macro keys. Accessed via `MO(3)` from either _NUMS or _SYMBOLS layer.

### Dynamic Macro System (keymap.c)

Custom implementation (not QMK's built-in `DYNAMIC_MACRO_ENABLE` feature):

- **4 macro slots** (MACRO1-MACRO4), each with 128-key buffer
- **Controls**: Tap = playback, Hold (>200ms) = start/stop recording, Double-tap (<300ms) = clear macro
- **EEPROM persistence**: Macros survive power cycles via `EECONFIG_USER_DATA_SIZE` (776 bytes)
- **Recording**: Captures press/release events. Layer-switching keys and macro keys are excluded from recording. Mod-tap keys are converted to base modifiers during playback.
- **Visual feedback**: All LEDs blink red during recording

Deferred execution (`DEFERRED_EXEC_ENABLE`) handles the double-tap detection delay before playback.

### OLED Animation System

Animation selection via `#define USE_*_ANIM` in keymap.c (currently `USE_BONGO_ANIM`):

| Animation | File | Size | Features |
|-----------|------|------|----------|
| Bongo | animations/bongo.c | 55KB | Currently active |
| Demon | animations/demon.c | 32x36px | Scroll support |
| Crab | animations/crab.c | 72x32px | Scroll + bounce |
| Music Bars | animations/music-bars.c | 128x32px | Full-screen equalizer |

**Framework** (animations/animation-utils.c): Shared renderer with WPM-based animation speed switching. Key defines: `FAST_TYPE_WPM` (threshold), `ANIM_FRAME_TIME`, `ANIM_SCROLL`, `ANIM_BOUNCE`. Used by demon and crab; bongo and music-bars have their own renderers.

**OLED layout**: Master (left) shows layer/lock/mods/macro status. Slave (right) shows animation.

### RGB Matrix Indicators (keymap.c)

Per-layer RGB overrides in `rgb_matrix_indicators_user()`:
- Recording macro: All LEDs blink red
- _SYMBOLS layer: WASD keys white, rest yellow
- _NUMS layer: All LEDs orange
- Caps Lock active: All LEDs soft white
- Default (_QWERTY): Uses configured effect (CYCLE_ALL rainbow)

### Configuration Files

- **config.h**: Hardware pins, tapping term (250ms), RGB Matrix brightness (120 max), RGBLIGHT settings (54 LEDs if enabled, currently disabled), split sync flags, EEPROM size
- **rules.mk**: Feature flags. Enabled: RGB_MATRIX, OLED, WPM, NKRO, LTO, DYNAMIC_MACRO, DEFERRED_EXEC. Disabled: RGBLIGHT, MOUSEKEY, TAP_DANCE. Board: GENERIC_RP_RP2040, WS2812_DRIVER=vendor

### WS2812 Pin Notes

The correct pin for Keebd Corne + Helios is `B5 -> GP9`, configured as `#define WS2812_DI_PIN 9U`. If RGB stops working after hardware changes, alternative pins to try: D3 (GP0), B0 (GP13), D1 (GP2), D0 (GP3), D4 (GP4), D5 (GP12).

## Adding a New Animation

1. Create `animations/your_anim.c` with frame data in `PROGMEM` arrays
2. Implement a render function (e.g., `your_anim_oled_render_anim()`)
3. For frame-based animations, use the shared framework from `animation-utils.c` and set `ANIM_FRAME_WIDTH`, `ANIM_SIZE`
4. Add a `USE_YOUR_ANIM` conditional block in keymap.c following the existing pattern
5. Map it with `#define oled_render_anim your_anim_oled_render_anim`
