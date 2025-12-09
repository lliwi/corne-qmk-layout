/*
This is the c configuration file for the keymap

Copyright 2012 Jun Wako <wakojun@gmail.com>
Copyright 2015 Jack Humbert

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once

#define MASTER_LEFT

//#define USE_MATRIX_I2C

#define TAPPING_TERM 250        // Tiempo para distinguir tap vs hold (ms)
#define QUICK_TAP_TERM 100      // Permite taps rápidos consecutivos

#ifdef RGBLIGHT_ENABLE
    // Número de LEDs: 54 totales (27 por lado) para Corne v3
    #define RGBLIGHT_LED_COUNT 54
    #define RGBLIGHT_SPLIT
    #define RGBLIGHT_SPLIT_COUNT {27, 27}

    // Efectos
    #define RGBLIGHT_EFFECT_BREATHING
    #define RGBLIGHT_EFFECT_RAINBOW_MOOD
    #define RGBLIGHT_EFFECT_RAINBOW_SWIRL
    #define RGBLIGHT_EFFECT_SNAKE
    #define RGBLIGHT_EFFECT_KNIGHT
    #define RGBLIGHT_EFFECT_CHRISTMAS
    #define RGBLIGHT_EFFECT_STATIC_GRADIENT
    #define RGBLIGHT_EFFECT_RGB_TEST
    #define RGBLIGHT_EFFECT_ALTERNATING
    #define RGBLIGHT_EFFECT_TWINKLE

    // Configuración
    #ifdef RGBLIGHT_LIMIT_VAL
        #undef RGBLIGHT_LIMIT_VAL
    #endif
    #define RGBLIGHT_LIMIT_VAL 120

    #define RGBLIGHT_HUE_STEP 10
    #define RGBLIGHT_SAT_STEP 17
    #define RGBLIGHT_VAL_STEP 17

    // Encender por defecto con configuración específica
    #define RGBLIGHT_DEFAULT_ON true
    #define RGBLIGHT_DEFAULT_MODE RGBLIGHT_MODE_STATIC_LIGHT  // Luz estática
    #define RGBLIGHT_DEFAULT_HUE 128   // Cian/Azul verdoso (0-255: 0=rojo, 85=verde, 170=azul)
    #define RGBLIGHT_DEFAULT_SAT 255   // Saturación máxima
    #define RGBLIGHT_DEFAULT_VAL 100   // Brillo medio (0-150)
#endif

// Configuración WS2812 para Keebd Corne con controladores 0xCB Helios
// Pin correcto encontrado mediante pruebas: B5 = GP9

#ifdef WS2812_DI_PIN
    #undef WS2812_DI_PIN
#endif
#define WS2812_DI_PIN 9U  // B5 -> GP9 (¡Pin correcto verificado!)

// Configuración RGB Matrix
#ifdef RGB_MATRIX_ENABLE
    // Sobrescribir brillo máximo si ya está definido
    #ifdef RGB_MATRIX_MAXIMUM_BRIGHTNESS
        #undef RGB_MATRIX_MAXIMUM_BRIGHTNESS
    #endif
    #define RGB_MATRIX_MAXIMUM_BRIGHTNESS 120

    // LED count y layout definidos en keyboard.json (42 LEDs totales, 21 por lado)

    // Configuración por defecto
    #define RGB_MATRIX_DEFAULT_MODE RGB_MATRIX_CYCLE_ALL  // Efecto rainbow cíclico
    #define RGB_MATRIX_DEFAULT_HUE 0    // No importa en modo rainbow
    #define RGB_MATRIX_DEFAULT_SAT 255  // Saturación máxima
    #define RGB_MATRIX_DEFAULT_VAL 100  // Brillo medio

    // Encender RGB Matrix al inicio automáticamente
    #define RGB_MATRIX_DEFAULT_ON true

    // Timeouts para ahorro de energía (comentado para debug)
    // #define RGB_MATRIX_TIMEOUT 300000  // 5 minutos
    // #define RGB_DISABLE_WHEN_USB_SUSPENDED

    // Efectos habilitados - básicos para empezar
    #define ENABLE_RGB_MATRIX_SOLID_COLOR
    #define ENABLE_RGB_MATRIX_ALPHAS_MODS
    #define ENABLE_RGB_MATRIX_BREATHING
    #define ENABLE_RGB_MATRIX_CYCLE_ALL
    #define ENABLE_RGB_MATRIX_CYCLE_LEFT_RIGHT
    #define ENABLE_RGB_MATRIX_RAINBOW_MOVING_CHEVRON

    // Efectos reactivos (responden al typing)
    #define ENABLE_RGB_MATRIX_SOLID_REACTIVE_SIMPLE
    #define ENABLE_RGB_MATRIX_TYPING_HEATMAP

    // Velocidad y pasos de ajuste
    #define RGB_MATRIX_DEFAULT_SPD 127
    #define RGB_MATRIX_HUE_STEP 8
    #define RGB_MATRIX_SAT_STEP 16
    #define RGB_MATRIX_VAL_STEP 16
    #define RGB_MATRIX_SPD_STEP 16
#endif

// Sincronización de WPM entre los dos lados del teclado dividido
#define SPLIT_WPM_ENABLE

// Sincronización del estado de LEDs (Caps Lock, Num Lock, etc.) entre ambos lados
#define SPLIT_LED_STATE_ENABLE

// Sincronización de estado de capas entre ambos lados del teclado dividido
#define SPLIT_LAYER_STATE_ENABLE


// Bootloader double-tap reset - ya configurado en el keyboard base
// #define RP2040_BOOTLOADER_DOUBLE_TAP_RESET // Activates the double-tap behavior
// #define RP2040_BOOTLOADER_DOUBLE_TAP_RESET_TIMEOUT 200U // Timeout window in ms in which the double tap can occur.
//#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET_LED 17 // Especifica el pin GPIO 17

// EEPROM size for user data (macros persistence)
// Size: 2 (magic) + 6 (lengths) + 768 (buffers) = 776 bytes
#define EECONFIG_USER_DATA_SIZE 776