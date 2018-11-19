# Description

Locked Launcher is a simple launch wrapper with block input feature. Thought for game emulator frontends, it will launch a process while blocking inputs from mouse and keyboard.

Unwanted inputs sent during launch phase may prevent target emulator to show properly.
Inspired by the same feature found in [Big Blue Frontend](https://sites.google.com/site/bigbluefrontend/features), I decided to write a wrapper that can be used by any frontend.

#### Currently supports the following OS
* Windows, any version supported by [Autoit](https://www.autoitscript.com/site/)

#### Currently supports the following frontends
* Any frontend that is able to launch game by configurable commands and arguments

### Prerequisites
Input block feature requires admin rights, but frontends tipically run with elevated permissions. To run elevated frontend bypassing UAC you may disable it, but I prefer bypassing UAC with the "On demand scheduled task technique".

## Features
* Blocks inputs with configurable unlock mode
* Prevents unwanted concurrent launch (system wide singleton)

## Usage
Download [latest release](https://github.com/matteocedroni/locked-launcher/releases/latest) and put exe and ini in file the same folder.
Modify game launch configuration in order to invoke lockedLauncher instead the current launcher.

Example based on [Attract-Mode](http://attractmode.org/) frontend configuration:

without lockedLauncher
```
...
executable           C:\Games\RocketLauncher\RocketLauncher.exe
args                 -s "SNK Neo Geo MVS" -r "[romfilename]" -p AttractMode -f "C:\Games\attract-v2.4.1-win64\attract.exe"
...
```

with lockedLauncher
```
...
executable           C:\Games\lockedLauncher.exe
args                 C:\Games\RocketLauncher\RocketLauncher.exe -s "SNK Neo Geo MVS" -r "[romfilename]" -p AttractMode -f "C:\Games\attract-v2.4.1-win64\attract.exe"
...
```

## Configuration

Unlock behavior can be tuned by .ini file parameters
#### Fixed delay unlock mode
```
unlockAfter
```
Inputs will be re-enabled after `unlockAfter` seconds from launch

#### Target window unlock mode
```
unlockOnWindow
unlockOnWindowTimeout
unlockOnWindowDelay
```
Inputs will be re-enabled `unlockOnWindowDelay` seconds after `unlockOnWindow` become active. In any case inputs will be re-enabled after `unlockOnWindowTimeout` seconds from launch.
`unlockOnWindow` can be filled with [Autoit expressions](https://www.autoitscript.com/autoit3/docs/intro/windowsadvanced.htm)

#### Audible lock status change
```
audibleLockStatusChange
```
For testing purpose lock boundaries can be demarcated with audible beep