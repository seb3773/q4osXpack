#!/bin/bash
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}
#----------------------------------------
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
kdicon="$(dirname "$script_directory")/common/Q4OSsebicon.png"
osarch=$(dpkg --print-architecture)
USER_HOME=$(eval echo ~${SUDO_USER})
USER_SU=$USER
#------------------
echo $script_directory/common/Q4OSsebicon.png





#############################################################################################################
###################################################" MAIN MENU ##############################################
ktext="<font style='color:#ac6009'><strong>⏺ q4osXpack ⏺</strong></font><br><br>"
kdtitle="q4osXpack "
kdcaption="system tools"
if [ "$EUID" -eq 0 ]
then
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --error "This script must not be run as root. Please run it as normal user, elevated rights will be asked when needed. "
exit
fi

while true; do
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="$ktext
<font style='color:#828282'>►</font> Choose a script to launch:<br>
<font style='color:#828282'><em>(or hit cancel to quit)</em></font><br>"
kcmd="kdialog --icon \"$kdicon\" --title \"$kdtitle\" --caption \"$kdcaption\" --geometry $(centerk 520 500) --menu \"$kdtext\" "
kmenuitem=""
kmenuitem+="\"Cleaning\" \"» Cleaning      [ script to clean system ]\""
kmenuitem+=" \"KernelRmv\" \"» Kernel remove      [ remove unused kernels ]\""
kmenuitem+=" \"TrimSSD\" \"» Trim SSD      [ erase data blocks no longer in use ]\""
kmenuitem+=" \"Rmvlocal\" \"» Remove localisations      [ remove unused localisation files ]\""
kmenuitem+=" \"Rmvicons\" \"» Remove icons      [ remove unused icons ]\""
kmenuitem+=" \"Rmvfonts\" \"» Remove fonts      [ remove some non western fonts ]\""
if [ ! "$osarch" = "armhf" ]; then
kmenuitem+=" \"BootM\" \"» Boot Menu      [ enable/disable boot menu ]\""
kmenuitem+=" \"Btimeout\" \"» Boot Menu timeout      [ set boot menu timeout ]\""
kmenuitem+=" \"Boses\" \"» Boot menu other OS      [ Enable/disable other OS choice ]\""
kmenuitem+=" \"Buefi\" \"» Boot menu UEFI      [ Enable/disable UEFI option ]\""
fi
kmenuitem+=" \"Bcmdl\" \"» Boot command line      [ Modify boot command line ]\""
if [ ! "$osarch" = "armhf" ]; then
kmenuitem+=" \"Grubzil\" \"» Clonezilla grub entry      [ Add Clonezilla live to grub menu ]\""
fi
kcmd+="$kmenuitem"
menuchoice=$(eval $kcmd)

if [ $? -eq 1 ];then
break
else
case "$menuchoice" in
Cleaning) CLEANSYS;;
*) ;;
esac
fi


done


