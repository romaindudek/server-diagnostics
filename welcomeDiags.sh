#!/bin/bash

# © Romain Dudek 2022
# This script is making a serie of diags on the distant server
# in order to prompt it on ssh login.

CYAN='\033[0;36m'
NC='\033[0m'

PrintDiag () {
    if [ "nl" = "$3" ]; then
        [ -n "$2" ] && printf "${CYAN}%-10s : ${NC}%s\n" "${1}" "${2}"
    else
        [ -n "$2" ] && printf "${CYAN}%-10s : ${NC}%-40s" "${1}" "${2}"
    fi
}

upfrom=$(uptime -p)

totalDiskSpace=$(df -h /dev/mapper/vg00-var | grep /dev/ | awk '{print $2}')
rawFreeDiskSpace=$(df /dev/mapper/vg00-var | grep /dev/ | awk '{print $4/$2 *100}')
[ "$rawFreeDiskSpace" != "inf" ] && freeDiskSpace=${rawFreeDiskSpace%.*} || freeDiskSpace='100'

totalDiskSpace=$(df -h / | grep /dev/ | awk '{print $2}')
rawFreeDiskSpace=$(df / | grep /dev/ | awk '{print $4/$2 *100}')
freeDiskSpace=${rawFreeDiskSpace%.*}


totalMemory=$(free -m | grep Mem | awk '{print $2}')
cachedRam=$(free -m | grep Mem | awk '{print $6}')
swapTotal=$(free -m | grep Swap | awk '{print $2}')
rawSwapFree=$(free -m | grep Swap | awk '{print $4/$2 *100}')
rawFreeMemory=$(free -m | grep Mem | awk '{print $4/$2 *100}')
[ "$rawFreeMemory" != "inf" ] && freeMemory=${rawFreeMemory%.*} || freeMemory='100'
freeMemory=${rawFreeMemory%.*}
[ "$rawSwapFree" != "inf" ] && freeSwap=${rawSwapFree%.*} || freeSwap='100'

ipAddr=$(hostname -I)
[ -f "/sys/class/thermal/thermal_zone0/temp" ] && procTemp=$( awk '{ print $1/1000}' < /sys/class/thermal/thermal_zone0/temp)
[ -f "/sys/class/thermal/thermal_zone1/temp" ] && ramTemp=$( awk '{ print $1/1000}' < /sys/class/thermal/thermal_zone1/temp)

PrintDiag "Disk space" "${freeDiskSpace}% free over ${totalDiskSpace}"
PrintDiag "Up time" "${upfrom}" "nl"
PrintDiag "RAM" "${freeMemory}% free over ${totalMemory}Mb, ${cachedRam}Mb in cache"
PrintDiag "Swap" "${freeSwap}% free over ${swapTotal}Mb" "nl"
PrintDiag "Proc temp" "${procTemp}°C"
PrintDiag " RAM temp" "${ramTemp}°C" "nl"
PrintDiag "Ip adrr" "${ipAddr}" "nl"


