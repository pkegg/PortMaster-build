# Summary
The `global` package is a library which is intended to be included into every port by default.  As such, it needs to be small and well tested. Below, the included files are documented.

# global-functions
**tl;dr**: Add the following to your `run` script and then you can use all functions in global-functions.
```
DIR="$(realpath $( dirname "${BASH_SOURCE[0]}" ))"
source $DIR/global-functions
```

## Overview

Global functions encapsulates functionality needed by most ports to simplify their run scripts.  Functions are designed to do one thing and not add global variables. Ex: `os=$(get_os)`.  Here - the stdout output of a function is assigned to the `os` variable.  

This approach ensures that functions are small and testable and do not leak global variables (global variable conflicts are confusing and time consuming to debug).  If the function needs to output additional debugging messages, it can output to stderr without disrupting the stdout output. The `echo_err` function is provided for this purpose.

### DIR - The directory of the current script

In general, a lot of complexity in port scripts comes from figuring out what directory the script is actually in.  In order to `source` global-functions, you need to know this directory.

The recommended approach is to use the above `DIR=$(realpath...)` function to find the current directory of the script.  This also allows for testing in other directories, etc.

It is also possible to source global functions in a way that works both in the package and in the `/ports/<port>` directory.  This is not always required, but helpful for things like PortMaster to be able to run directly from `/ports/portmaster/run` for testing purposes.  Do that like this:

```
DIR="$(realpath $( dirname "${BASH_SOURCE[0]}" ))"
if [ -f "${DIR}/global-functions" ]; then
  source "${DIR}/global-functions"
elif [ -f "${DIR}/../global/global-functions" ]; then
  source "${DIR}/../global/global-functions"
fi
```

## Important functions
Functions are designed to be called like: `os=$(get_os)` unless otherwise noted.

- `get_os` - gets the current OS. 
  - **Values**: 351ELEC, ArkOS, TheRA, RetroOZ, ubuntu (for testing), mac (for testing)

- `get_device` - gets the current device.  It *should* work w/o knowing the OS.
  - NOTE: That this identifies the specific device and is not fully compatible with `oga_controls` (see: get_oga_device). 
  - **Values**: rg351p, rg351v, rg351mp, oga (Odroid Go Advance), ogs (Odroid Go Super / PowKiddy RGB10Max), rk2020, chi (GameForce Chi)

- `get_oga_device` - gets the device which can be used with `oga_controls`.  This typically maps to the controller rather than the device, so some things may appear a bit strange (ogs is returned for RG351MP, Odroid GO Super and RGB10 Max because they have the same controller).
  - **Values**: anbernic (RG351P/RG351V), chi, oga, ogs (RG351MP), rk2020

- `get_sdl_controls` - Gets the string for SDL controls. Suggested use (variable name is important due to autodetection by SDL games).  Ex: `SDL_GAMECONTROLLERCONFIG="$(get_sdl_controls)"`

- `get_sudo` - A variable which will have `sudo` if sudo should be used and `""` (nothing) if not.  This is based off of OS.
  - ex: `ESUDO=$(get_sudo)`

- `get_num_analog_sticks` - Indicates the number of analog sticks on a device.

- `is_low_res` - Indicates devices which have 320x240 resolution (RG351P/M, OdroidGoAdvance, rk2020)

- `run_at_exit` - Allows running a function at exit (cleanup, etc).  For example, if you want to run a function `cleanup` when the script exits: `run_at_exit cleanup`.  Internally this uses bash `traps`, but is smart enough so you can call `run_at_exit` multiple times and all functions will be run.
  - IMPORTANT NOTE: If a bash `trap` is set for `EXIT` after `run_at_exit` is called, it will break any `run_at_exit` functionality.

- `initialize_permissions` - Does basic permissions checks/updates (`chmod 666 /dev/tty1`) and makes directories if they don't exist.

 
## Running tests
Tests will be done automatically when running `./build global`.  However, you can also run the tests with `bash ./ports/global/test`.  In order to run the tests manually, you must have `bats` installed.
