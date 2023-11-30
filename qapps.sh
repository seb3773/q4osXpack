#!/bin/bash
helpdoc=0
installall=0
VALID_ARGS=$(getopt -o ha --long help,all -- "$@")
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
    -a | --all)
        installall=1
        shift
        ;;
     --) shift; 
        break 
        ;;
  esac
done
if [ $helpdoc -eq 1 ]; then
script="Help Qapps"
else
script="   Qapps script   "
fi
source common/resizecons
source common/begin
source common/progress
begin "$script"
#================================================================================================================



#=================== functions ==================================================================================
function isinstalled() {
local string="$1"
local file="$2"
if grep -q "$string" "$file"; then
return 0
else
return 1
fi
}


function installApp() {
local appName="$1"
local packageString="$2"
if ! isinstalled "$packageString" "common/packages_list.tmp"; then
echo -e "${YELLOW}"
sudo apt install -y "$appName"
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
if ! [[ -v $3 ]]; then
sep
echo
echo
echo
fi
}

#========== retrieve packages list ==============================================================================
progress "$script" 0
echo -e "    ${ORANGE}░▒▓█\033[0m Retrieve packages list...${NOCOLOR}"
echo
cd common
sudo ./pklist
cd ..
echo


#============== Install Apps (automatic) ========================================================================
itemdisp "Installing GIT..."
installApp "git" "git/stable"
progress "$script" 5


#sudo apt install -y locate


itemdisp "Installing Ark..."
installApp "ark" "ark/stable"
progress "$script" 5



itemdisp "Installing 7zip..."
installApp "7z" "p7zip-full/stable"
progress "$script" 15



itemdisp "Installing Dolphin..."
installApp "dolphin-trinity" "dolphin-trinity/"
progress "$script" 20


itemdisp "Installing Baobab..."
installApp "baobab" "baobab/stable"
progress "$script" 25



itemdisp "Installing system-config-printer..."
installApp "system-config-printer" "system-config-printer/stable"
progress "$script" 30



itemdisp "Installing flashfetch"
cd apps
echo -e "${YELLOW}"
sudo tar -xzf flashfetch.tar.gz -C /usr/bin/
echo "flashfetch binary copied in /usr/bin/"
cd ..
echo -e "${NOCOLOR}"
#flashfetch
sep
echo
echo
echo
progress "$script" 35



itemdisp "Installing Stacer..."
installApp "stacer" "stacer/stable"
progress "$script" 40



itemdisp "Installing bleachbit..."
installApp "bleachbit" "bleachbit/stable"
progress "$script" 45



itemdisp "Installing vlc..."
installApp "vlc" "vlc/stable"
progress "$script" 50



#classics tools, may be already installed with desktop version
itemdisp "Installing Kolourpaint,KCharSelect,Ksnapshot,knotes..."
echo
echo -e "  \e[35m░▒▓█\033[0m Installing Kolourpaint..."
installApp "kolourpaint-trinity" "kolourpaint-trinity" 0
echo -e "  \e[35m░▒▓█\033[0m Installing KCharSelect..."
installApp "kcharselect-trinity" "kcharselect-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing Ksnapshot..."
installApp "ksnapshot-trinity" "ksnapshot-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing Knotes..."
installApp "knotes-trinity" "knotes-trinity"
progress "$script" 55





#============== Install Apps (interactive) ======================================================================

itemdisp "Installing qbittorent"
#qbittorrent
if [ "$installall" -eq 1 ]; then
    installApp "qbittorrent" "qbittorrent/stable"
else
echo
echo -e "${RED}█ ${ORANGE}Install qbittorrent ?${NOCOLOR}"
optionz=("Install qbittorrent" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install qbittorrent")
            echo -e "  \e[35m░▒▓█\033[0m Installing qbittorrent..."
            installApp "qbittorrent" "qbittorrent/stable"
            break
            ;;
        "Skip")
            sep
            echo
            echo
            echo
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
progress "$script" 60









itemdisp "Installing spotify"
#spotify
installSpoty () {
            if ! isinstalled "spotify-client/stable" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
            echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
            sudo apt-get update
            sudo apt-get install -y spotify-client
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
if [ "$installall" -eq 1 ]; then
    installSpoty
else
echo
echo -e "${RED}█ ${ORANGE}Install spotify ?${NOCOLOR}"
optionz=("Install spotify" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install spotify")
            echo -e "  \e[35m░▒▓█\033[0m Installing spotify..."
            installSpoty
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
sep
echo
echo
echo
progress "$script" 65






itemdisp "Installing gparted"
if [ "$installall" -eq 1 ]; then
    installApp "gparted" "gparted/stable"
else
#gparted
echo
echo -e "${RED}█ ${ORANGE}Install gparted ? (partitions manager)${NOCOLOR}"
optionz=("Install gparted" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install gparted")
            echo -e "  \e[35m░▒▓█\033[0m Installing gparted..."
            installApp "gparted" "gparted/stable"
            break
            ;;
        "Skip")
            sep
            echo
            echo
            echo
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
progress "$script" 70







itemdisp "Installing S4 Snapshot"
#q4os-s4-snapshot
if [ "$installall" -eq 1 ]; then
            echo -e "${YELLOW}"
            cd apps
            sudo qsinst setup_q4os-s4-snapshot_4.1-a1_amd64.qsi
            cd ..
            echo -e "${NOCOLOR}"
else
echo
echo -e "${RED}█ ${ORANGE}Install S4 Snapshot ? (create an bootable iso of a running system)${NOCOLOR}"
optionz=("Install S4 Snapshot" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install S4 Snapshot")
            echo -e "  \e[35m░▒▓█\033[0m Installing S4 Snapshot..."
            echo -e "${YELLOW}"
            cd apps
            sudo qsinst setup_q4os-s4-snapshot_4.1-a1_amd64.qsi
            cd ..
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
sep
echo
echo
echo
progress "$script" 75






itemdisp "Installing remmina"
#remmina
if [ "$installall" -eq 1 ]; then
    installApp "remmina" "remmina/stable"
else
echo
echo -e "${RED}█ ${ORANGE}Install remmina ? (rdp / vnc / ssh remote desktop client)${NOCOLOR}"
optionz=("Install remmina" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install remmina")
            echo -e "  \e[35m░▒▓█\033[0m Installing remmina..."
            installApp "remmina" "remmina/stable"
            break
            ;;
        "Skip")
            sep
            echo
            echo
            echo
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
progress "$script" 80







itemdisp "Installing free office"
function installFreeO() {
           if ! isinstalled "softmaker-freeoffice-" "common/packages_list.tmp"; then
            echo -e "  \e[35m░▒▓█\033[0m Installing free office..."
            echo -e "${YELLOW}"
            mkdir -p /etc/apt/keyrings
            sudo bash -c 'wget -qO- https://shop.softmaker.com/repo/linux-repo-public.key | gpg --dearmor > /etc/apt/keyrings/softmaker.gpg'
            sudo bash -c 'echo "deb [signed-by=/etc/apt/keyrings/softmaker.gpg] https://shop.softmaker.com/repo/apt stable non-free" > /etc/apt/sources.list.d/softmaker.list'
            sudo apt update
            sudo apt install -y softmaker-freeoffice-2021
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
#softmaker-freeoffice-2021
if [ "$installall" -eq 1 ]; then
installFreeO
else
echo
echo -e "${RED}█ ${ORANGE}Install free office (a word/excel/ppoint clone) ?${NOCOLOR}"
optionz=("Install free office" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install free office")
            echo -e "  \e[35m░▒▓█\033[0m Installing free office..."
            installFreeO
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
sep
echo
echo
echo
progress "$script" 85








itemdisp "Installing bpytop"
#bpytop
if [ "$installall" -eq 1 ]; then
installApp "bpytop" "bpytop/stable"
else
echo
echo -e "${RED}█ ${ORANGE}Install bpytop ? (CLI htop alternative)${NOCOLOR}"
optionz=("Install bpytop" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install bpytop")
            echo -e "  \e[35m░▒▓█\033[0m Installing bpytop"
            installApp "bpytop" "bpytop/stable"
            break
            ;;
        "Skip")
            sep
            echo
            echo
            echo
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
sep
echo
echo
echo
progress "$script" 90






itemdisp "Installing virtualbox 7"
#spotify
installVbox () {
            if ! isinstalled "virtualbox-7.0/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
            sudo apt update
            sudo apt install virtualbox-7.0
            sudo usermod -G vboxusers -a $USER
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
if [ "$installall" -eq 1 ]; then
    installVbox
else
echo
echo -e "${RED}█ ${ORANGE}Install virtualbox 7 ?${NOCOLOR}"
optionz=("Install virtualbox" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install virtualbox")
            echo -e "  \e[35m░▒▓█\033[0m Installing virtualbox 7..."
            installVbox
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
fi
sep
echo
echo
echo
progress "$script" 95





itemdisp "Cleaning files..."
echo
sudo rm -f common/packages_list.tmp
sudo apt clean
sudo apt autoremove -y
sep
echo
echo
echo
progress "$script" 100


alldone
exit 2
