#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/$directory/ports/PortMaster"
fi

source $controlfolder/control.txt

get_controls

$ESUDO chmod 666 /dev/tty1

$ESUDO rm -rf ~/.CommanderGenius
ln -sfv /$directory/ports/cgenius/.CommanderGenius/ ~/
cd /$directory/ports/cgenius
$ESUDO ./oga_controls CGeniusExe $param_device &
./CGeniusExe
$ESUDO kill -9 $(pidof oga_controls)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
fi