#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
kdicon="$script_directory/../common/Q4OSsebicon.png" 
centerk(){ ressc=$(xrandr | grep '*' | head -n 1 | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}
osarch=$(dpkg --print-architecture)

#__________________________________________________________________________________________________________________________________________________________________________________________
ktext="<font style='color:#ac6009'><strong>⏺ q4osXpack Perf optimizations ⏺</strong></font><br><br>"
kdtitle="q4osXpack"
kdcaption="qperf"


qperf1() {
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="$ktext
─────────────────────<br>
Here are a few additional optimizations that you may toggle,<br>alongside the other optimizations set to be implemented.<br>
(Recommended options are preselected)<br><br>
<font style='color:#828282'>►</font> Select the options you want to apply:<br>
<font style='color:#828282'><em>(or hit cancel to quit)</em></font><br>"
if [ ! "$osarch" = "armhf" ]; then
Sperf=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 450 550) --checklist "$kdtext" "optimized_kernel" "Install optimized kernel" off "install_zram" "Install zram" on "disable_bluetooth" "Disable bluetooth services" off "disable_print" "Disable print services" off "initramfs_trim" "initramfs Trimming" on "disable_logs" "disable logs" on --separate-output )
else
Sperf=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 450 550) --checklist "$kdtext" "install_zram" "Install zram" on "disable_bluetooth" "Disable bluetooth services" off "disable_print" "Disable print services" off "initramfs_trim" "initramfs Trimming" on "rasp_oc" "Raspberry overclocking" off "disable_logs" "disable logs" on --separate-output )
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $? -eq 1 ];then
echo "Canceled.";return 1
else
echo $Sperf
fi
}



qperf2() {
ikern=$(cat /proc/version)
ikernv=$(echo "$ikern" | cut -d' ' -f1-3)
xanver=$(./perfs/check_x86-64_psabi.sh)
vnum="${xanver: -2}"
kdtext="$ktext
─────────────────────<br>
Current kernel installed:<br>$ikernv<br>
─────────────────────<br>
<font style='color:#828282'>►</font> Select a kernel to install:<br>
<font style='color:#828282'><em>(or hit cancel to return to previous choice)</em></font><br>"
Skern=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 400 350) --menu "$kdtext" "Liquorix" "install Liquorix Kernel" "linux-xanmod-x64$vnum" "install linux-xanmod-x64$vnum [MAIN]" "linux-xanmod-lts-x64$vnum" "install linux-xanmod-x64$vnum [LTS]")
#~~~~~~~~~~~~~
if [ $? -eq 1 ];then
echo "Canceled.";return 1
else
echo $Skern
fi
}


qperf3(){
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

kdtext="$ktext
additional optimizations selected:<br>
═══════════════════════════<br>"
if echo $PerfOpt1 | grep -q "optimized_kernel"; then
kdtext="$kdtext""<em>►install optimized kernel ($PerfOpt2) </em><br>";fi
if echo $PerfOpt1 | grep -q "install_zram"; then
kdtext="$kdtext""<em>►install zram</em><br>";fi
if echo $PerfOpt1 | grep -q "disable_bluetooth"; then
kdtext="$kdtext""<em>►disable bluetooth services</em><br>";fi
if echo $PerfOpt1 | grep -q "disable_bluetooth"; then
kdtext="$kdtext""<em>►disable print services</em><br>";fi
if echo $PerfOpt1 | grep -q "initramfs_trim"; then
kdtext="$kdtext""<em>►trim initramfs</em><br>";fi
if echo $PerfOpt1 | grep -q "rasp_oc"; then
kdtext="$kdtext""<em>►raspberry overclocking</em><br>";fi
if echo $PerfOpt1 | grep -q "disable_logs"; then
kdtext="$kdtext""<em>►disable logs</em><br>";fi
kdtext="$kdtext""═══════════════════════════<br><br>
<font style='color:#828282'>►</font> Proceed with these settings ?<br>
<font style='color:#828282'><em>(or hit cancel to return to perf options choice)</em></font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --warningcontinuecancel "$kdtext"
}

while true; do
while true; do

PerfOpt1=$(qperf1)
if [ "$PerfOpt1" = "Canceled." ]; then echo "Canceled by user.";exit;fi

if echo $PerfOpt1 | grep -q "optimized_kernel"; then

PerfOpt2=$(qperf2)
if [ "$PerfOpt2" = "Canceled." ]; then echo "Canceled."
else
break
fi

else
break
fi

done

setok=$(qperf3)
if [ $? -eq 0 ]; then
break
fi

done

tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Root authentification  needed to continue"
oksu=$(sudo -n echo 1 2>&1 | grep 1);if [[ ! $oksu -eq 1 ]];then kdialog --title "q4osXpack » qperf" --icon "$kdicon" --msgbox "Can't continue without root authentification.";exit;fi

dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 300) --progressbar "Initializing ..." 100)




script="   Qperfs script   "
source common/begin
source common/progress
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

begin "$script"
qprogress () {
dcop "$dcopRef" setProgress $2
}


#================================================================================================================



#========== set subscripts perms ================================================================================
qprogress "$script" 0
#set perms
sudo chmod +x perfs/check_x86-64_psabi.sh perfs/perfgrub perfs/perfpiboot perfs/repository.sh perfs/svgcleaner perfs/cleansvg.sh common/pklist 



#========== CREATE BACKUP FOLDER & backup files to be modified ==================================================
create_backup() {
local backup_path="backups/$now/$1.tar.gz"
sudo tar -zcvf "$backup_path" "$2" > /dev/null 2>&1
rota "$dcopRef" "Backup..."
}

dcop "$dcopRef" setLabel "Backup..."
echo -e "${RED}░░▒▒▓▓██ Backup...${NOCOLOR}"
now=$(date +"%Y-%m-%d_%I-%M%p")
sudo mkdir -p "backups/$now" > /dev/null 2>&1
create_backup "grub" "/etc/default/grub"
create_backup "system.conf" "/etc/systemd/system.conf"
create_backup "limits.conf" "/etc/security/limits.conf"
create_backup "fstab" "/etc/fstab"
create_backup "Xsession" "/etc/X11/Xsession"
create_backup "klipperrc" "$USER_HOME/.trinity/share/config/klipperrc"
create_backup "initramfs.conf" "/etc/initramfs-tools/initramfs.conf"
create_backup "tdecryptocardwatcher" "/opt/trinity/bin/tdecryptocardwatcher"
create_backup "atspi.Registry.service" "/usr/share/dbus-1/accessibility-services/org.a11y.atspi.Registry.service"
sudo \cp common/restore "backups/restore_$now"
sudo sed -i "s/XxXxXxXxX/$now/g" "backups/restore_$now"
sudo sed -i "s/YyYyYyYyY/Restoring backup created by qperf script/g" "backups/restore_$now"
sudo chmod +x "backups/restore_$now"
rota
echo
printf '\e[A\e[K'
echo
echo

qprogress "$script" 1





#---------------------------------------------------------------------------------
itemdisp "Checking & installing system updates..."
dcop "$dcopRef" setLabel "Checking & installing system updates..."

konsole --nomenubar --nohist --notabbar --noframe --noscrollbar --vt_sz 88x28 -e common/apt_update.sh "$dcopRef" "perf" -- &
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

sep
echo
echo
echo

qprogress "$script" 3



#========== retrieve packages list ==============================================================================
dcop "$dcopRef" setLabel "Retrieve installed packages list..."
echo -e "   ${ORANGE}░▒▓█ Retrieve installed packages list..."
echo
cd common
sudo ./pklist
cd ..
echo
qprogress "$script" 4




#========== Install optimized Kernel ============================================================================
if [ ! "$osarch" = "armhf" ]; then

if echo $PerfOpt1 | grep -q "optimized_kernel"; then
dcop "$dcopRef" setLabel "Install Optimized Kernel... ($ckern)"
#
if echo $PerfOpt2 | grep -q "Liquorix"; then

konsole --nomenubar --nohist --notabbar --noframe --noscrollbar -e bash -c "curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash" -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount)
done
dcop $kid konsole-mainwindow#1 setGeometry 5 5 600 500
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount)
done
fi
#
#


if echo $PerfOpt2 | grep -q "xanmod"; then
$ckern=$PerfOpt2

dcop "$dcopRef" setLabel "Install Optimized Kernel ($ckern) - update repositories"
konsole --nomenubar --nohist --notabbar --noframe --noscrollbar -e perfs/repository.sh -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount)
done
dcop $kid konsole-mainwindow#1 setGeometry 5 5 600 500
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount)
done

dcop "$dcopRef" setLabel "Install Optimized Kernel ($ckern) - apt update"
konsole --nomenubar --nohist --notabbar --noframe --noscrollbar -e sudo apt update -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount)
done
dcop $kid konsole-mainwindow#1 setGeometry 5 5 600 500
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount)
done

dcop "$dcopRef" setLabel "Install Optimized Kernel ($ckern)..."
konsole --nomenubar --nohist --notabbar --noframe --noscrollbar -e sudo apt install -y $ckern -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount)
done
dcop $kid konsole-mainwindow#1 setGeometry 5 5 600 500
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount)
done

fi
#

kdialog --icon "$kdicon" --title "q4osXpack » qtheme " --yesno "As you installed a new kernel, it is recommanded to reboot right now, before\ntrying to optimize further, and relaunch the script after rebooting.\n► Do you want to reboot now ? (recommended)"
if [[ $? -eq 0 ]]; then
sudo /sbin/reboot
exit
fi

fi 

#
fi


sep
echo
echo
echo
qprogress "$script" 5






#========== Customize Kernel command line =======================================================================
cd perfs
dcop "$dcopRef" setLabel "Tuning kernel command line..."
if [ ! "$osarch" = "armhf" ]; then
sudo ./perfgrub
else
sudo ./perfpiboot
fi
cd ..
qprogress "$script" 8




#========== Disabling Konqueror javascript ======================================================================
itemdisp "Disabling javascript in Konqueror..."
dcop "$dcopRef" setLabel "Disabling javascript in Konqueror..."
echo
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "Java/JavaScript Settings" --key EnableJava false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "Java/JavaScript Settings" --key EnableJavaScript false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "Java/JavaScript Settings" --key EnablePlugins false
sep
echo
echo
echo
qprogress "$script" 10



#========== Disabling libre office javascript ===================================================================
librefile="$USER_HOME/.configtde/libreoffice/4/user/config/javasettings_Linux_X86_64.xml"
if test -f $librefile; then
itemdisp "Disabling javascript in libre office..."
dcop "$dcopRef" setLabel "Disabling javascript in libre office..."
sudo sed -i '/<enabled xsi:nil=/c\<enabled xsi:nil="false">false</enabled>' $librefile
sep
echo
echo
echo
fi
qprogress "$script" 15


#========== Reducing available consoles number  ===================================================================
dcop "$dcopRef" setLabel "Reducing available consoles number..."
sudo sed -i 's/^ACTIVE_CONSOLES=.*/ACTIVE_CONSOLES="\/dev\/tty[1-2]"/' /etc/default/console-setup
if ! grep -q "NAutoVTs=" "/etc/systemd/logind.conf"; then
echo "NAutoVTs=2" | sudo tee -a /etc/systemd/logind.conf
fi
sudo sed -i "/NAutoVTs=/c\NAutoVTs=2" /etc/systemd/logind.conf
sudo sed -i "/#NAutoVTs=/c\NAutoVTs=2" /etc/systemd/logind.conf


#========== Removing firewall ===================================================================================
itemdisp "Removing ufw..."
dcop "$dcopRef" setLabel "Removing ufw..."
echo
sudo apt-get remove -y ufw --purge
sep
echo
echo
echo
qprogress "$script" 19

#========== Removing firewall ===================================================================================
itemdisp "Removing apparmor..."
dcop "$dcopRef" setLabel "Removing ufw..."
echo
sudo apt-get remove -y ufw --purge
sep
echo
echo
echo
qprogress "$script" 20


#========== Removing bluez-cups ===================================================================================
itemdisp "Removing bluez-cups..."
dcop "$dcopRef" setLabel "Removing bluez-cups..."
echo
sudo apt-get remove -y bluez-cups --purge
sep
echo
echo
echo
qprogress "$script" 21



#========== Removing tdecryptocardwatcher =======================================================================
itemdisp "removing tdecryptocardwatcher binary..."
dcop "$dcopRef" setLabel "removing tdecryptocardwatcher binary..."
echo
sudo rm -f /opt/trinity/bin/tdecryptocardwatcher
sep
echo
echo
echo
itemdisp "removing org.a11y.atspi.Registry.service..."
echo
sudo rm -f /usr/share/dbus-1/accessibility-services/org.a11y.atspi.Registry.service
sep
echo
echo
echo
qprogress "$script" 22



#========== Removing xserver-xorg-input-wacom ===================================================================
itemdisp "Removing xserver-xorg-input-wacom..."
dcop "$dcopRef" setLabel "Removing xserver-xorg-input-wacom..."
echo
sudo apt-get remove -y xserver-xorg-input-wacom --purge
sep
echo
echo
echo
qprogress "$script" 23


#========== Removing uneeded fonts ==============================================================================
itemdisp "Removing unwanted fonts..."
dcop "$dcopRef" setLabel "Removing unwanted fonts..."
echo
sudo apt-get remove -y "fonts-kacst" "fonts-khmeros" fonts-lklug-sinhala fonts-guru-extra "fonts-nanum" fonts-noto-cjk "fonts-takao" fonts-tibetan-machine fonts-lao fonts-sil-padauk fonts-sil-abyssinica fonts-beng-extra fonts-gargi fonts-gubbi fonts-gujr-extra fonts-kalapi "fonts-samyak" fonts-navilu fonts-nakula fonts-orya-extra fonts-pagul fonts-sarai "fonts-telu" "fonts-smc*" fonts-deva-extra fonts-sahadeva > /dev/null 2>&1
sudo dpkg-reconfigure fontconfig
sep
echo
echo
echo
qprogress "$script" 24



#========== various sysctl tweaks ===============================================================================
itemdisp "Applying sysctl tweaks..."
dcop "$dcopRef" setLabel "Applying sysctl tweaks.."
echo
cd perfs
sudo tar -xzf 22-perfs.conf.tar.gz -C /etc/sysctl.d/
cd ..
sudo sed -ine '/::/s/^/# /' /etc/hosts
sep
echo
echo
echo
qprogress "$script" 25


#========== Set scheduler for removable drives
itemdisp "Set scheduler for removable drives to none for max throughput"
dcop "$dcopRef" setLabel "Set scheduler for removable drives to none..."
echo
cd perfs
sudo tar -xzf 91-removable_media.rules.tar.gz -C /etc/udev/rules.d/
cd ..
sudo udevadm control --reload-rules
sudo udevadm trigger
sep
echo
echo
echo
qprogress "$script" 28




#========== faster shutdown =====================================================================================
itemdisp "Tweaking  shutdown time..."
dcop "$dcopRef" setLabel "Tweaking  shutdown time..."
echo
if ! grep -q "DefaultTimeoutStopSec=" "/etc/systemd/system.conf"; then
echo "DefaultTimeoutStopSec=10" | sudo tee -a /etc/systemd/system.conf
fi
sudo sed -i "/DefaultTimeoutStopSec=/c\DefaultTimeoutStopSec=10" /etc/systemd/system.conf
sudo sed -i "/#DefaultTimeoutStopSec=/c\DefaultTimeoutStopSec=10" /etc/systemd/system.conf
qprogress "$script" 29


if ! grep -q "DefaultTimeoutAbortSec=" "/etc/systemd/system.conf"; then
echo "DefaultTimeoutAbortSec=10" | sudo tee -a /etc/systemd/system.conf
fi
sudo sed -i "/DefaultTimeoutAbortSec=/c\DefaultTimeoutAbortSec=10" /etc/systemd/system.conf
sudo sed -i "/#DefaultTimeoutAbortSec=/c\DefaultTimeoutAbortSec=10" /etc/systemd/system.conf
qprogress "$script" 30

if ! grep -q "DefaultDeviceTimeoutSec=" "/etc/systemd/system.conf"; then
echo "DefaultDeviceTimeoutSec=10" | sudo tee -a /etc/systemd/system.conf
fi
sudo sed -i "/DefaultDeviceTimeoutSec=/c\DefaultDeviceTimeoutSec=10" /etc/systemd/system.conf
sudo sed -i "/#DefaultDeviceTimeoutSec=/c\DefaultDeviceTimeoutSec=10" /etc/systemd/system.conf
qprogress "$script" 31

if ! grep -q "LogLevel=" "/etc/systemd/system.conf"; then
echo "LogLevel=warning" | sudo tee -a /etc/systemd/system.conf
fi
sudo sed -i "/LogLevel=/c\LogLevel=warning" /etc/systemd/system.conf
sudo sed -i "/#LogLevel=/c\LogLevel=warning" /etc/systemd/system.conf
qprogress "$script" 31


if ! grep -q "DefaultTimeoutStopSec=" "/etc/systemd/user.conf"; then
echo "DefaultTimeoutStopSec=10" | sudo tee -a /etc/systemd/user.conf
fi
sudo sed -i "/DefaultTimeoutStopSec=/c\DefaultTimeoutStopSec=10" /etc/systemd/user.conf
sudo sed -i "/#DefaultTimeoutStopSec=/c\DefaultTimeoutStopSec=10" /etc/systemd/user.conf
qprogress "$script" 32

if ! grep -q "DefaultTimeoutAbortSec=" "/etc/systemd/user.conf"; then
echo "DefaultTimeoutAbortSec=10" | sudo tee -a /etc/systemd/user.conf
fi
sudo sed -i "/DefaultTimeoutAbortSec=/c\DefaultTimeoutAbortSec=10" /etc/systemd/user.conf
sudo sed -i "/#DefaultTimeoutAbortSec=/c\DefaultTimeoutAbortSec=10" /etc/systemd/user.conf
qprogress "$script" 33

if ! grep -q "DefaultDeviceTimeoutSec=" "/etc/systemd/user.conf"; then
echo "DefaultDeviceTimeoutSec=10" | sudo tee -a /etc/systemd/user.conf
fi
sudo sed -i "/DefaultDeviceTimeoutSec=/c\DefaultDeviceTimeoutSec=10" /etc/systemd/user.conf
sudo sed -i "/#DefaultDeviceTimeoutSec=/c\DefaultDeviceTimeoutSec=10" /etc/systemd/user.conf
qprogress "$script" 34

if ! grep -q "LogLevel=" "/etc/systemd/user.conf"; then
echo "LogLevel=warning" | sudo tee -a /etc/systemd/user.conf
fi
sudo sed -i "/LogLevel=/c\LogLevel=warning" /etc/systemd/user.conf
sudo sed -i "/#LogLevel=/c\LogLevel=warning" /etc/systemd/user.conf
qprogress "$script" 35

#using $UID for user system conf overrride

sep
echo
echo
echo




#========== disable core dumps =====================================================================================
itemdisp "Disabling core dumps"
dcop "$dcopRef" setLabel "Disabling core dumps..."
echo
if ! grep -q "* hard core 0" "/etc/security/limits.conf"; then
echo "* hard core 0" | sudo tee -a /etc/security/limits.conf
fi
if ! grep -q "* soft core 0" "/etc/security/limits.conf"; then
echo "* soft core 0" | sudo tee -a /etc/security/limits.conf
fi
cd perfs
sudo tar -xzf 9999-disable-core-dump.conf.tar.gz -C /etc/sysctl.d
cd ..
sudo sysctl -p /etc/sysctl.d/9999-disable-core-dump.conf
sep
echo
echo
echo
qprogress "$script" 40



#========== temp in tmpfs ==========================================================================================
itemdisp "set temp directories as tmpfs"
dcop "$dcopRef" setLabel "set temp directories as tmpfs..."
echo
if ! grep -q "/var/tmp" "/etc/fstab"; then
echo "tmpfs                                     /var/tmp       tmpfs   defaults,noatime,mode=1777 0 0" | sudo tee -a /etc/fstab
fi
if ! grep -q "/var/spool" "/etc/fstab"; then
  echo "tmpfs                                     /var/spool       tmpfs   defaults,noatime,mode=1777 0 0" | sudo tee -a /etc/fstab
fi
sep
echo
echo
echo
qprogress "$script" 42



#========== ext4 commit interval
itemdisp "change commit interval for ext4 partitions"
dcop "$dcopRef" setLabel "change commit interval for ext4 partitions..."
echo
sudo sed -i '/ext4/s/\(defaults,noatime,discard\)\(.*\)\(commit=[0-9]\+\)\(.*\)/\1\2commit=60\4/' "/etc/fstab"
if ! grep -q 'ext4.*commit=' "/etc/fstab"; then sudo sed -i '/ext4/s/\(defaults,noatime,discard\)\(.*\)/\1,commit=60\2/' "/etc/fstab"; fi
sep
echo
echo
echo
qprogress "$script" 45


#========== fast commit for system partition
itemdisp "Setting fast commit for system partition"
dcop "$dcopRef" setLabel "Setting fast commit for system partition..."
sysp=$(df /boot | grep -Eo '/dev/[^ ]+')
sudo tune2fs -O fast_commit $sysp
sep
echo
echo
echo



#========== no .xsession-errors log ================================================================================
itemdisp "Redirecting .xsession-errors to /dev/null"
dcop "$dcopRef" setLabel "Redirecting .xsession-errors to /dev/null"
echo
sudo sed -i '/exec >>"$ERRFILE"/c\exec >> /dev/null 2>&1' /etc/X11/Xsession
sep
echo
echo
echo
qprogress "$script" 47



#========== no klipper/tdehwdevicetrayrc autostart ===================================================================================
itemdisp "Disabling Klipper/tdehwdevicetrayrc autostart..."
dcop "$dcopRef" setLabel "Disabling Klipper/tdehwdevicetrayrc autostart..."
echo
sudo sed -i 's/AutoStart=true/AutoStart=false/' $USER_HOME/.trinity/share/config/klipperrc
echo -e "[General]\nAutostart=false\n" > $USER_HOME/.trinity/share/config/tdehwdevicetrayrc
sep
echo
echo
echo
qprogress "$script" 50




#========== Disabling uneeded services ==========================================================================
itemdisp "Disabling some services..."
echo
echo -e "  ░▒▓█ ModemManager.service"
dcop "$dcopRef" setLabel "Disabling ModemManager service..."
sudo systemctl stop ModemManager.service
sudo systemctl disable ModemManager.service
sudo systemctl mask ModemManager.service
qprogress "$script" 52

echo -e "  ░▒▓█ NetworkManager-wait-online service"
dcop "$dcopRef" setLabel "Disabling NetworkManager-wait-online service..."
sudo systemctl stop NetworkManager-wait-online.service
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
qprogress "$script" 54

echo -e "  ░▒▓█ rsyslog.service"
dcop "$dcopRef" setLabel "Disabling rsyslog service..."
sudo systemctl stop rsyslog
sudo systemctl disable rsyslog
sudo systemctl mask rsyslog
sudo systemctl stop syslog.socket
sudo systemctl disable syslog.socket
sudo systemctl mask syslog.socket
qprogress "$script" 56

echo -e "  ░▒▓█ smbd service"
dcop "$dcopRef" setLabel "Disabling smbd service..."
sudo systemctl stop smbd.service
sudo systemctl disable smbd.service
sudo systemctl mask smbd.service
qprogress "$script" 58

echo -e "  ░▒▓█ nmbd service"
dcop "$dcopRef" setLabel "Disabling nmbd service..."
sudo systemctl stop nmbd.service
sudo systemctl disable nmbd.service
sudo systemctl mask nmbd.service
qprogress "$script" 60

echo -e "  ░▒▓█ apparmor service"
dcop "$dcopRef" setLabel "Disabling apparmor service..."
sudo systemctl stop apparmor
sudo systemctl disable apparmor
sudo systemctl mask apparmor
qprogress "$script" 62

echo -e "  ░▒▓█ serial-getty service"
dcop "$dcopRef" setLabel "Disabling serial-getty service..."
sudo systemctl stop serial-getty@ttyS0.service
sudo systemctl disable serial-getty@ttyS0.service
sudo systemctl mask serial-getty@ttyS0.service
qprogress "$script" 64

echo -e "  ░▒▓█ logrotate service"
dcop "$dcopRef" setLabel "Disabling logrotate service..."
sudo systemctl stop logrotate.service
sudo systemctl disable logrotate.service
sudo systemctl mask logrotate.service
sudo systemctl stop logrotate.timer
sudo systemctl disable logrotate.timer
sudo systemctl mask logrotate.timer
qprogress "$script" 66

echo -e "  ░▒▓█ colord service"
dcop "$dcopRef" setLabel "Disabling colord service..."
sudo systemctl stop colord
sudo systemctl disable colord
sudo systemctl mask colord
qprogress "$script" 68

echo -e "  ░▒▓█ smartd service"
dcop "$dcopRef" setLabel "Disabling colord service..."
sudo systemctl stop smartd
sudo systemctl disable smartd
sudo systemctl mask smartd
qprogress "$script" 70

dcop "$dcopRef" setLabel "Disabling syslog for dbus service..."
sudo sed -i 's/--syslog-only/--nosyslog/g' /lib/systemd/system/dbus.service
sudo sed -i 's/--syslog-only/--nosyslog/g' /lib/systemd/user/dbus.service
qprogress "$script" 71
echo




if echo $PerfOpt1 | grep -q "disable_bluetooth"; then
echo -e "  ░▒▓█ Disabling bluetooth..."
dcop "$dcopRef" setLabel "Disabling bluetooth service..."
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service
sudo systemctl mask bluetooth.service
sudo sed -i -e 's/^AutoEnable=true/AutoEnable=false/' /etc/bluetooth/main.conf
sudo sed -i -e 's/^BLUETOOTH_ENABLED=1/BLUETOOTH_ENABLED=0/' /etc/default/bluetooth
qprogress "$script" 72
fi
echo




if echo $PerfOpt1 | grep -q "disable_print"; then
echo -e "  ░▒▓█ Disabling printing related services..."
dcop "$dcopRef" setLabel "Disabling printing related services..."
sudo systemctl stop cups
sudo systemctl disable cups
sudo systemctl mask cups
sudo systemctl stop cups-browsed
sudo systemctl disable cups-browsed
sudo systemctl mask cups-browsed
qprogress "$script" 73
sudo systemctl stop avahi-daemon
sudo systemctl disable avahi-daemon
sudo systemctl mask avahi-daemon
sudo systemctl stop avahi-utils
sudo systemctl disable avahi-utils
sudo systemctl mask avahi-utils
qprogress "$script" 74
fi
echo
sep
echo
echo
echo
qprogress "$script" 75

#============================================================================================

itemdisp "check if firmwares missing & try autoinstall..."
dcop "$dcopRef" setLabel "check if firmwares missing & try autoinstall..."
echo -e "  ░▒▓█ Installing isenkram-cli..."
echo -e "${YELLOW}"
sudo apt install -y isenkram-cli
echo -e "${NOCOLOR}"
sudo isenkram-autoinstall-firmware
sep
echo
echo
echo
qprogress "$script" 78


if [ ! "$osarch" = "armhf" ]; then
#========== fix i915 modules missing on some intel machines ========================================================
itemdisp "testing if i915 modules firmwares missing..."
dcop "$dcopRef" setLabel "testing if i915 modules firmwares missing..."
echo
sudo update-initramfs -u 2>&1 | sudo tee perfs/outfile
if (grep "Possible missing firmware" "perfs/outfile")|grep -q "module i915"; then
echo
echo -e "  ░▒▓█ Trying to fix i915 missing modules..."
dcop "$dcopRef" setLabel "Trying to fix i915 missing modules..."
echo -e "${YELLOW}"
sudo mkdir firmware
cd firmware
sudo wget -r -nd -e robots=no -A '*.bin' --accept-regex '/plain/' https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915/
sudo mv *.bin /lib/firmware/i915/
qprogress "$script" 79
sudo update-initramfs -c -k all
cd ..
sudo rm -r firmware
echo -e "${NOCOLOR}"
else
echo
echo "no i915 modules firmwares missing."
fi
sudo rm perfs/outfile
sep
echo
echo
echo
qprogress "$script" 80



itemdisp "checking if i915 is the kernel driver in use..."
dcop "$dcopRef" setLabel "checking if i915 is the kernel driver in use..."
vidadapt=$(lspci -k | grep -EA3 'VGA|3D|Display')
if (echo $vidadapt | grep -q "Kernel driver in use: i915"); then
echo "> Kernel driver in use: i915 - applying tweaking"
if [[ $conffile -eq 1 ]]; then dcop "$dcopRef" setLabel "Kernel driver in use: i915 - applying tweaking...";fi
sudo tar -xzf laptop/i915.conf.tar.gz -C /etc/modprobe.d/
fi
sep
echo
echo
echo
qprogress "$script" 82
fi



#========== install zram ===========================================================================================
if echo $PerfOpt1 | grep -q "install_zram"; then

itemdisp "Installing zram"
echo -e "  ░▒▓█ Installing zram..."
dcop "$dcopRef" setLabel "Installing zram..."
echo -e "${YELLOW}"
sudo apt install -y zram-tools
echo -e "${NOCOLOR}"
mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
mem_go=$(echo "scale=2; $mem_kb / 1024 / 1024" | bc)
if (( $(echo "$mem_go < 2" | bc -l) )); then
echo -e "ALGO=lz4\nPERCENT=70\nPRIORITY=100" | sudo tee -a /etc/default/zramswap
elif (( $(echo "$mem_go >= 2" | bc -l) )); then
echo -e "ALGO=lz4\nPERCENT=50\nPRIORITY=100" | sudo tee -a /etc/default/zramswap
fi
cd perfs
sudo tar -xzf 21-swappiness.conf.tar.gz -C /etc/sysctl.d/
cd ..
sudo systemctl reload zramswap.service
#raspberry
if [ "$osarch" = "armhf" ]; then
echo -e "  ░▒▓█ Disabling the swap file..."
dcop "$dcopRef" setLabel "Disabling the swap file..."
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove
sudo systemctl disable dphys-swapfile
sudo systemctl mask dphys-swapfile
fi
sep
echo
echo
echo
fi
qprogress "$script" 85




#========== trim initramfs for faster boot =========================================================================
# faster boot, drawbacks: system will not be 'portable' with this setting as initramfs is build with only the needed
# modules for this computer.However, this is perfectly suitable for desktop usage.
if echo $PerfOpt1 | grep -q "initramfs_trim"; then

itemdisp "Trim initramfs"
echo -e "  ░▒▓█ Trimming initramfs..."
dcop "$dcopRef" setLabel "Trimming initramfs..."
sudo sed -i "/MODULES=/c\MODULES=dep" /etc/initramfs-tools/initramfs.conf
sudo sed -i "/COMPRESS=/c\COMPRESS=zstd" /etc/initramfs-tools/initramfs.conf
sudo sed -i "/COMPRESSLEVEL=/c\COMPRESSLEVEL=14" /etc/initramfs-tools/initramfs.conf
#sudo update-initramfs -c -k $(uname -r)
sudo update-initramfs -c -k all
sep
echo
echo
echo
fi
qprogress "$script" 87


#========== disabling iwl-debug-yoyo.bin =====================================================================================
itemdisp "Disabling iwl-debug-yoyo.bin"
dcop "$dcopRef" setLabel "Disabling iwl-debug-yoyo.bin..."
cd perfs
sudo tar -xzf iwlwifi.conf.tar.gz -C /etc/modprobe.d/
cd ..
sep
echo
echo
echo
qprogress "$script" 88

#========== disabling pc speaker =====================================================================================
itemdisp "Disabling pc speaker module"
dcop "$dcopRef" setLabel "Disabling pc speaker module"
cd perfs
sudo tar -xzf nopcspkr.conf.tar.gz -C /etc/modprobe.d/
cd ..
sep
echo
echo
echo
qprogress "$script" 89


#========== installing ananicy  =====================================================================================
itemdisp "Installing ananicy-cpp"
dcop "$dcopRef" setLabel "Installing ananicy-cpp..."

cd perfs
if [ "$osarch" = "armhf" ]; then
sudo 7z x -so ananicy-cpp_bin_armhf.tar.7z | sudo tar xf - -C /usr/local/bin/
else
if ( getconf LONG_BIT | grep -q 64 ); then
sudo 7z x -so ananicy-cpp_bin_64.tar.7z | sudo tar xf - -C /usr/local/bin/
else
sudo 7z x -so ananicy-cpp_bin_32.tar.7z | sudo tar xf - -C /usr/local/bin/
fi;fi
sudo mkdir -p /usr/local/lib/systemd/system
sudo tar -xzf ananicy-cpp.service.tar.gz -C /usr/local/lib/systemd/system/
sudo mkdir -p /etc/ananicy.d
sudo tar -xzf ananicy.rules.tar.gz -C /etc/ananicy.d/
cd ..
sudo chmod +x /usr/local/bin/ananicy-cpp
sudo systemctl enable --now ananicy-cpp.service
sep
echo
echo
echo
qprogress "$script" 90


#========== tuning compton tde =====================================================================================
itemdisp "Tuning compton tde..."
dcop "$dcopRef" setLabel "Tuning compton tde..."
echo

if [ ! "$osarch" = "armhf" ]; then
#glx backend
if grep -q "backend =" "$USER_HOME/.compton-tde.conf" || grep -q "backend=" "$USER_HOME/.compton-tde.conf"; then
sudo sed -i '/backend =/c\backend = "glx";' $USER_HOME/.compton-tde.conf
sudo sed -i '/backend=/c\backend = "glx";' $USER_HOME/.compton-tde.conf
else
echo 'backend = "glx";' | sudo tee -a $USER_HOME/.compton-tde.conf
fi
#glx paint-on-overlay
if grep -q "paint-on-overlay =" "$USER_HOME/.compton-tde.conf" || grep -q "paint-on-overlay=" "$USER_HOME/.compton-tde.conf"; then
sudo sed -i '/paint-on-overlay =/c\paint-on-overlay = true;' $USER_HOME/.compton-tde.conf
sudo sed -i '/paint-on-overlay=/c\paint-on-overlay = true;' $USER_HOME/.compton-tde.conf
else
echo 'paint-on-overlay = true;' | sudo tee -a $USER_HOME/.compton-tde.conf
fi
#glx glx-no-stencil
if grep -q "glx-no-stencil =" "$USER_HOME/.compton-tde.conf" || grep -q "glx-no-stencil=" "$USER_HOME/.compton-tde.conf"; then
sudo sed -i '/glx-no-stencil =/c\glx-no-stencil = true;' $USER_HOME/.compton-tde.conf
sudo sed -i '/glx-no-stencil=/c\glx-no-stencil = true;' $USER_HOME/.compton-tde.conf
else
echo 'glx-no-stencil = true;' | sudo tee -a $USER_HOME/.compton-tde.conf
fi
#glx-no-rebind-pixmap
if grep -q "glx-no-rebind-pixmap =" "$USER_HOME/.compton-tde.conf" || grep -q "glx-no-rebind-pixmap=" "$USER_HOME/.compton-tde.conf"; then
sudo sed -i '/glx-no-rebind-pixmap =/c\glx-no-rebind-pixmap = true;' $USER_HOME/.compton-tde.conf
sudo sed -i '/glx-no-rebind-pixmap=/c\glx-no-rebind-pixmap = true;' $USER_HOME/.compton-tde.conf
else
echo 'glx-no-rebind-pixmap = true;' | sudo tee -a $USER_HOME/.compton-tde.conf
fi
#vsync
if grep -q "vsync =" "$USER_HOME/.compton-tde.conf" || grep -q "vsync=" "$USER_HOME/.compton-tde.conf"; then
sudo sed -i '/vsync =/c\vsync = "opengl-swc";' $USER_HOME/.compton-tde.conf
sudo sed -i '/vsync=/c\vsync = "opengl-swc";' $USER_HOME/.compton-tde.conf
else
echo 'vsync = "opengl-swc";' | sudo tee -a $USER_HOME/.compton-tde.conf
fi

else
#xrender backend for raspberry as gl seems bugged
if grep -q "backend =" "$USER_HOME/.compton-tde.conf" || grep -q "backend=" "$USER_HOME/.compton-tde.conf"; then
sudo sed -i '/backend =/c\backend = "xrender";' $USER_HOME/.compton-tde.conf
sudo sed -i '/backend=/c\backend = "xrender";' $USER_HOME/.compton-tde.conf
else
echo 'backend = "xrender";' | sudo tee -a $USER_HOME/.compton-tde.conf
fi

fi
sep
echo
echo
echo
qprogress "$script" 91


if [ "$osarch" = "armhf" ]; then
itemdisp "Check if we need to apply chromium tweaks ..."
dcop "$dcopRef" setLabel "Check if we need to apply chromium tweaks..."
echo
if (cat common/packages_list.tmp | grep -q "chromium/stable"); then
if [ -e "/usr/share/applications/chromium.desktop" ]; then
sudo perfs/chromium_perfs.sh
fi
if [ -e "/usr/share/applications/chromium-browser.desktop" ]; then
sudo perfs/chromium_perfs.sh
fi
fi
sep
echo
echo
echo
qprogress "$script" 92
fi




if echo $PerfOpt1 | grep -q "rasp_oc"; then

itemdisp "Applying overclocking settings..."
dcop "$dcopRef" setLabel "Applying overclocking settings..."
fichier="/boot/firmware/config.txt"
ocapply=0
model=$(cat /sys/firmware/devicetree/base/model)
#pi 4 > over_voltage=6   ;   arm_freq=1850   ; gpu_freq=750
#pi 400 > over_voltage=6   ;   arm_freq=2000   ; gpu_freq=800
#pi 3 > over_voltage=5   ;   arm_freq=1300   ; gpu_freq=500
#pi 3B+ > over_voltage=5   ;   arm_freq=1450   ; gpu_freq=500
#pi 5 ? (is it needed ?)
if [[ $model =~ "Pi 400 " ]]; then
over_voltage=6;arm_freq=2000;gpu_freq=800;ocapply=1
elif [[ $model =~ "Pi 4 " ]]; then
over_voltage=6;arm_freq=1850;gpu_freq=750;ocapply=1
elif [[ $model =~ "3 Model B Plus Rev" ]]; then
over_voltage=5;arm_freq=1450;gpu_freq=500;ocapply=1
elif [[ $model =~ "3 Model B Rev" ]]; then
over_voltage=5;arm_freq=1300;gpu_freq=500;ocapply=1
fi
if [ "$ocapply" -eq 1 ]; then
if grep -q "^over_voltage=[0-9]\+" "$fichier"; then
sudo sed -i "s/^over_voltage=[0-9]\+/over_voltage=$over_voltage/" "$fichier"
else
echo "over_voltage=$over_voltage" | sudo tee -a "$fichier" > /dev/null
fi
if grep -q "^arm_freq=[0-9]\+" "$fichier"; then
sudo sed -i "s/^arm_freq=[0-9]\+/arm_freq=$arm_freq/" "$fichier"
else
echo "arm_freq=$arm_freq" | sudo tee -a "$fichier" > /dev/null
fi
if grep -q "^gpu_freq=[0-9]\+" "$fichier"; then
sudo sed -i "s/^gpu_freq=[0-9]\+/gpu_freq=$gpu_freq/" "$fichier"
else
echo "gpu_freq=$gpu_freq" | sudo tee -a "$fichier" > /dev/null
fi;fi
sep
echo
echo
echo
fi
qprogress "$script" 93




#==================================================================================================================
if echo $PerfOpt1 | grep -q "disable_logs"; then

itemdisp "Disabling/Redirecting some logs to /dev/null..."
dcop "$dcopRef" setLabel "Disabling/Redirecting some logs to /dev/null..."
echo
sudo rm -f '/var/log/*.old'
sudo rm -f '/var/log/boot.log'
sudo ln -s /dev/null '/var/log/boot.log'
sudo rm -f '/var/log/Xorg.0.log'
sudo ln -s /dev/null '/var/log/Xorg.0.log'
sudo rm -f '/var/log/Xorg.1.log'
sudo ln -s /dev/null '/var/log/Xorg.1.log'
sudo rm -f '/var/log/tdm.log'
sudo ln -s /dev/null '/var/log/tdm.log'
sudo rm -f '/var/log/fontconfig.log'
sudo ln -s /dev/null '/var/log/fontconfig.log'
sudo rm -f '/var/log/lastlog'
sudo ln -s /dev/null '/var/log/lastlog'
lastlogline=$(grep "pam_lastlog.so" "/etc/pam.d/login");if [[ -n "$lastlogline" && "$lastlogline" != \#* ]]; then sudo sed -i "/$lastlogline/s/^/#/" "/etc/pam.d/login"; fi
maillogline=$(grep "pam_mail.so" "/etc/pam.d/login");if [[ -n "$maillogline" && "$maillogline" != \#* ]]; then sudo sed -i "/$maillogline/s/^/#/" "/etc/pam.d/login"; fi
sudo rm -f '/var/log/wtmp'
sudo ln -s /dev/null '/var/log/wtmp'
sudo rm -f '/var/log/preload.log'
sudo ln -s /dev/null '/var/log/preload.log'
sudo rm -f '/var/log/apt/term.log'
#sudo ln -s /dev/null '/var/log/apt/term.log'
sudo rm -f '/var/log/cups/error_log'
sudo ln -s /dev/null '/var/log/cups/error_log'
sudo rm -f '/var/log/cups/access_log.1'
sudo rm -f '/var/log/cups/access_log'
sudo ln -s /dev/null '/var/log/cups/access_log'
sudo rm -f '/var/log/kern.log'
sudo ln -s /dev/null '/var/log/kern.log'
sudo rm -f '/var/log/syslog'
sudo ln -s /dev/null '/var/log/syslog'
if ! grep -q "Storage=" "/etc/systemd/journald.conf"; then
echo "Storage=none" | sudo tee -a /etc/systemd/journald.conf
fi
sudo sed -i "/Storage=/c\Storage=none" /etc/systemd/journald.conf
sudo sed -i "/#Storage=/c\Storage=none" /etc/systemd/journald.conf
sudo sed -i '/module(load="imklog")/c\#module(load="imklog")' /etc/rsyslog.conf
sep
echo
echo
echo
fi
qprogress "$script" 95



itemdisp "Optimizing svg images..."
dcop "$dcopRef" setLabel "Optimizing svg images..."
echo
cd perfs
sudo ./cleansvg.sh
cd ..
sep
echo
echo
echo
qprogress "$script" 98




#========== cleaning ===============================================================================================
itemdisp "Cleaning system..."
dcop "$dcopRef" setLabel "Cleaning system...  (apt clean)"
echo
sudo apt clean
dcop "$dcopRef" setLabel "Cleaning system...  (apt autoclean)"
sudo apt autoclean -y
qprogress "$script" 99
dcop "$dcopRef" setLabel "Cleaning system...  (apt autoremove)"
sudo apt autoremove -y
sep
echo
echo
echo
qprogress "$script" 100




#========== DONE. ==================================================================================================
cat common/atyourownrisk
dcop "$dcopRef" close
kdialog --icon "$kdicon" --title "q4osXpack » qperf " --yesno "Installation Completed.\nDo you want to reboot now ? (recommended)"
if [[ $? -eq 0 ]]; then
sudo /sbin/reboot
fi

exit 2


