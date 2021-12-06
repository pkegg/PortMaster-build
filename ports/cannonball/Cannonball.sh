#!/bin/bash

whichos=$(grep "title=" "/usr/share/plymouth/themes/text.plymouth")
if [[ $whichos == *"TheRA"* ]]; then
  raloc="/opt/retroarch/bin"
elif [[ -e "/storage/.config/.OS_ARCH" ]]; then
  raloc="/usr/bin"
else
  raloc="/usr/local/bin"
fi

if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
  GAMEDIR="/roms2/ports/cannonball"
else
  GAMEDIR="/roms/ports/cannonball"
fi

$raloc/retroarch -L $GAMEDIR/cannonball_libretro.so $GAMEDIR/gamedata/epr-10187.88
