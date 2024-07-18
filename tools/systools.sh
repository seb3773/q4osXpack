#!/bin/bash
centerk(){ ressc=$(xrandr | grep '*' | head -n 1 | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}
#----------------------------------------
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
kdicon="$(dirname "$script_directory")/common/Q4OSsebicon.png"
kdtitle="q4osXpack"
kdcaption="qsystools"
osarch=$(dpkg --print-architecture)
USER_HOME=$(eval echo ~${SUDO_USER})
USER_SU=$USER
source ../common/progress
script=" System tools  "
qprogress () {
dcop "$dcopRef" setProgress $2
}
#------------------


CLEANSYS () {
kdtext="<font style='color:#828282'>►</font> Proceed with cleaning ?<br>
<font style='color:#828282'><em>(or hit cancel to return to previous menu)</em></font>
"
kdialog --icon "$kdicon" --title "q4osXpack » qsystools" --caption "" --geometry $(centerk 450 350) --warningcontinuecancel "$kdtext"
if [ $? -eq 0 ]; then
tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Administrator rights needed"
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 300) --progressbar "Initializing ..." 100)
dfoutput1=$(df -h / | awk 'NR==2 {print "Disk space used:", $5, "- Free space available:", $4}')
echo "Cleaning packages..."
dcop "$dcopRef" setLabel "Cleaning packages..."
sudo apt-get -y autoclean
sudo apt-get -y clean
sudo apt autoremove -y --purge
qprogress "$script" 25
echo "Cleaning logs..."
dcop "$dcopRef" setLabel "Cleaning logs..."
sudo chmod +x tools/removelogs.sh
sudo tools/removelogs.sh
qprogress "$script" 50
echo "Removing unused kernel config files..."
dcop "$dcopRef" setLabel "Removing unused kernel config files..."
deborphan -n --find-config | xargs sudo apt autoremove -y --purge
qprogress "$script" 75
echo "Deleting thumbnails cache..."
dcop "$dcopRef" setLabel "Deleting thumbnails cache..."
for userdir in /home/*; do
if [ -d "$userdir/.cache/thumbnails" ]; then
echo " > deleting thumbnail cache for user: $userdir"
sudo rm -rf "$userdir/.cache/thumbnails/*"
fi
done
if [ -d "/root/.cache/thumbnails" ]; then
echo " > deleting thumbnail cache for root"
sudo rm -rf /root/.cache/thumbnails/*
fi
qprogress "$script" 100
sleep 1
dcop "$dcopRef" close
dfoutput2=$(df -h / | awk 'NR==2 {print "Disk space used:", $5, "- Free space available:", $4}')
echo Done.
kdialog --title "q4osXpack » qsystools " --icon "$kdicon" --msgbox "-Cleaning Completed:\n ■Before cleaning: $dfoutput1 \n ■After cleaning: $dfoutput2"
fi
}



KERNRV() {
while [ 1 ]; do
KERNLIST=$(dpkg --list | grep linux-image)
mapfile -t second_terms < <(echo "$KERNLIST" | awk '{print $2}')
options=()
curver=$(uname -r)
for term in "${second_terms[@]}"; do
if echo $term | grep -q $curver; then
tip=" [current kernel]"
else
tip=""
fi
options+=("$term" "$term$tip")
done
kdtext="$ktext
<font style='color:#828282'>►</font>Choose a kernel to remove:<br>
<font style='color:#828282'><em>(or hit cancel to return)</em></font><br>"
choice=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 300) --menu "$kdtext" "${options[@]}")
if [ $? -eq 1 ];then
return
else
case $choice in
*)
if echo $choice | grep -q $curver; then
kdialog --error "Can't remove kernel currently in use."
else
kdialog --yesno "Are you sure you want to remove $choice? This action cannot be undone."
if [ $? -eq 0 ]; then
tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Administrator rights needed"
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 300) --progressbar "Removing $choice ..." 100)
echo "Removing $choice"
sudo apt-get --purge -y remove $choice
qprogress "$script" 50
sudo update-grub
sudo sed -i 's/echo/#ech~o/g' /boot/grub/grub.cfg
qprogress "$script" 100
sleep 1
dcop "$dcopRef" close
kdialog --msgbox "Kernel $choice has been removed."
fi
fi
;;
esac
fi
done
}


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
kmenuitem+=" \"Recovtools\" \"» Install recovery tools      [ Install recovery tools  for system rescue ]\""
fi
kcmd+="$kmenuitem"
menuchoice=$(eval $kcmd)

if [ $? -eq 1 ];then
break
else
case "$menuchoice" in
Cleaning) CLEANSYS >> ../logs/qsystools.log ;;
KernelRmv) KERNRV >> ../logs/qsystools.log ;;
*) ;;
esac
fi


done


