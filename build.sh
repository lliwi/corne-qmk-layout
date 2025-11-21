#!/bin/bash
# Script de compilación para el keymap lliwi - Corne rev4_1

# Colores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔨 Compilando firmware para Corne rev4_1...${NC}"

# Ir al directorio raíz de QMK
cd /home/llibert/qmk_firmware

# Limpiar compilación anterior si se pasa el argumento 'clean'
if [ "$1" == "clean" ]; then
    echo -e "${YELLOW}🧹 Limpiando archivos de compilación anterior...${NC}"
    qmk clean
fi

# Compilar el firmware
echo -e "${YELLOW}⚙️  Compilando...${NC}"
if qmk compile -kb crkbd/rev4_1/standard -km lliwi; then
    echo -e "${GREEN}✅ Compilación exitosa!${NC}"
    echo -e "${GREEN}📦 Archivo generado: crkbd_rev4_1_standard_lliwi.uf2${NC}"

    # Mostrar tamaño del archivo
    SIZE=$(ls -lh crkbd_rev4_1_standard_lliwi.uf2 | awk '{print $5}')
    echo -e "${GREEN}📊 Tamaño: ${SIZE}${NC}"

    # Si se pasa el argumento 'flash', flashear directamente
    if [ "$1" == "flash" ] || [ "$2" == "flash" ]; then
        echo -e "${YELLOW}🔌 Flasheando al teclado...${NC}"
        echo -e "${YELLOW}   Entra en modo bootloader (doble tap en reset)${NC}"
        qmk flash -kb crkbd/rev4_1/standard -km lliwi
    else
        echo -e "${YELLOW}💡 Para flashear, ejecuta:${NC}"
        echo -e "   ${GREEN}./build.sh flash${NC}"
        echo -e "${YELLOW}   o manualmente copia el .uf2 al teclado en modo bootloader${NC}"
    fi
else
    echo -e "${RED}❌ Error en la compilación${NC}"
    exit 1
fi
