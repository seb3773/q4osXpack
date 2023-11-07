#!/bin/bash
script="Qperf script"
source common/begin
source common/progress
begin "$script"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

progress "$script" 0
#CREATE BACKUP FOLDER & backup files to be modified
echo -e "${RED}░░▒▒▓▓██\033[0m Backup...${NOCOLOR}"
now=$(date +"%Y-%m-%d_%I-%M%p")
sudo mkdir "backups/$now" > /dev/null 2>&1
sudo tar -zcvf "backups/$now/grub.tar.gz" /etc/default/grub > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/system.conf.tar.gz" /etc/systemd/system.conf > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/limits.conf.tar.gz" /etc/security/limits.conf > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/fstab.tar.gz" /etc/fstab > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/Xsession.tar.gz" /etc/X11/Xsession > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/klipperrc.tar.gz" $USER_HOME/.trinity/share/config/klipperrc > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/initramfs.conf.tar.gz" /etc/initramfs-tools/initramfs.conf > /dev/null 2>&1
rota
sudo tar -zcvf "backups/$now/getty.tar.gz" /sbin/getty > /dev/null 2>&1
rota

sudo \cp common/restore "backups/restore_$now"
sudo sed -i "s/XxXxXxXxX/$now/g" "backups/restore_$now"
sudo chmod +x "backups/restore_$now"
rota
echo
printf '\e[A\e[K'
echo
echo



itemdisp "Install Optimized Kernel..."
echo
echo "> Current Kernel version:"
echo -e "${ORANGE}"
cat /proc/version
echo -e "${NOCOLOR}"
echo
echo -e "Xanmod kernel version supported:"
./perfs/check_x86-64_psabi.sh
echo
echo -e "${RED}█ ${ORANGE}Please select option:${NOCOLOR}"
options=("install Liquorix Kernel" "install linux-xanmod-x64v1" "install linux-xanmod-x64v2" "install linux-xanmod-x64v3" "install linux-xanmod-x64v4" "Skip kernel install")
select opt in "${options[@]}"
do
    case $opt in
        "install Liquorix Kernel")
            echo -e "  \e[35m░▒▓█\033[0m Installing Liquorix Kernel"
            echo -e "${YELLOW}"
            curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
            echo -e "${NOCOLOR}"
            break
            ;;
        "install linux-xanmod-x64v1")
            echo -e "  \e[35m░▒▓█\033[0m Installing linux-xanmod-x64v1"
            ./perfs/repository.sh
            echo -e "${YELLOW}"
            sudo apt update && sudo apt install -y linux-xanmod-x64v1
            echo -e "${NOCOLOR}"
            break
            ;;
        "install linux-xanmod-x64v2")
            echo -e "  \e[35m░▒▓█\033[0m Installing linux-xanmod-x64v2"
            ./perfs/repository.sh
            echo -e "${YELLOW}"
            sudo apt update && sudo apt install -y linux-xanmod-x64v2
            echo -e "${NOCOLOR}"
            break
            ;;
        "install linux-xanmod-x64v3")
            echo -e "  \e[35m░▒▓█\033[0m Installing linux-xanmod-x64v3"
            ./perfs/repository.sh
            echo -e "${YELLOW}"
            sudo apt update && sudo apt install -y linux-xanmod-x64v3
            echo -e "${NOCOLOR}"
            break
            ;;
        "install linux-xanmod-x64v4")
            echo -e "  \e[35m░▒▓█\033[0m Installing linux-xanmod-x64v4"
            ./perfs/repository.sh
            echo -e "${YELLOW}"
            sudo apt update && sudo apt install -y linux-xanmod-x64v4
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip kernel install")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 5

cd perfs
sudo ./perfgrub
cd ..
progress "$script" 10

itemdisp "Installing preload..."
echo -e "${YELLOW}"
sudo apt-get -y install preload
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 15

itemdisp "Disabling some services..."
echo
echo -e "  \e[35m░▒▓█\033[0m ModemManager.service"
sudo systemctl stop ModemManager.service
sudo systemctl disable ModemManager.service
sudo systemctl mask ModemManager.service
echo -e "  \e[35m░▒▓█\033[0m NetworkManager-wait-online service"
sudo systemctl stop NetworkManager-wait-online.service
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
progress "$script" 20
echo -e "  \e[35m░▒▓█\033[0m rsyslog.service"
sudo systemctl stop rsyslog
sudo systemctl disable rsyslog
sudo systemctl mask rsyslog
echo -e "  \e[35m░▒▓█\033[0m avahi-daemon service"
sudo systemctl stop avahi-daemon
sudo systemctl disable avahi-daemon
sudo systemctl mask avahi-daemon
progress "$script" 25
echo -e "  \e[35m░▒▓█\033[0m smbd service"
sudo systemctl stop smbd.service
sudo systemctl disable smbd.service
sudo systemctl mask smbd.service
echo -e "  \e[35m░▒▓█\033[0m nmbd service"
sudo systemctl stop nmbd.service
sudo systemctl disable nmbd.service
sudo systemctl mask nmbd.service
sep
echo
echo
echo
progress "$script" 30


itemdisp "Replacing agetty by ngetty..."
echo
echo -e "  \e[35m░▒▓█\033[0m installing ngetty..."
echo -e "${YELLOW}"
sudo apt install -y ngetty
echo -e "${NOCOLOR}"
sudo rm /sbin/getty
sudo ln -s /sbin/ngetty /sbin/getty
sep
echo
echo
echo
progress "$script" 40


itemdisp "Removing ufw..."
echo
sudo apt-get remove -y ufw --purge
sep
echo
echo
echo
progress "$script" 45


itemdisp "Removing unwanted fonts..."
echo
sudo apt-get remove -y "fonts-kacst" "fonts-khmeros" fonts-lklug-sinhala fonts-guru-extra "fonts-nanum" fonts-noto-cjk "fonts-takao" fonts-tibetan-machine fonts-lao fonts-sil-padauk fonts-sil-abyssinica fonts-beng-extra fonts-gargi fonts-gubbi fonts-gujr-extra fonts-kalapi "fonts-samyak" fonts-navilu fonts-nakula fonts-orya-extra fonts-pagul fonts-sarai "fonts-telu" "fonts-smc*" fonts-deva-extra fonts-sahadeva
sudo dpkg-reconfigure fontconfig
sep
echo
echo
echo
progress "$script" 50



itemdisp "Applying sysctl tweaks..."
echo
cd perfs
sudo tar -xzf 22-perfs.conf.tar.gz -C /etc/sysctl.d/
cd ..
sep
echo
echo
echo
progress "$script" 55


itemdisp "Tweaking  shutdown time..."
echo
sudo sed -i "/DefaultTimeoutStopSec=/c\DefaultTimeoutStopSec=10" /etc/systemd/system.conf
if ! grep -q "DefaultTimeoutStopSec=10" "/etc/systemd/system.conf"; then
echo "DefaultTimeoutStopSec=10" | sudo tee -a /etc/systemd/system.conf
fi
sep
echo
echo
echo
progress "$script" 60



itemdisp "Disabling core dumps"
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
progress "$script" 65


itemdisp "temp directories as tmps"
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
progress "$script" 70



itemdisp "Redirecting .xsession-errors to /dev/null"
echo
sudo sed -i '/exec >>"$ERRFILE"/c\exec >> /dev/null 2>&1' /etc/X11/Xsession
sep
echo
echo
echo
progress "$script" 75




itemdisp "Disabling Klipper autostart..."
echo
sudo sed -i 's/AutoStart=true/AutoStart=false/' $USER_HOME/.trinity/share/config/klipperrc
sep
echo
echo
echo
progress "$script" 80


itemdisp "testing if i915 modules firmwares missing..."
echo
sudo update-initramfs -u 2>&1 | sudo tee perfs/outfile
if (grep "Possible missing firmware" "perfs/outfile")|grep -q "module i915"; then
echo
echo -e "${RED}█ ${ORANGE}i915 modules missing, try to fix ?${NOCOLOR}"
optionz=("Yes, try to fix it" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Yes, try to fix it")
            echo -e "  \e[35m░▒▓█\033[0m Fixing i915 missing modules..."
echo -e "${YELLOW}"
sudo mkdir firmware
cd firmware
sudo wget -r -nd -e robots=no -A '*.bin' --accept-regex '/plain/' https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915/
sudo mv *.bin /lib/firmware/i915/
sudo update-initramfs -c -k all
cd ..
sudo rm -r firmware
echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
else
echo
echo "no i915 modules firmwares missing."
fi
sudo rm perfs/outfile
sep
echo
echo
echo
progress "$script" 85



itemdisp "Installing zram"
echo
echo -e "${RED}█ ${ORANGE}Install zram ? (recommended if ram <= 8Go)${NOCOLOR}"
optionz=("Install zram" "Skip zram install")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install zram")
            echo -e "  \e[35m░▒▓█\033[0m Installing zram..."
            echo -e "${YELLOW}"
            sudo apt install -y zram-tools
            echo -e "${NOCOLOR}"
            echo -e "ALGO=lz4\nPERCENT=50\nPRIORITY=100" | sudo tee -a /etc/default/zramswap
            cd perfs
            sudo tar -xzf 21-swappiness.conf.tar.gz -C /etc/sysctl.d/
            cd ..
            systemctl reload zramswap.service
            break
            ;;
        "Skip zram install")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 90


itemdisp "Trim initramfs"
echo
echo -e "${RED}█ ${ORANGE}Trim initramfs ?"
echo -e "( xxxx xxx xx xx )${NOCOLOR}"
optionz=("Trim initramfs" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Trim initramfs")
            echo -e "  \e[35m░▒▓█\033[0m Trimming initramfs..."
            sudo sed -i "/MODULES=/c\MODULES=dep" /etc/initramfs-tools/initramfs.conf
            sudo sed -i "/COMPRESS=/c\COMPRESS=zstd" /etc/initramfs-tools/initramfs.conf
            sudo sed -i "/COMPRESSLEVEL=/c\COMPRESSLEVEL=12" /etc/initramfs-tools/initramfs.conf
            #sudo update-initramfs -c -k $(uname -r)
            sudo update-initramfs -c -k all
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 95







itemdisp "Cleaning system..."
echo
sudo apt clean
sudo apt autoremove -y
sep
echo
echo
echo
progress "$script" 100

alldone

echo
echo -e "\e[5m~~ a reboot is recommended ~~\e[25m"
echo
echo " > Do you want to reboot right now ? (y/n)" && read x && [[ "$x" == "y" ]] && sudo /sbin/reboot;
echo

wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
