BOARD = GENERIC_RP_RP2040
BOOTLOADER = rp2040


# Usar RGB_MATRIX (efectos avanzados y control individual de LEDs)
RGBLIGHT_ENABLE = no
RGB_MATRIX_ENABLE = yes

# Necesario para RP2040
WS2812_DRIVER = vendor


MOUSEKEY_ENABLE		= no
NKRO_ENABLE			= yes
OLED_DRIVER_ENABLE	= yes
EXTRAKEY_ENABLE		= yes
TAP_DANCE_ENABLE	= no
LTO_ENABLE			= yes

OLED_ENABLE = yes # Enable OLEDs
WPM_ENABLE = yes  # Enable WPM for demon animation
DYNAMIC_MACRO_ENABLE = yes  # Enable dynamic macro recording
DEFERRED_EXEC_ENABLE = yes  # Enable deferred execution for double-tap detection