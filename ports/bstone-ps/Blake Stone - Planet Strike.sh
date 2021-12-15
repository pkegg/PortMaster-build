#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

GAMEDIR=$directory/ports/bstone-ps

GPTOKEYB_CONFIG="bstone.gptk"

if [[ $LOWRES == 'Y' ]]; then
    $ESUDO sed -i '/vid_width / s/"640"/"480"/' /$GAMEDIR/conf/bibendovsky/bstone_config.txt
    $ESUDO sed -i '/vid_height / s/"480"/"320"/' /$GAMEDIR/conf/bibendovsky/bstone_config.txt
else
    $ESUDO sed -i '/vid_width / s/"480"/"640"/' /$GAMEDIR/conf/bibendovsky/bstone_config.txt
    $ESUDO sed -i '/vid_height / s/"320"/"480"/' /$GAMEDIR/conf/bibendovsky/bstone_config.txt
fi

if [[ $ANALOGSTICKS == '1' ]]; then
    GPTOKEYB_CONFIG="bstone.gptk.leftanalog"  
fi

cd /$GAMEDIR

$ESUDO rm -rf ~/.local/share/bibendovsky
ln -sfv /$GAMEDIR/conf/bibendovsky ~/.local/share/

$ESUDO chmod 666 /dev/uinput
$GPTOKEYB "bstone" -c "./$GPTOKEYB_CONFIG" &
LD_LIBRARY_PATH="$PWD/libs" SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig" ./bstone --data_dir gamedata/planet_strike  2>&1 | tee -a ./log.txt
$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
