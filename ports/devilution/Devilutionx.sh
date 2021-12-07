#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

get_controls

cd /$directory/ports/devilution


export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib32"
cd /$directory/ports/devilution
./devilutionx --config-dir /$directory/ports/devilution --data-dir /$directory/ports/devilution --save-dir /$directory/ports/devilution
unset SDL_GAMECONTROLLERCONFIG
printf "\033c" >> /dev/tty1
