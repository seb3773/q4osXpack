#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ conf file exist ?
if [ -e "common/conf.qapps.tmp" ]; then
rel_path="common/conf.qapps.tmp"
abs_path=$(realpath "$rel_path")
conffile=1
dcopRef=$(sudo kreadconfig --file "$abs_path" --group "Settings" --key "progressref")
kdicon="$script_directory/../common/Q4OSsebicon.png" 
helpdoc=0;installall=0
else
echo
echo "** No config file found."
echo "   This script is not designed to be run standalone,please run qxpack script from the parent folder."
echo
exit
fi

script="   Qapps script   "
#source common/resizecons
source common/begin
source common/progress

begin "$script" "conf" "$dcopRef"
qprogress () {
dcop "$dcopRef" setProgress $2
}


USER_HOME=$(eval echo ~${SUDO_USER})

#========== set subscripts perms ================================================================================
qprogress "$script" 0
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

dcop "$dcopRef" setLabel "Fetching latest version of the package list..."

konsole --nomenubar --nohist --notabbar --noframe --noscrollbar --vt_sz 56x24 -e common/apt_update.sh "$dcopRef" "apps" -- &
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
echo -e "    ${ORANGE}░▒▓█\033[0m Retrieve installed packages list...${NOCOLOR}"
echo
cd common
sudo ./pklist
cd ..
echo
qprogress "$script" 4

#============== Install Apps (required) ========================================================================
itemdisp "Installing GIT..."
dcop "$dcopRef" setLabel "Installing GIT..."
installApp "git" "git/stable"
qprogress "$script" 5

itemdisp "Installing 7zip..."
dcop "$dcopRef" setLabel "Installing 7zip..."
installApp "7z" "p7zip-full/stable"
qprogress "$script" 6


appspart=$(sudo kreadconfig --file "$abs_path" --group "Settings" --key "mode")
#appspart="Essential"
#or
#appspart="Extra"

if [ "$appspart" == "Essential" ]; then

## *****************************************************    Default apps ************************************************************************

#---------------------------------------Ark
instark=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Ark")


if [[ $instark -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Ark..."
itemdisp "Installing Ark..."
installApp "ark" "ark/stable"
fi
qprogress "$script" 10


#---------------------------------------Dolphin
instdolph=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Dolphin")


if [[ $instdolph -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Dolphin..."
itemdisp "Installing Dolphin..."
installApp "dolphin-trinity" "dolphin-trinity/"
fi
qprogress "$script" 15


#---------------------------------------system-config-printer
instsysprint=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "system-config-printer")

if [[ $instsysprint -eq 1 ]]; then
itemdisp "Installing system-config-printer..."
dcop "$dcopRef" setLabel "Installing system-config-printer..."
installApp "system-config-printer" "system-config-printer/stable"
fi
qprogress "$script" 20

#---------------------------------------flashfetch
instflashf=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "flashfetch")

if [[ $instflashf -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Flashfetch..."
itemdisp "Installing flashfetch"
cd apps
echo -e "${YELLOW}"
if [ "$osarch" = "amd64" ]; then
sudo tar -xf flashfetch.tar.xz -C /usr/bin/
fi
if [ "$osarch" = "i386" ]; then
sudo tar -xf flashfetch_32.tar.xz -C /usr/bin/
fi
if [ "$osarch" = "armhf" ]; then
sudo tar -xf flashfetch_arm.tar.xz -C /usr/bin/
fi
echo "flashfetch binary copied in /usr/bin/"
cd ..
echo -e "${NOCOLOR}"
#flashfetch
sep
echo
echo
echo
fi
qprogress "$script" 25


#---------------------------------------lx-taskmod
itemdisp "Installing lxtask-mod (simple lightweight taskmgr)"
dcop "$dcopRef" setLabel "Installing lxtask-mod..."
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
qprogress "$script" 30


#---------------------------------------bleachbit
instbleach=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "bleachbit")

if [[ $instbleach -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing bleachbit..."
itemdisp "Installing bleachbit..."
installApp "bleachbit" "bleachbit/stable"
fi
qprogress "$script" 35


#---------------------------------------vlc
instvlc=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "vlc")

if [[ $instvlc -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing vlc..."
itemdisp "Installing vlc..."
installApp "vlc" "vlc/stable"
fi
qprogress "$script" 40


#---------------------------------------console tools
instclit=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "console tools")

if [[ $instclit -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing console tools..."
itemdisp "Installing usefull console tools..."
installApp "duf" "duf/stable" 0
installApp "jdupes" "jdupes/stable"
fi
qprogress "$script" 45



#---------------------------------------Gwenview
instgwen=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Gwenview")

if [[ $instgwen -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Gwenview..."
echo -e "  \e[35m░▒▓█\033[0m Installing Gwenview..."
installApp "gwenview-trinity" "gwenview-trinity" 0
fi

qprogress "$script" 50

#---------------------------------------Kolourpaint
instkpaint=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Kolourpaint")

if [[ $instkpaint -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Kolourpaint..."
echo -e "  \e[35m░▒▓█\033[0m Installing Kolourpaint..."
installApp "kolourpaint-trinity" "kolourpaint-trinity" 0
fi

qprogress "$script" 55

#---------------------------------------KCharSelect
instkchar=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "KCharSelect")

if [[ $instkchar -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing KCharSelect..."
echo -e "  \e[35m░▒▓█\033[0m Installing KCharSelect..."
installApp "kcharselect-trinity" "kcharselect-trinity" 0
fi

qprogress "$script" 60

#---------------------------------------Ksnapshot
instksnap=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Ksnapshot")

if [[ $instksnap -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Ksnapshot..."
echo -e " \e[35m░▒▓█\033[0m Installing Ksnapshot..."
installApp "ksnapshot-trinity" "ksnapshot-trinity" 0
fi

qprogress "$script" 65

#---------------------------------------Knotes
instknot=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Knotes")

if [[ $instknot -eq 1 ]]; then
dcop "$dcopRef" setLabel "Installing Knotes..."
echo -e " \e[35m░▒▓█\033[0m Installing Knotes..."
installApp "knotes-trinity" "knotes-trinity" 0
fi
qprogress "$script" 70

#---------------------------------------Kcron
instkcro=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Kcron")

if [[ $instkcro -eq 1 ]]; then
echo -e " \e[35m░▒▓█\033[0m Installing Kcron..."
dcop "$dcopRef" setLabel "Installing Kcron..."
installApp "kcron-trinity" "kcron-trinity" 0
fi
qprogress "$script" 75

#---------------------------------------kdirstat
instkdirs=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "kdirstat")

if [[ $instkdirs -eq 1 ]]; then
echo -e " \e[35m░▒▓█\033[0m Installing kdirstat..."
dcop "$dcopRef" setLabel "Installing kdirstat..."
installApp "kdirstat-trinity" "kdirstat-trinity" 0
fi
qprogress "$script" 80

#---------------------------------------kpdf
instkpd=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "kpdf")

if [[ $instkpd -eq 1 ]]; then
echo -e " \e[35m░▒▓█\033[0m Installing kpdf..."
dcop "$dcopRef" setLabel "Installing kpdf..."
installApp "kpdf-trinity" "kpdf-trinity"
fi
qprogress "$script" 85

#---------------------------------------Strawberry
inststraw=$(sudo kreadconfig --file "$abs_path" --group "Default Apps" --key "Strawberry")

if [[ $inststraw -eq 1 ]]; then
itemdisp "Installing Strawberry..."
dcop "$dcopRef" setLabel "Installing Strawberry..."
installApp "strawberry" "strawberry/stable"
mkdir -p $USER_HOME/.configtde/strawberry/
tar -xzf theme/strawberry.conf.tar.gz -C $USER_HOME/.configtde/strawberry/
echo
fi

qprogress "$script" 90


## *****************************************************    End Default apps ************************************************************************



else





#============== Install Apps (interactive) ======================================================================


#---------------------------------------qBittorent
instqbit=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "qBittorent")

if [[ $instqbit -eq 1 ]]; then

itemdisp "Installing qbittorent"
dcop "$dcopRef" setLabel "Installing qbittorrent..."
installApp "qbittorrent" "qbittorrent/stable"
qprogress "$script" 10

fi


#---------------------------------------Guvcview
instguc=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Guvcview")

if [[ $instguc -eq 1 ]]; then

itemdisp "Installing guvcview"
dcop "$dcopRef" setLabel "Installing guvcview..."
installApp "guvcview" "guvcview/stable"

fi
qprogress "$script" 15



#---------------------------------------SMPLayer/MPV
instsmp=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "SMPlayer")

if [[ $instsmp -eq 1 ]]; then

itemdisp "Installing SMPlayer/MPV"
dcop "$dcopRef" setLabel "Installing SMPlayer/MPV..."
    installApp "smplayer" "smplayer/"
mkdir -p "$USER_HOME/.configtde/smplayer/"
tar -xzf apps/smplayer.conf.tar.gz -C "$USER_HOME/.configtde/smplayer/"
sudo chown -R $USER: "$USER_HOME/.configtde/smplayer/smplayer.ini"

fi
qprogress "$script" 20



#---------------------------------------Spotify
instspot=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Spotify")

if [[ $instspot -eq 1 ]]; then

if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing spotify"
dcop "$dcopRef" setLabel "Installing spotify..."


            if ! isinstalled "spotify-client/stable" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            curl -fsSL https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/spotify.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
            sudo apt-get update
            qprogress "$script" 35
            sudo apt-get install -y spotify-client
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi

fi
sep
echo
echo
echo

fi

qprogress "$script" 25



#---------------------------------------Microsoft Edge Browser
instedge=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Microsoft Edge Browser")

if [[ $instedge -eq 1 ]]; then


if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing Microsoft Edge Browser"
dcop "$dcopRef" setLabel "Installing Microsoft Edge Browser..."
            if ! isinstalled "microsoft-edge-stable/stable" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            sudo apt install software-properties-common apt-transport-https ca-certificates 
            curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
            echo 'deb [signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
            sudo apt update
            qprogress "$script" 35
            sudo apt install microsoft-edge-stable
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
fi
sep
echo
echo
echo
fi

qprogress "$script" 30



#---------------------------------------Gparted
instgpart=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Gparted")

if [[ $instgpart -eq 1 ]]; then

itemdisp "Installing gparted"
dcop "$dcopRef" setLabel "Installing gparted..."
installApp "gparted" "gparted/stable"

fi
qprogress "$script" 35




#---------------------------------------Stacer
inststac=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Stacer")

if [[ $inststac -eq 1 ]]; then

itemdisp "Installing Stacer"
dcop "$dcopRef" setLabel "Installing Stacer..."
installApp "stacer" "stacer/stable"

fi
qprogress "$script" 40



#---------------------------------------S4 Snapshot
instssnap=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "S4 Snapshot")

if [[ $instssnap -eq 1 ]]; then

itemdisp "Installing S4 Snapshot"
dcop "$dcopRef" setLabel "Installing S4 Snapshot..."
            echo -e "${YELLOW}"
            cd apps
            sudo qsinst setup_q4os-s4-snapshot_4.1-a1_amd64.qsi
            cd ..
            echo -e "${NOCOLOR}"
sep
echo
echo
echo
fi 
qprogress "$script" 45




#---------------------------------------Web app manager
instwapp=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Web app manager")

if [[ $instwapp -eq 1 ]]; then

itemdisp "Installing Web app manager"
dcop "$dcopRef" setLabel "Installing Web app manager..."
           if ! isinstalled "webapp-manager/" "common/packages_list.tmp"; then
            echo -e "  \e[35m░▒▓█\033[0m Installing Web app manager..."
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

fi
qprogress "$script" 48





#---------------------------------------Peazip
instpeaz=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Peazip")

if [[ $instpeaz -eq 1 ]]; then

itemdisp "Installing Peazip"
dcop "$dcopRef" setLabel "Installing Peazip..."
           if ! isinstalled "peazip/" "common/packages_list.tmp"; then
            echo -e "  \e[35m░▒▓█\033[0m Installing Peazip..."
            echo -e "${YELLOW}"
            sudo wget https://github.com/peazip/PeaZip/releases/download/9.7.1/peazip_9.7.1.LINUX.GTK2-1_amd64.deb
            sudo apt install -y ./peazip_9.7.1.LINUX.GTK2-1_amd64.deb
            sudo rm -f ./peazip_9.7.1.LINUX.GTK2-1_amd64.deb
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi

fi
qprogress "$script" 52






#---------------------------------------Pinta
instpint=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Pinta")

if [[ $instpint -eq 1 ]]; then

itemdisp "Installing Pinta"
dcop "$dcopRef" setLabel "Installing Pinta..."

           if ! isinstalled "pinta/" "common/packages_list.tmp"; then
            echo -e "  \e[35m░▒▓█\033[0m Installing Pinta..."
            echo -e "${YELLOW}"
cd apps
sudo apt install -y ./pinta_1.7.1_all.deb
cd ..
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi


fi
qprogress "$script" 55




#---------------------------------------Remmina
instremm=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Remmina")

if [[ $instremm -eq 1 ]]; then

itemdisp "Installing remmina"
dcop "$dcopRef" setLabel "Installing Remmina..."
    installApp "remmina" "remmina/stable"

fi
qprogress "$script" 58



#---------------------------------------Rustdesk
instrdesk=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Rustdesk")

if [[ instrdesk -eq 1 ]]; then

itemdisp "Installing Rustdesk"
dcop "$dcopRef" setLabel "Installing Rustdesk..."
sudo wget https://github.com/rustdesk/rustdesk/releases/download/1.2.3-2/rustdesk-1.2.3-2-x86_64.deb
sudo apt install -y ./rustdesk-1.2.3-2-x86_64.deb
sudo rm -f ./rustdesk-1.2.3-2-x86_64.deb

fi
qprogress "$script" 62


#---------------------------------------Free Office
instfreo=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Free Office")

if [[ $instfreo -eq 1 ]]; then

itemdisp "Installing free office"
dcop "$dcopRef" setLabel "Installing Free Office..."
           if ! isinstalled "softmaker-freeoffice-" "common/packages_list.tmp"; then
            echo -e "  \e[35m░▒▓█\033[0m Installing free office..."
            echo -e "${YELLOW}"
            mkdir -p /etc/apt/keyrings
            sudo bash -c 'wget -qO- https://shop.softmaker.com/repo/linux-repo-public.key | gpg --dearmor > /etc/apt/keyrings/softmaker.gpg'
            sudo bash -c 'echo "deb [signed-by=/etc/apt/keyrings/softmaker.gpg] https://shop.softmaker.com/repo/apt stable non-free" > /etc/apt/sources.list.d/softmaker.list'
            sudo apt update
            qprogress "$script" 55
            sudo apt install -y softmaker-freeoffice-2021
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
sep
echo
echo
echo
fi
qprogress "$script" 65





#---------------------------------------OnlyOffice
instoof=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "OnlyOffice")

if [[ $instoof -eq 1 ]]; then

itemdisp "Installing OnlyOffice"
dcop "$dcopRef" setLabel "Installing Only Office..."
           if ! isinstalled "onlyoffice-desktopeditors" "common/packages_list.tmp"; then
            echo -e "  \e[35m░▒▓█\033[0m Installing OnlyOffice..."
            echo -e "${YELLOW}"
            sudo wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
            qprogress "$script" 58
            sudo apt install -y ./onlyoffice-desktopeditors_amd64.deb
            sudo rm -f ./onlyoffice-desktopeditors_amd64.deb
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
sep
echo
echo
echo

fi
qprogress "$script" 70




#---------------------------------------Bpytop
instbpy=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Bpytop")

if [[ $instbpy -eq 1 ]]; then

itemdisp "Installing bpytop"
dcop "$dcopRef" setLabel "Installing bpytop..."
installApp "bpytop" "bpytop/stable"
sep
echo
echo
echo

fi
qprogress "$script" 72



#---------------------------------------Virtualbox 7
instvbo=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Virtualbox 7")

if [[ $instvbo -eq 1 ]]; then

if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing virtualbox 7"
dcop "$dcopRef" setLabel "Installing Virtualbox 7..."

            if ! isinstalled "virtualbox-7.0/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
            sudo apt update
            qprogress "$script" 65
            sudo apt install -y virtualbox-7.0
            sudo usermod -G vboxusers -a $USER
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
sep
echo
echo
echo

fi
fi
qprogress "$script" 75





#---------------------------------------Qtscrcpy
instscrcpy=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Qtscrcpy")

if [[ $instscrcpy -eq 1 ]]; then

if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing Qtscrcpy"
dcop "$dcopRef" setLabel "Installing Qtscrcpy..."
            if [ ! -e "$USER_HOME/qtscrcpy/QtScrcpy" ]; then
            echo -e "${YELLOW}"
            cd apps
            sudo apt install -y libqt5multimedia5
            qprogress "$script" 72
            sudo tar -xf qtscrcpy.tar.xz -C $USER_HOME/
            sudo chown -R $USER: "$USER_HOME/qtscrcpy"
            sudo mkdir -p $USER_HOME/.local/bin
            sudo ln -s $USER_HOME/qtscrcpy/QtScrcpy $USER_HOME/.local/bin/QtScrcpy
            sudo mv $USER_HOME/qtscrcpy/qtscrcpy.desktop /usr/share/applications/qtscrcpy.desktop
            cd ..
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
sep
echo
echo
echo
fi
fi
qprogress "$script" 80




#---------------------------------------WineHQ
instwinehq=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "WineHQ")

if [[ instwinehq -eq 1 ]]; then

itemdisp "Installing WineHQ"
dcop "$dcopRef" setLabel "Installing WineHQ..."
            if ! isinstalled "winehq-stable/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            sudo dpkg --add-architecture i386
            sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
            sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
            sudo apt update
            sudo apt install -y --install-recommends winehq-stable
            #make sure wine can create icons in "$USER_HOME/.local/share/icons"
            sudo chown -R $USER: "$USER_HOME/.local/share/icons"
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
sep
echo
echo
echo
fi

qprogress "$script" 82





#---------------------------------------Angry IP scanner
instipsc=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Angry IP scanner")

if [[ $instipsc -eq 1 ]]; then

if [ ! "$osarch" = "armhf" ]; then

itemdisp "Installing Angry IP scanner"
dcop "$dcopRef" setLabel "Installing Angry IP scanner..."

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


fi

fi
qprogress "$script" 85





#---------------------------------------Kdiskmark
instkdiskm=$(sudo kreadconfig --file "$abs_path" --group "Extra Apps" --key "Kdiskmark")

if [[ $instkdiskm -eq 1 ]]; then

if ( getconf LONG_BIT | grep -q 64 ); then

itemdisp "Installing Kdiskmark"
dcop "$dcopRef" setLabel "Installing Kdiskmark..."
            if ! isinstalled "kdiskmark/" "common/packages_list.tmp"; then
            echo -e "${YELLOW}"
            cd apps
            sudo apt install -y fio
            qprogress "$script" 83
            sudo apt install -y ./kdiskmark_3.1.4-debian_amd64.deb
            sudo sed -i 's/^Exec=.*/Exec=tdesudo kdiskmark/' /usr/share/applications/kdiskmark.desktop
            sudo sed -i 's/^Exec=.*/Exec=tdesudo kdiskmark/' "$USER_HOME/KDiskMark/data/kdiskmark.desktop"
            cd ..
            echo -e "${NOCOLOR}"
            else
            echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
            fi
sep
echo
echo
echo
fi
fi
qprogress "$script" 90




##---- end extra apps part
fi
##-----------------common part


#---------------------------------------
dcop "$dcopRef" setLabel "Cleaning files..."
itemdisp "Cleaning files..."
echo
sudo rm -f common/packages_list.tmp
sudo apt clean
qprogress "$script" 95
sudo apt autoremove -y
qprogress "$script" 98
sep
echo
echo
echo
qprogress "$script" 100

#alldone
dcop "$dcopRef" close
sudo rm -f "$abs_path"
kdialog --title "q4osXpack » qapps " --icon "$kdicon" --msgbox "⠀⠀⠀Installation Completed.⠀⠀⠀⠀⠀⠀"

exit 2
