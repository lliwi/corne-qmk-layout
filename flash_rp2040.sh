#!/bin/bash
# Script para flashear RP2040 en Arch Linux
# Uso: ./flash_rp2040.sh

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

FIRMWARE_DIR="/home/llibert/qmk_firmware"
FIRMWARE_FILE="crkbd_rev1_lliwi_helios.uf2"
MOUNT_POINT="/mnt/rpi-rp2"
DEVICE_NAME="RPI-RP2"

echo -e "${YELLOW}🔨 Compilando firmware con CONVERT_TO=helios...${NC}"
cd "$FIRMWARE_DIR"

if qmk compile -kb crkbd -km lliwi -e CONVERT_TO=helios; then
    echo -e "${GREEN}✅ Compilación exitosa${NC}\n"
else
    echo -e "${RED}❌ Error en la compilación${NC}"
    exit 1
fi

# Verificar que el archivo existe
if [ ! -f "$FIRMWARE_DIR/$FIRMWARE_FILE" ]; then
    echo -e "${RED}❌ No se encontró el archivo $FIRMWARE_FILE${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Firmware listo: $FIRMWARE_FILE${NC}"
echo -e "${YELLOW}⚡ Esperando teclado en modo bootloader...${NC}"
echo -e "${YELLOW}   👉 Para Helios: mantén el botón RESET presionado >500ms${NC}\n"

# Esperar a que aparezca el dispositivo (timeout 60 segundos)
TIMEOUT=60
ELAPSED=0
DEVICE=""

while [ -z "$DEVICE" ]; do
    # Buscar dispositivo con label RPI-RP2
    # Eliminar caracteres de formato de árbol (└─, ├─, etc)
    DEVICE=$(lsblk -o NAME,LABEL -n | grep "$DEVICE_NAME" | awk '{print $1}' | sed 's/[^a-zA-Z0-9]//g' | head -1)

    if [ -n "$DEVICE" ]; then
        DEVICE="/dev/$DEVICE"
        break
    fi

    sleep 0.5
    ELAPSED=$((ELAPSED + 1))

    if [ $ELAPSED -gt $((TIMEOUT * 2)) ]; then
        echo -e "${RED}❌ Timeout: No se detectó el teclado en modo bootloader${NC}"
        echo -e "${YELLOW}   Verifica que:${NC}"
        echo -e "${YELLOW}   - El cable USB funciona${NC}"
        echo -e "${YELLOW}   - Mantuviste presionado reset >500ms (Helios)${NC}"
        echo -e "${YELLOW}   - El teclado está en modo bootloader${NC}"
        exit 1
    fi

    # Mostrar progreso cada 2 segundos
    if [ $((ELAPSED % 4)) -eq 0 ]; then
        echo -e "${YELLOW}   ⏳ Esperando... (${ELAPSED}/$(($TIMEOUT * 2)) intentos)${NC}"
    fi
done

echo -e "${GREEN}✅ Teclado detectado: $DEVICE${NC}"

# Crear punto de montaje si no existe y montar
echo -e "${YELLOW}🔄 Montando dispositivo...${NC}"
sudo mkdir -p "$MOUNT_POINT"
if sudo mount "$DEVICE" "$MOUNT_POINT"; then
    echo -e "${GREEN}✅ Montado en: $MOUNT_POINT${NC}"
else
    echo -e "${RED}❌ Error al montar el dispositivo${NC}"
    exit 1
fi

echo -e "${YELLOW}🔄 Flasheando firmware...${NC}"

# Copiar firmware
if sudo cp "$FIRMWARE_DIR/$FIRMWARE_FILE" "$MOUNT_POINT/"; then
    echo -e "${GREEN}✅ Firmware copiado exitosamente${NC}"
    echo -e "${GREEN}🎉 ¡Listo! El teclado se reiniciará automáticamente${NC}\n"

    # Info adicional
    echo -e "${YELLOW}📊 Información del firmware:${NC}"
    ls -lh "$FIRMWARE_DIR/$FIRMWARE_FILE" | awk '{print "   Tamaño: " $5}'
    echo -e "${YELLOW}   Ubicación: $FIRMWARE_DIR/$FIRMWARE_FILE${NC}\n"


    # Desmontar
    sleep 1
    sudo umount "$MOUNT_POINT"
    echo -e "${GREEN}✅ Dispositivo desmontado${NC}"
else
    echo -e "${RED}❌ Error al copiar el firmware${NC}"
    sudo umount "$MOUNT_POINT" 2>/dev/null || true
    echo -e "${YELLOW}   Intenta copiar manualmente:${NC}"
    echo -e "${YELLOW}   sudo mount /dev/sda1 /mnt/rpi-rp2${NC}"
    echo -e "${YELLOW}   sudo cp $FIRMWARE_DIR/$FIRMWARE_FILE /mnt/rpi-rp2/${NC}"
    echo -e "${YELLOW}   sudo umount /mnt/rpi-rp2${NC}"
    exit 1
fi
