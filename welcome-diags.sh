#!/bin/bash

# © Romain Dudek 2022
# This script is making a serie of diags on the distant server
# in order to prompt it on ssh login.

CYAN='\033[0;36m'
NC='\033[0m'

upfrom=$(uptime -p)


totalDiskSpace=$(df -h / | grep /dev/ | awk '{print $2}')
rawFreeDiskSpace=$(df / | grep /dev/ | awk '{print $4/$2 *100}')
freeDiskSpace=${rawFreeDiskSpace%.*}


totalMemory=$(free -m | grep Mem | awk '{print $2}')
cachedRam=$(free -m | grep Mem | awk '{print $6}')
swapTotal=$(free -m | grep Swap | awk '{print $2}')
rawSwapFree=$(free -m | grep Swap | awk '{print $4/$2 *100}')
rawFreeMemory=$(free -m | grep Mem | awk '{print $4/$2 *100}')
freeMemory=${rawFreeMemory%.*}
freeWsap=${rawSwapFree%.*}


printf "${CYAN}Disk space :${NC} ${freeDiskSpace}%% free over ${totalDiskSpace}                ${CYAN}Up time :${NC}  ${upfrom}\n"
printf "${CYAN}Ram :${NC} ${freeMemory}%% free over ${totalMemory}Mb, ${cachedRam}Mb in cache      ${CYAN}Swap :${NC} ${freeWsap}%% free over ${swapTotal}Mb"