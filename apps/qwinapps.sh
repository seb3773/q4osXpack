#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
kdicon="$script_directory/../common/Q4OSsebicon.png"
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}
osarch=$(dpkg --print-architecture)

declare -a winappslist
if [ "$osarch" = "amd64" ]; then
winappslist+=("apps/winapps_photoshop.sh" "Photoshop CC 2020")
fi

winappslist+=("apps/winapps_office365.sh" "Office 365")

winappslist+=("Notepad++" "Notepad++")

winappslist+=("apps/winapps_riot.sh" "Riot images optimizer")

kdtitle="q4osXpack"
kdcaption="qapps"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qwapps() {
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack WinApps ⏺</strong></font><br><br>
<font style='color:#1a7c17'><em><strong>Windows applications</strong></em></font><br><br>
─────────────────────<br>
<font style='color:#828282'>►</font> Select a windows  app to install:<br>
<font style='color:#828282'><em>(or hit cancel to quit)</em></font><br>
"
kcmd="kdialog --icon \"$kdicon\" --title \"$kdtitle\" --caption \"$kdcaption\" --geometry $(centerk 350 450) --checklist \"$kdtext\" "
for ((i = 0; i < ${#winappslist[@]}; i+=2)); do
    kcmd+="\"${winappslist[i]}\" \"${winappslist[i+1]}\" off "
done
eval "$kcmd --separate-output"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $? -eq 1 ];then
echo "Canceled.";return 1
fi
}

App=$(qwapps)
if [ "$App" = "Canceled." ]; then echo "Canceled by user.";exit;fi
eval "$App"
exit


