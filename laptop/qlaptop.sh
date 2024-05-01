#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ conf file exist ?
if [ -e "common/conf.qlaptop.tmp" ]; then
rel_path="common/conf.qlaptop.tmp"
abs_path=$(realpath "$rel_path")
conffile=1
kdicon="$script_directory/../common/Q4OSsebicon.png" 
dcopRef=$(sudo kreadconfig --file "$abs_path" --group "Settings" --key "progressref")
insttlpui=$(sudo kreadconfig --file "$abs_path" --group "Settings" --key "insttlpui")
insthiber=$(sudo kreadconfig --file "$abs_path" --group "Settings" --key "insthiber")
helpdoc=0
sudo rm -f "$abs_path"
else
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ conf file exist end
helpdoc=0
VALID_ARGS=$(getopt -o h --long help -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -h | --help)
        helpdoc=1
        shift
        ;;
     --) shift; 
        break 
        ;;
  esac
done
if [ $helpdoc -eq 1 ]; then
script="Help Qlaptop"
else
script="  Qlaptop script  "
fi
source common/resizecons
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ conf file don't exist end
source common/begin
source common/progress
if [[ $conffile -eq 1 ]]; then
begin "$script" "conf" "$dcopRef"
qprogress () {
dcop "$dcopRef" setProgress $2
}
else
begin "$script"
qprogress () {
progress "$1" "$2"
}
fi
#================================================================================================================



#========== set subscripts perms ================================================================================
qprogress "$script" 0
sudo chmod +x laptop/tlpui_setup.sh


qprogress "$script" 5
#========== CREATE BACKUP FOLDER & backup files to be modified ==================================================
create_backup() {
    local backup_path="backups/$now/$1.tar.gz"
    sudo tar -zcvf "$backup_path" "$2" > /dev/null 2>&1
    rota
}


osarch=$(dpkg --print-architecture)
if [ ! "$osarch" = "armhf" ]; then

if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Backup...";fi
echo -e "${RED}░░▒▒▓▓██\033[0m Backup...${NOCOLOR}"
now=$(date +"%Y-%m-%d_%I-%M%p")
sudo mkdir -p "backups/$now" > /dev/null 2>&1
create_backup "60-libinput.conf" "/etc/X11/xorg.conf.d/60-libinput.conf"
create_backup "logind.conf" "/etc/systemd/logind.conf"
create_backup "grub" "/etc/default/grub"
create_backup "sleep.conf" "/etc/systemd/sleep.conf"
create_backup "systemd-suspend.service" "/lib/systemd/system/systemd-suspend.service"
create_backup "logind" "/etc/systemd/logind.conf"
create_backup "systemd-suspend" "/lib/systemd/system/systemd-suspend.service"
sudo \cp common/restore "backups/restore_$now"
sudo sed -i "s/XxXxXxXxX/$now/g" "backups/restore_$now"
sudo sed -i "s/YyYyYyYyY/Restoring backup created by qlaptop script/g" "backups/restore_$now"
sudo chmod +x "backups/restore_$now"
rota
echo
printf '\e[A\e[K'
echo
echo

qprogress "$script" 10


itemdisp "Fetching latest version of the package list..."

if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Fetching latest version of the package list..."

konsole --nomenubar --nohist --notabbar --noframe --noscrollbar --vt_sz 56x24 -e common/apt_update.sh "$dcopRef" "laptop" -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount)
done
dcop $kid konsole-mainwindow#1 move 5 5
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount)
done

else

sudo apt update > /dev/null 2>&1
aptup=1
for (( i=5; i>0; i--)); do
printf "\rRunning apt upgrade in $i seconds.  Hit any key to cancel..."
read -s -n 1 -t 1 key
if [ $? -eq 0 ];then aptup=0;break;fi;done
if [[ $aptup -eq 1 ]];then echo;echo "processing..."
sudo dpkg --configure -a
sudo apt upgrade -y
else echo;echo "canceled.";fi

fi

sep
echo
echo
echo

qprogress "$script" 15

#========== Touchpad config =====================================================================================
# I want two fingers scroll !!
# I dislike the pad middle click, it's annoying on large pads
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Configuring touchpad...";fi
itemdisp "Configuring touchpad..."
echo
echo -e "  \e[35m░▒▓█\033[0m Enabling two fingers scrolling & disabling middle click..."
if ! grep 'Option "ScrollMethod"' /etc/X11/xorg.conf.d/60-libinput.conf|grep -q 'two finger'; then
if ! grep -q 'Option "TapButton3"' /etc/X11/xorg.conf.d/60-libinput.conf; then
sudo sed -i '/Option "ScrollMethod"/c\        Option "ScrollMethod" "two-finger"\n        Option "TapButton3" "2"' /etc/X11/xorg.conf.d/60-libinput.conf
else
sudo sed -i '/Option "ScrollMethod"/c\        Option "ScrollMethod" "two-finger"' /etc/X11/xorg.conf.d/60-libinput.conf
sudo sed -i '/Option "TapButton3"/c\        Option "TapButton3" "2"' /etc/X11/xorg.conf.d/60-libinput.conf
fi
else
if ! grep 'Option "TapButton3"' /etc/X11/xorg.conf.d/60-libinput.conf; then
sudo sed -i '/Option "ScrollMethod"/c\        Option "ScrollMethod" "two-finger"\n        Option "TapButton3" "2"' /etc/X11/xorg.conf.d/60-libinput.conf
else
sudo sed -i '/Option "TapButton3"/c\        Option "TapButton3" "2"' /etc/X11/xorg.conf.d/60-libinput.conf
fi
fi
sep
echo
echo
echo
qprogress "$script" 20



#========== Touchpad config =====================================================================================
#too much crash with TDEpowersave on some laptops...
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Removing TDE powersave...";fi
itemdisp "Removing TDE powersave..."
echo
sudo apt remove -y tdepowersave-trinity
sep
echo
echo
echo
qprogress "$script" 30




#========== Uninstall powertop ==================================================================================
#avoid conflicts with TLP
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Removing powertop...";fi
itemdisp "Removing powertop..."
echo
sudo apt remove -y powertop
sep
echo
echo
echo
qprogress "$script" 40



#========== Install TLP =========================================================================================
#fine battery saver :)
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing TLP..."
sudo apt install -y tlp tlp-rdw
qprogress "$script" 45
sudo tlp start

#if selected
if [[ $insttlpui -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing TLP ui..."
cd laptop

konsole --nomenubar --nohist --notabbar --noframe --noscrollbar --vt_sz 56x24 -e ./tlpui_setup.sh "yes" -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount)
done
dcop $kid konsole-mainwindow#1 move 5 5
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount)
done
kdialog --icon "$kdicon"  --msgbox "TLPUI will open now, you can just close the windows \n to accept standard settings or edit them"  --caption "qlaptop" --title "q4osXpack"
tlpui > /dev/null 2>&1
cd ..
#endif selected
fi
else

itemdisp "Installing TLP + TLP gui..."
echo
echo -e "  \e[35m░▒▓█\033[0m Installing TLP..."
echo -e "${YELLOW}"
sudo apt install -y tlp tlp-rdw
echo -e "${NOCOLOR}"
qprogress "$script" 50
sudo tlp start     
cd laptop
./tlpui_setup.sh
cd ..
echo
sep
echo
echo
echo

fi

qprogress "$script" 55



#========== xfce4 power manager =================================================================================
itemdisp "Installing xfce4 power manager..."
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing xfce4 power manager...";fi
echo
echo -e "${YELLOW}"
sudo apt install -y xfce4-power-manager-data xfce4-power-manager-plugins xfce4-power-manager
echo -e "${NOCOLOR}"
sep
echo
echo
echo
qprogress "$script" 60




#========== xfce4 power manager config ==========================================================================
itemdisp "Configuring xfce4 power manager base settings"
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Configuring xfce4 power manager base settings...";fi
echo
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-battery -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/critical-power-action -n -t uint -s 4
#to reconfigure if swap file activated later...
#xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/critical-power-action -s 2
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -n -t bool -s true
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-off -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-ac-sleep -n -t uint -s 15
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-battery-off -n -t uint -s 0
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-on-battery-sleep -n -t uint -s 5
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/general-notification -n -t bool -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/handle-brightness-keys -n -t bool -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -n -t uint -s 90
# xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-ac -t int -s 90 --create
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-on-battery -n -t uint -s 20
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/inactivity-sleep-mode-on-battery -n -t uint -s 1
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-ac -n -t uint -s 1
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lid-action-on-battery -n -t uint -s 1
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/lock-screen-suspend-hibernate -n -t bool -s false
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/logind-handle-lid-switch -n -t bool -s true
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/power-button-action -n -t uint -s 1
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/sleep-button-action -n -t uint -s 1
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -n -t bool -s true
xfconf-query -c xfce4-session -p /general/LockCommand -s "dcop kdesktop KScreensaverIface lock" --create -t string
# modify logind.conf
if ! grep -q "HandleLidSwitch=" "/etc/systemd/logind.conf"; then
echo "HandleLidSwitch=suspend" | sudo tee -a /etc/systemd/logind.conf
fi
sudo sed -i '/HandleLidSwitch=/c\HandleLidSwitch=suspend' /etc/systemd/logind.conf
sep
echo
echo
echo
qprogress "$script" 70

if [[ $conffile -eq 1 ]]; then
kdialog --icon "$kdicon"  --msgbox "Xfce4-power-manager settings panel will open now,\nso you can adjust your preferences.\nJust close the panel once finished."  --caption "qlaptop" --title "q4osXpack"
fi
sh -c xfce4-power-manager-settings > /dev/null 2>&1
qprogress "$script" 80







#========== swap file for hibernation ===========================================================================
itemdisp "Installing swap file for hibernation"
if [[ $insthiber -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing swap file for hibernation...";fi

instswp() {
           #test if zram installed, if not, install it :p
            #this is because we can't use the swap file for swapping and hibernation at the same time, so my choice is to use zram for kernel swapping
            #and the swap file for hibernation
            if ! systemctl is-active --quiet zramswap.service; then
            echo -e "  \e[35m░▒▓█\033[0m Installing zram first..."
            if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing zram first...";fi
            sudo apt install -y zram-tools
            echo -e "ALGO=lz4\nPERCENT=50\nPRIORITY=100" | sudo tee -a /etc/default/zramswap
            sudo tar -xzf perfs/21-swappiness.conf.tar.gz -C /etc/sysctl.d/
            systemctl reload zramswap.service
            fi
            echo -e "  \e[35m░▒▓█\033[0m Installing swap file..."
            if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing swap file...";fi
            #do it
            fileszm=$(expr $filesz / 1024)
            sudo fallocate -l "$fileszm"m /swap
            sudo mkswap /swap
            sudo chmod 600 /swap
            echo "/swap                                     none           swap    sw,pri=0 0 0" | sudo tee -a /etc/fstab
            sudo swapon /swap
            UU=$(findmnt / -o UUID -n)
            OFS=$(sudo filefrag -v /swap|awk 'NR==4{gsub(/\./,"");print $4;}')
            sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&UUID='$UU' resume_offset='$OFS' /' /etc/default/grub
            sudo \cp /etc/initramfs-tools/conf.d/resume "backups/resume_$(date +"%Y-%m-%d_%I-%M%p").bkp"
            echo "RESUME=UUID=$UU" | sudo tee -a /etc/initramfs-tools/conf.d/resume
            sudo update-grub
            sudo sed -i 's/echo/#ech~o/g' /boot/grub/grub.cfg
            qprogress "$script" 85
            sudo update-initramfs -k all -u
            echo -e "  \e[35m░▒▓█\033[0m Activate hibernation & set to hibernate if sleep > 1h30..."
            if ! grep -q "HibernateDelaySec=" "/etc/systemd/sleep.conf"; then
            echo "HibernateDelaySec=5400" | sudo tee -a /etc/systemd/sleep.conf
            fi
            sudo sed -i '/HibernateDelaySec=/c\HibernateDelaySec=5400' /etc/systemd/sleep.conf
            sudo sed -i '/ExecStart=/c\ExecStart=/lib/systemd/systemd-sleep suspend-then-hibernate' /lib/systemd/system/systemd-suspend.service
            echo -e "  \e[35m░▒▓█\033[0m Adjust xfce4-power-manager settings to hibernate if critical battery level..."
            #adjust xfce4-power-manager settings
            xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/critical-power-action -s 2
            echo -e "  \e[35m░▒▓█\033[0m Set lid close action to suspend then hibernate..."
            #lidswitch action
            sudo sed -i '/HandleLidSwitch=/c\HandleLidSwitch=suspend-then-hibernate' /etc/systemd/logind.conf
}


echo
if (grep "GRUB_CMDLINE_LINUX_DEFAULT" "/etc/default/grub")|grep -q "resume_offset="; then
echo "**  resume function seems to be already activated, skipping this part."
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing swap file..."
kdialog --icon "$kdicon" --caption "qlaptop" --title "q4osXpack" --error "resume function seems to be already activated, skipping swap file install"
fi
else 
if grep -q "/swap" "/etc/fstab"; then
echo "**  /swap already exist, skipping this part."
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing swap file..."
kdialog --icon "$kdicon" --caption "qlaptop" --title "q4osXpack" --error "/swap already exist, skipping swap file install"
fi
#TO DO:
#test if resume fonction exist,and in this case propose to adjust parameters for hibernation 
#
else
phymem=$(LANG=C free|awk '/^Mem:/{print $2}')
square_root=$(echo "$phymem" | awk '{print sqrt($1)}')
sqint=$( printf "%.0f" $square_root )
sqintd=$(expr $sqint \* 5)
filesz=$(expr $phymem + $sqintd)
needed=$(expr $filesz + 1048576)
echo " > Total physical memory: $phymem"
echo " > File size needed: $filesz"
dskfree=$(df -k / | tail -1 | awk '{print $4}')
echo " > disk space available: $dskfree"
if [ "$dskfree" -lt "$needed" ]; then
  echo "** sorry not enough disk space free (we must keep at least 1Gb free on the disk :p)"
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Installing swap file..."
kdialog --icon "$kdicon" --caption "qlaptop" --title "q4osXpack" --error "sorry not enough disk space free for swap file (we must keep at least 1Gb free on the disk)"
fi
else
 echo

if [[ $insthiber -eq 1 ]]; then
instswp
else

 echo "${RED}█ ${ORANGE}Proceed ?${NOCOLOR}"
optionz=("Install swap file" "Skip swap file install")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install swap file")
            instswp
            break
            ;;
        "Skip swap file install")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

fi

fi
fi
fi




sep
echo
echo
echo
qprogress "$script" 90

#---------------------------------------
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Cleaning files...";fi
itemdisp "Cleaning..."
echo
sudo apt clean
qprogress "$script" 92
sudo apt autoremove -y
qprogress "$script" 95
sep
echo
echo
echo




qprogress "$script" 100

#========== DONE. ==================================================================================================
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" close
kdialog --icon "$kdicon"  --msgbox "Installation completed."  --caption "qlaptop" --title "q4osXpack"
else
alldone
fi
exit 2

else

echo "   This script is designed for laptop configuration, it seems you're running Rapsberry pi"
echo "   version of q4os, so it's not possible to execute the script."
echo
read -p "Press enter..."
echo
exit 2
fi

