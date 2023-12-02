#!/bin/bash
source common/resizecons
export NEWT_COLORS='
root=,brown
window=,lightgray
border=white,lightgray
textbox=white,blue
button=black,white
actbutton=black,white
title=black,lightgray
'
wmctrl -r :ACTIVE: -N "-=- Q4OS Seb Scripts -=-   qtools"
while [ 1 ]
do
ret=$(TERM=ansi whiptail --title "-=- Q4OS Seb Scripts -=-" --menu "                          Qtools Scripts" 25 70 15 "» Theme tools" " [            customizing theme             ]" "» Grub settings" " [          boot menu related tools         ]" "» Laptop" " [       laptop configuration settings      ]" "» Clean/optimize" " [  clean/optimize system & retrieve space  ]" "« exit" " [            <- quit this menu             ]" 3>&1 1>&2 2>&3)
echo
case $ret in
"» Theme tools")   
./tools/themetools
;;
"» Clean/optimize")   
./tools/cleantools
;;
"» Grub settings")   
./tools/grubtools
;;
"« exit") exit
;;
esac
done

