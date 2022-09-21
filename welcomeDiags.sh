#!/bin/bash

# © Romain Dudek 2022
# This script is making a serie of diags on the distant server
# in order to prompt it on ssh login.

CYAN='\033[0;36m'
NC='\033[0m'

upfrom=$(uptime -p)


totalDiskSpace=$(df -h /dev/mapper/vg00-var | grep /dev/ | awk '{print $2}')
rawFreeDiskSpace=$(df /dev/mapper/vg00-var | grep /dev/ | awk '{print $4/$2 *100}')
freeDiskSpace=${rawFreeDiskSpace%.*}


totalMemory=$(free -m | grep Mem | awk '{print $2}')
cachedRam=$(free -m | grep Mem | awk '{print $6}')
swapTotal=$(free -m | grep Swap | awk '{print $2}')
rawSwapFree=$(free -m | grep Swap | awk '{print $4/$2 *100}')
rawFreeMemory=$(free -m | grep Mem | awk '{print $4/$2 *100}')
freeMemory=${rawFreeMemory%.*}
[[ "$rawSwapFree" =~ ([0-9])+.?\w ]] && freeSwap=${rawSwapFree%.*} || freeSwap=''

ipAddr=$(hostname -I)
[ -f "/sys/class/thermal/thermal_zone0/temp" ] && procTemp=$(cat /sys/class/thermal/thermal_zone0/temp | awk '{ print $1/1000}')
[ -f "/sys/class/thermal/thermal_zone1/temp" ] && ramTemp=$(cat /sys/class/thermal/thermal_zone1/temp | awk '{ print $1/1000}')

[ ! -z "$freeDiskSpace" ] && printf "${CYAN}Disk space :${NC} ${freeDiskSpace}%% free over ${totalDiskSpace}              "
[ ! -z "$upfrom" ] && printf "${CYAN}Up time :${NC}  ${upfrom}\n"
[ ! -z "$freeMemory" ] && printf "${CYAN}RAM :${NC} ${freeMemory}%% free over ${totalMemory}Mb, ${cachedRam}Mb in cache      "
[ ! -z "$freeSwap" ] && printf "${CYAN}Swap :${NC} ${freeSwap}%% free over ${swapTotal}Mb\n"
[ ! -z "$procTemp" ] && printf "${CYAN}Proc temp :${NC} ${procTemp}°C      ${CYAN}RAM temp :${NC} ${ramTemp}°C       "
[ ! -z "$ipAddr" ] && printf "${CYAN}Ip adrr :${NC} ${ipAddr}\n"
