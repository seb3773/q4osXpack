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
USER_HOME=$(eval echo ~${SUDO_USER})
#================================================================================================================


#========== set subscripts perms ================================================================================
progress "$script" 0
sudo chmod +x common/pklist

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

osarch=$(dpkg --print-architecture)

itemdisp "Fetching latest version of the package list..."
sudo apt update > /dev/null 2>&1
aptup=1;for (( i=5; i>0; i--)); do
printf "\rRunning apt upgrade in $i seconds.  Hit any key to cancel..."
read -s -n 1 -t 1 key
if [ $? -eq 0 ];then aptup=0;break;fi;done
if [[ $aptup -eq 1 ]];then echo;echo "processing..."
sudo apt upgrade -y
else echo;echo "canceled.";fi
sep
echo
echo
echo

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
progress "$script" 5



itemdisp "Installing Dolphin..."
installApp "dolphin-trinity" "dolphin-trinity/"
progress "$script" 10


itemdisp "Installing system-config-printer..."
installApp "system-config-printer" "system-config-printer/stable"
progress "$script" 15



itemdisp "Installing flashfetch"
cd apps
echo -e "${YELLOW}"
if [ "$osarch" = "amd64" ]; then
sudo tar -xzf flashfetch.tar.gz -C /usr/bin/
fi
if [ "$osarch" = "i386" ]; then
sudo tar -xzf flashfetch_32.tar.gz -C /usr/bin/
fi
if [ "$osarch" = "armhf" ]; then
sudo tar -xzf flashfetch_arm.tar.gz -C /usr/bin/
fi
echo "flashfetch binary copied in /usr/bin/"
cd ..
echo -e "${NOCOLOR}"
#flashfetch
sep
echo
echo
echo
progress "$script" 20





itemdisp "Installing lxtask-mod (simple lightweight taskmgr)"
if ! isinstalled "lxtask-mod/now" "common/packages_list.tmp"; then
cd apps
echo -e "${YELLOW}"
if [ "$osarch" = "armhf" ]; then
sudo apt install -y ./lxtask-mod_armhf.deb
else
if ( getconf LONG_BIT | grep -q 64 ); then
sudo apt install -y ./lxtask-mod.deb
else
sudo apt install -y ./lxtask-mod_i386.deb
fi
fi
cd ..
echo -e "${NOCOLOR}"
sep
echo
echo
echo
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
progress "$script" 25

itemdisp "Installing Stacer..."
installApp "stacer" "stacer/stable"
progress "$script" 30

itemdisp "Installing bleachbit..."
installApp "bleachbit" "bleachbit/stable"
progress "$script" 35

itemdisp "Installing vlc..."
installApp "vlc" "vlc/stable"
progress "$script" 40

itemdisp "Installing usefull console tools..."
installApp "duf" "duf/stable" 0
installApp "jdupes" "jdupes/stable"
progress "$script" 45

#classics tools, may be already installed with desktop version
itemdisp "Installing Gwenview,Kolourpaint,KCharSelect,Ksnapshot,knotes,kcron, kdirstat, kpdf..."
echo
echo -e "  \e[35m░▒▓█\033[0m Installing Gwenview..."
installApp "gwenview-trinity" "gwenview-trinity" 0
echo -e "  \e[35m░▒▓█\033[0m Installing Kolourpaint..."
installApp "kolourpaint-trinity" "kolourpaint-trinity" 0
echo -e "  \e[35m░▒▓█\033[0m Installing KCharSelect..."
installApp "kcharselect-trinity" "kcharselect-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing Ksnapshot..."
installApp "ksnapshot-trinity" "ksnapshot-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing Knotes..."
installApp "knotes-trinity" "knotes-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing Kcron..."
installApp "kcron-trinity" "kcron-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing kdirstat..."
installApp "kdirstat-trinity" "kdirstat-trinity" 0
echo -e " \e[35m░▒▓█\033[0m Installing kpdf..."
installApp "kpdf-trinity" "kpdf-trinity"
progress "$script" 55

itemdisp "Installing Strawberry..."
installApp "strawberry" "strawberry/stable"
mkdir -p $USER_HOME/.configtde/strawberry/
tar -xzf theme/strawberry.conf.tar.gz -C $USER_HOME/.configtde/strawberry/
echo

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



itemdisp "Installing guvcview"
if [ "$installall" -eq 1 ]; then
    installApp "guvcview" "guvcview/stable"
else
echo
echo -e "${RED}█ ${ORANGE}Install guvcview ?${NOCOLOR}"
optionz=("Install guvcview" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install guvcview")
            echo -e "  \e[35m░▒▓█\033[0m Installing guvcview..."
            installApp "guvcview" "guvcview/stable"
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




if ( getconf LONG_BIT | grep -q 64 ); then
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
fi







if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing Microsoft Edge Browser"
installEdge () {
            if ! isinstalled "microsoft-edge-stable/stable" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            sudo apt install software-properties-common apt-transport-https ca-certificates 
            curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
            echo 'deb [signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
            sudo apt update
            sudo apt install microsoft-edge-stable
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
if [ "$installall" -eq 1 ]; then
    installEdge
else
echo
echo -e "${RED}█ ${ORANGE}Install Edge Browser ?${NOCOLOR}"
optionz=("Install Edge" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install Edge")
            echo -e "  \e[35m░▒▓█\033[0m Installing Microsoft Edge Browser..."
            installEdge
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
fi




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







itemdisp "Installing Web app manager"
function installwebappman() {
           if ! isinstalled "webapp-manager/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
cd apps
sudo apt install -y ./webapp-manager_1.3.4_all.deb
cd ..
#deleting redundant entry
sudo rm -f /usr/share/applications/kde4/webapp-manager.desktop
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
if [ "$installall" -eq 1 ]; then
installwebappman
else
echo
echo -e "${RED}█ ${ORANGE}Install Web app manager ?${NOCOLOR}"
optionz=("Install web app manager" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install web app manager")
            echo -e "  \e[35m░▒▓█\033[0m Installing Web app manager..."
            installwebappman
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


if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing virtualbox 7"
#spotify
installVbox () {
            if ! isinstalled "virtualbox-7.0/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
            sudo apt update
            sudo apt install -y virtualbox-7.0
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
fi


if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing Qtscrcpy"
installQtscrcpy () {
            if [ ! -e "$USER_HOME/qtscrcpy/QtScrcpy" ]; then
            echo -e "${YELLOW}"
            cd apps
            sudo apt install libqt5multimedia5
            sudo tar -xzf qtscrcpy.tar.gz -C $USER_HOME/
            sudo ln -s $USER_HOME/qtscrcpy/QtScrcpy $USER_HOME/.local/bin/QtScrcpy
            sudo mv $USER_HOME/qtscrcpy/qtscrcpy.desktop /usr/share/applications/qtscrcpy.desktop
            cd ..
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
if [ "$installall" -eq 1 ]; then
    installQtscrcpy
else
echo
echo -e "${RED}█ ${ORANGE}Install Qtscrcpy ? (android phone screen mirroring+control)${NOCOLOR}"
optionz=("Install Qtscrcpy" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install Qtscrcpy")
            echo -e "  \e[35m░▒▓█\033[0m Installing Qtscrcpy..."
            installQtscrcpy
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
fi


if [ ! "$osarch" = "armhf" ]; then
itemdisp "Installing Angry IP sanner"
function installangryip() {
           if ! isinstalled "ipscan/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
cd apps
if ( getconf LONG_BIT | grep -q 64 ); then
sudo apt install -y ./ipscan_3.9.1_amd64.deb
else
sudo apt install -y ./ipscan_3.9.1_all.deb
fi
cd ..
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
}
if [ "$installall" -eq 1 ]; then
installangryip
else
echo
echo -e "${RED}█ ${ORANGE}Install Angry IP sanner ?${NOCOLOR}"
optionz=("Install angryip" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install angryip")
            echo -e "  \e[35m░▒▓█\033[0m Installing Angry IP sanner..."
            installangryip
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
fi
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
