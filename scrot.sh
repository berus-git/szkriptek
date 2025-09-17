#!/usr/bin/env bash
#
# Képernyőkép dátum szerinti könyvtárba.
#
# Eredeti ötlet: Dylan Araps.
# Módosítások: Berus.

# Alapértelmezett könyvtár
scr_dir="${HOME}/Képek/Képernyőképek"

# Változók beállítása
printf -v date "%(%F)T"
printf -v time "%(%I-%M-%S)T"

# Mentési könyvtár létrehozása
mkdir -p "${scr_dir}/${date}"

# Kép nevének beállítása
scr="${scr_dir}/${date}/${date}-${time}.jpg"

scrot "$scr"
notify-send -t 2500 "A képenyőkép elkészült ${scr/*\/}!"
