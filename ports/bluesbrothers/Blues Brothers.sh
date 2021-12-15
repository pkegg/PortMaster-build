#!/bin/bash

ESUDO="sudo"
if [ -f "/storage/.config/.OS_ARCH" ]; then
  ESUDO=""
  export LD_LIBRARY_PATH=/usr/lib:/roms/ports/bluesbrothers/libs
fi

if [[ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]]; then
  sdl_controllerconfig="03000000091200000031000011010000,OpenSimHardware OSH PB Controller,a:b0,b:b1,x:b2,y:b3,leftshoulder:b4,rightshoulder:b5,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,leftx:a0~,lefty:a1~,guide:b12,leftstick:b8,lefttrigger:b10,rightstick:b9,back:b7,start:b6,rightx:a2,righty:a3,righttrigger:b11,platform:Linux,"
  param_device="anbernic"
elif [[ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    if [[ ! -z $(cat /etc/emulationstation/es_input.cfg | grep "190000004b4800000010000001010000") ]]; then
      sdl_controllerconfig="190000004b4800000010000001010000,GO-Advance Gamepad (rev 1.1),a:b1,b:b0,x:b2,y:b3,leftshoulder:b4,rightshoulder:b5,dpdown:b9,dpleft:b10,dpright:b11,dpup:b8,leftx:a0,lefty:a1,guide:b12,leftstick:b14,lefttrigger:b13,rightstick:b15,righttrigger:b16,start:b17,platform:Linux,"
	  param_device="oga"
	else
	  sdl_controllerconfig="190000004b4800000010000000010000,GO-Advance Gamepad,a:b1,b:b0,x:b2,y:b3,leftshoulder:b4,rightshoulder:b5,dpdown:b7,dpleft:b8,dpright:b9,dpup:b6,leftx:a0,lefty:a1,guide:b10,leftstick:b12,lefttrigger:b11,rightstick:b13,righttrigger:b14,start:b15,platform:Linux,"
	  param_device="rk2020"
	fi
elif [[ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]]; then
  sdl_controllerconfig="190000004b4800000011000000010000,GO-Super Gamepad,platform:Linux,x:b2,a:b1,b:b0,y:b3,back:b12,guide:b16,start:b13,dpleft:b10,dpdown:b9,dpright:b11,dpup:b8,leftshoulder:b4,lefttrigger:b6,rightshoulder:b5,righttrigger:b7,leftstick:b14,rightstick:b17,leftx:a0,lefty:a1,rightx:a2,righty:a3,platform:Linux,"
  param_device="ogs"
else
  sdl_controllerconfig="19000000030000000300000002030000,gameforce_gamepad,leftstick:b14,rightx:a3,leftshoulder:b4,start:b9,lefty:a0,dpup:b10,righty:a2,a:b1,b:b0,guide:b16,dpdown:b11,rightshoulder:b5,righttrigger:b7,rightstick:b15,dpright:b13,x:b2,back:b8,leftx:a1,y:b3,dpleft:b12,lefttrigger:b6,platform:Linux,"
  param_device="chi"
fi

if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ]; then
  cd /roms2/ports/bluesbrothers/
  $ESUDO ./oga_controls blues $param_device &
  SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig" ./blues --fullscreen --filter=nearest --datapath="/roms2/ports/bluesbrothers/gamedata" 2>&1 | tee -a ./log.txt
  $ESUDO kill -9 $(pidof oga_controls)
  $ESUDO systemctl restart oga_events &
  printf "\033c" > /dev/tty1
else
  cd /roms/ports/bluesbrothers/
  $ESUDO ./oga_controls blues $param_device &
  SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig" ./blues --fullscreen --filter=nearest --datapath="/roms/ports/bluesbrothers/gamedata" 2>&1 | tee -a ./log.txt
  $ESUDO kill -9 $(pidof oga_controls)
  $ESUDO systemctl restart oga_events &
  printf "\033c" > /dev/tty1
fi