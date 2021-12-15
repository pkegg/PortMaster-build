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

cd /$directory/ports/blobbyvolley2

$ESUDO rm -rf ~/.blobby
ln -sfv /$directory/ports/blobbyvolley2/conf/.blobby ~/

$ESUDO chmod 666 /dev/uinput
$GPTOKEYB "blobby" -c "./blobby.gptk.$ANALOGSTICKS" &
LD_LIBRARY_PATH="$PWD/libs" SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig" ./blobby 2>&1 | tee -a ./log.txt
$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
