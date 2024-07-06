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
helpdoc=0;installall=0

defaultapps=(
"Dolphin" "Dolphin                                        ••• [file manager]"
"Ark" "Ark                                               ••• [archives manager]"
"system-config-printer" "system-config-printer                ••• [printer manager]"
"flashfetch" "flashfetch                                    ••• [cli system info]"
"bleachbit" "bleachbit                                     ••• [cleaner]"
"vlc" "vlc                                                ••• [multimedia player]"
"Strawberry" "Strawberry                                  ••• [music player]"
"console tools" "console tools                              ••• [usefull CLI tools]"
"Gwenview" "Gwenview                                   ••• [image viewer]"
"Kolourpaint" "Kolourpaint                                 ••• [drawing app ala ms paint]"
"KCharSelect" "KCharSelect                                ••• [char selector]"
"Ksnapshot" "Ksnapshot                                  ••• [screen snapshot]"
"Knotes" "Knotes                                        ••• [sticky notes]"
"Kcron" "Kcron                                          ••• [tasks scheduler]"
"lxtask-mod" "Lxtask-mod                                ••• [lightweight  taskmanager]"
"kdirstat" "kdirstat                                       ••• [dirs sizes statistics]"
"kpdf" "kpdf                                            ••• [pdf viewer]"
)
nbrDefault=$(( ${#defaultapps[@]} / 2 ))

declare -a extraapps
extraapps+=("qBittorrent" "qBittorrent                                         ••• [torrents client]")
extraapps+=("Guvcview" "Guvcview                                            ••• [webcam tool]")
if [ "$osarch" = "amd64" ]; then
extraapps+=("Spotify" "Spotify                                                ••• [spotify official app]")
fi
extraapps+=("spotify-qt" "spotify-qt                                           ••• [lightweight spotify app]")
extraapps+=("spotify-tui" "spotify-tui                                          ••• [lightweight spotify CLI app]")
extraapps+=("ncspot" "ncspot                                                ••• [lightweight spotify CLI ncurse app]")
extraapps+=("spotify-player" "spotify-player                                     ••• [lightweight spotify CLI app]")
extraapps+=("spotifyd" "spotifyd                                              ••• [spotify daemon]")
if [ "$osarch" = "amd64" ]; then
extraapps+=("deezer" "Deezer                                                ••• [deezer (unofficial) app]")
fi
extraapps+=("musikcube" "musikcube                                          ••• [lightweight musicplayer CLI app]")
extraapps+=("SMPlayer" "SMPlayer/MPV                                   ••• [multimedia player]")
extraapps+=("media-downloader" "media-downloader                            ••• [various medias downloader]")
extraapps+=("down_on_spot" "DownOnSpot                                     ••• [spotify music downloader (CLI) ]")
if [ ! "$osarch" = "armhf" ]; then
extraapps+=("Pinta" "Pinta                                                   ••• [paint.net like]")
fi
if [ "$osarch" = "amd64" ]; then
extraapps+=("Microsoft Edge Browser" "Microsoft Edge Browser                    ••• [internet browser]")
fi
extraapps+=("Web app manager" "Web app manager                            ••• [webapp manager]")
if [ "$osarch" = "amd64" ]; then
extraapps+=("Free Office" "Free Office                                         ••• [office suite]")
fi
if [ "$osarch" = "amd64" ]; then
extraapps+=("OnlyOffice" "OnlyOffice                                          ••• [office suite]")
fi
if [ "$osarch" = "amd64" ]; then
extraapps+=("Peazip" "Peazip                                                ••• [archives manager]")
fi
if [ "$osarch" = "amd64" ]; then
extraapps+=("Qtscrcpy" "Qtscrcpy                                            ••• [android phone manager]")
fi
extraapps+=("Gparted" "Gparted                                             ••• [partitions manager]")
extraapps+=("Stacer" "Stacer                                                ••• [system tools/task manager]")
if [ "$osarch" = "amd64" ]; then
extraapps+=("S4 Snapshot" "S4 Snapshot                                      ••• [backup/imaging tool]")
fi
extraapps+=("Remmina" "Remmina                                           ••• [rdp/vnc/ssh remote desktop client]")
if [ ! "$osarch" = "armhf" ]; then
extraapps+=("Rustdesk" "Rustdesk                                            ••• [teamviewer like written in rust]")
fi
extraapps+=("Bpytop" "Bpytop                                              ••• [task manager (CLI) ]")
extraapps+=("Bottom" "Bottom                                              ••• [task manager in rust (CLI) ]")
if [ "$osarch" = "amd64" ]; then
extraapps+=("Virtualbox 7" "Virtualbox 7                                       ••• [virtualization tool]")
fi
if [ "$osarch" = "amd64" ]; then
extraapps+=("Kdiskmark" "Kdiskmark                                          ••• [disk speed benchmark tool]")
fi
if [ ! "$osarch" = "armhf" ]; then
extraapps+=("Angry IP scanner" "Angry IP scanner                               ••• [ip scanner]")
fi
extraapps+=("Filezilla" "Filezilla                                              ••• [ftp client]")
extraapps+=("Rclone" "Rclone                                               ••• [rsync for cloud - version 1.66 (CLI) ]")
extraapps+=("rclone-browser" "Rclone Browser                                 ••• [cloud file manager for rclone ]")
if [ ! "$osarch" = "armhf" ]; then
extraapps+=("WineHQ" "Wine HQ                                           ••• [run windows programs]")
fi
extraapps+=("Kweather" "Kweather                                          ••• [weather applet for kicker]")

kdtitle="q4osXpack"
kdcaption="qapps"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
qapps1 () {
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack Apps ⏺</strong></font><br><br>
<font style='color:#1a7c17'><em><strong>Default applications</strong></em></font><br><br>
Most of them are usefull for the win10 and/or osx theme,<br>
but you can choose to not install some apps.
<br><br><em>*Please note that if some apps are already installed,<br>
unselecting them will not uninstall them.</em><br>
─────────────────────<br>
<font style='color:#828282'>►</font> <strong>Unselect</strong> the apps you <strong>don't want to install</strong>:<br>
<font style='color:#828282'><em>(or hit cancel to quit)</em></font><br>
"
kcmd="kdialog --icon \"$kdicon\" --title \"$kdtitle\" --caption \"$kdcaption\" --geometry $(centerk 550 650) --checklist \"$kdtext\" "
for ((i = 0; i < ${#defaultapps[@]}; i+=2)); do
    kcmd+="\"${defaultapps[i]}\" \"${defaultapps[i+1]}\" on "
done
eval "$kcmd --separate-output"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $? -eq 1 ];then
echo "Canceled.";return 1
fi
}


qapps2() {
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack Apps ⏺</strong></font><br><br>
<font style='color:#1a7c17'><em><strong>Additional applications</strong></em></font><br><br>
─────────────────────<br>
<font style='color:#828282'>►</font> <strong>Select</strong> the extra apps you want to <strong>install</strong>:<br>
<font style='color:#828282'><em>(or hit cancel to quit)</em></font><br>
"
kcmd="kdialog --icon \"$kdicon\" --title \"$kdtitle\" --caption \"$kdcaption\" --geometry $(centerk 550 650) --checklist \"$kdtext\" "
for ((i = 0; i < ${#extraapps[@]}; i+=2)); do
    kcmd+="\"${extraapps[i]}\" \"${extraapps[i+1]}\" off "
done
eval "$kcmd --separate-output"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $? -eq 1 ];then
echo "Canceled.";return 1
fi
}

qapps3() {
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack Apps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>$msgDef</em><br>
═══════════════════════════<br><br>
<font style='color:#828282'>►</font> Proceed with these settings ?<br>
<font style='color:#828282'><em>(or hit cancel to return)</em></font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --warningcontinuecancel "$kdtext"
}


################################################################################################
while true; do

if [ $1 -eq 1 ]
then
Applist1=$(qapps1)
if [ "$Applist1" = "Canceled." ]; then echo "Canceled by user.";exit;fi
IFS=$'\n'
count1=$(echo "$Applist1" | wc -l)
nbrdef=$((nbrDefault - count1))
app_names=()
for ((i = 0; i < ${#defaultapps[@]}; i+=2)); do
app_name="${defaultapps[i]}"
app_names+=("$app_name")
done
not_selected_apps=()
for app_name in "${app_names[@]}"; do
if ! grep -q "$app_name" <<< "$Applist1"; then
not_selected_apps+=("$app_name")
fi
done
not_selected_apps_str=$(printf "%s\n" "${not_selected_apps[@]}")

if [ $nbrdef -eq 0 ]; then
msgDef="►install all essential apps"
else
#test if  $nbrdef = nbrDefault , dans ce cas --> nothing to install -> break
msgDef="►don't install $nbrdef of the essential apps ($not_selected_apps_str)"
fi



else
Applist2=$(qapps2)
if [ "$Applist2" = "Canceled." ];  then echo "Canceled by user.";exit;fi
IFS=$'\n'
nbrextra=$(echo "$Applist2" | wc -l)
if [ $nbrextra -eq 0 ]; then
msgDef2="►don't install any extra apps" #nothing to install -> break
else
msgDef="►install $nbrextra extra apps ($Applist2)"
fi
fi



setok=$(qapps3 $1)
if [ $? -eq 0 ]; then
break
fi

done

tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Root authentification  needed to continue"
oksu=$(sudo -n echo 1 2>&1 | grep 1);if [[ ! $oksu -eq 1 ]];then kdialog --title "q4osXpack » qapps " --icon "$kdicon" --msgbox "Can't continue without root authentification.";exit;fi

dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 300) --progressbar "Initializing ..." 100)


script="   Qapps script   "
source common/begin
source common/progress

begin "$script"
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



itemdisp "Fetching latest version of the package list..."
dcop "$dcopRef" setLabel "Fetching latest version of the package list..."

konsole --nomenubar --nohist --notabbar --noframe --noscrollbar --vt_sz 88x26 -e common/apt_update.sh "$dcopRef" "apps" -- &
kid=konsole-$!
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -ne 1 ]]
do
sleep 0.1
session_count=$(dcop $kid konsole sessionCount) 2>/dev/null
done
dcop $kid konsole-mainwindow#1 move 5 5
dcop $kid konsole-mainwindow#1 lower
session_count=$(dcop $kid konsole sessionCount 2>/dev/null)
while [[ $session_count -eq 1 ]]
do
sleep 1
session_count=$(dcop $kid konsole sessionCount) 2>/dev/null
done

sep
echo
echo
echo

qprogress "$script" 3



#========== retrieve packages list ==============================================================================
dcop "$dcopRef" setLabel "Retrieve installed packages list..."
echo -e "    ${ORANGE}░▒▓█ Retrieve installed packages list...${NOCOLOR}"
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


#=================================================================================================================

if [[ $1 -eq 1 ]]; then






## *****************************************************    Default apps ************************************************************************

#---------------------------------------Ark
if echo $Applist1 | grep -q "Ark"; then
dcop "$dcopRef" setLabel "Installing Ark..."
itemdisp "Installing Ark..."
installApp "ark" "ark/stable"
fi
qprogress "$script" 10


#---------------------------------------Dolphin
if echo $Applist1 | grep -q "Dolphin"; then
dcop "$dcopRef" setLabel "Installing Dolphin..."
itemdisp "Installing Dolphin..."
installApp "dolphin-trinity" "dolphin-trinity/"
fi
qprogress "$script" 15


#---------------------------------------system-config-printer
if echo $Applist1 | grep -q "system-config-printer"; then
itemdisp "Installing system-config-printer..."
dcop "$dcopRef" setLabel "Installing system-config-printer..."
installApp "system-config-printer" "system-config-printer/stable"
fi
qprogress "$script" 20



#---------------------------------------flashfetch
if echo $Applist1 | grep -q "flashfetch"; then
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
sep
echo
echo
echo
fi
qprogress "$script" 25



#---------------------------------------lx-taskmod
if echo $Applist1 | grep -q "lxtask-mod"; then
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

fi
qprogress "$script" 30



#---------------------------------------bleachbit
if echo $Applist1 | grep -q "bleachbit"; then
dcop "$dcopRef" setLabel "Installing bleachbit..."
itemdisp "Installing bleachbit..."
installApp "bleachbit" "bleachbit/stable"
fi
qprogress "$script" 35


#---------------------------------------vlc
if echo $Applist1 | grep -q "vlc"; then
dcop "$dcopRef" setLabel "Installing vlc..."
itemdisp "Installing vlc..."
installApp "vlc" "vlc/stable"
fi
qprogress "$script" 40


#---------------------------------------console tools
if echo $Applist1 | grep -q "console tools"; then
dcop "$dcopRef" setLabel "Installing console tools..."
itemdisp "Installing usefull console tools..."
installApp "duf" "duf/stable" 0
installApp "jdupes" "jdupes/stable"
fi
qprogress "$script" 45



#---------------------------------------Gwenview
if echo $Applist1 | grep -q "Gwenview"; then
dcop "$dcopRef" setLabel "Installing Gwenview..."
echo -e "  \e[35m░▒▓█ Installing Gwenview..."
installApp "gwenview-trinity" "gwenview-trinity" 0
fi

qprogress "$script" 50


#---------------------------------------Kolourpaint
if echo $Applist1 | grep -q "Kolourpaint"; then
dcop "$dcopRef" setLabel "Installing Kolourpaint..."
echo -e "  \e[35m░▒▓█ Installing Kolourpaint..."
installApp "kolourpaint-trinity" "kolourpaint-trinity" 0
fi

qprogress "$script" 55

#---------------------------------------KCharSelect
if echo $Applist1 | grep -q "KCharSelect"; then
dcop "$dcopRef" setLabel "Installing KCharSelect..."
echo -e "  \e[35m░▒▓█ Installing KCharSelect..."
installApp "kcharselect-trinity" "kcharselect-trinity" 0
fi

qprogress "$script" 60

#---------------------------------------Ksnapshot
if echo $Applist1 | grep -q "Ksnapshot"; then
dcop "$dcopRef" setLabel "Installing Ksnapshot..."
echo -e " \e[35m░▒▓█ Installing Ksnapshot..."
installApp "ksnapshot-trinity" "ksnapshot-trinity" 0
fi

qprogress "$script" 65

#---------------------------------------Knotes
if echo $Applist1 | grep -q "Knotes"; then
dcop "$dcopRef" setLabel "Installing Knotes..."
echo -e " \e[35m░▒▓█ Installing Knotes..."
installApp "knotes-trinity" "knotes-trinity" 0
fi
qprogress "$script" 70

#---------------------------------------Kcron
if echo $Applist1 | grep -q "Kcron"; then
echo -e " \e[35m░▒▓█ Installing Kcron..."
dcop "$dcopRef" setLabel "Installing Kcron..."
installApp "kcron-trinity" "kcron-trinity" 0
fi
qprogress "$script" 75

#---------------------------------------kdirstat
if echo $Applist1 | grep -q "kdirstat"; then
echo -e " \e[35m░▒▓█ Installing kdirstat..."
dcop "$dcopRef" setLabel "Installing kdirstat..."
installApp "kdirstat-trinity" "kdirstat-trinity" 0
fi
qprogress "$script" 80

#---------------------------------------kpdf
if echo $Applist1 | grep -q "kpdf"; then
echo -e " \e[35m░▒▓█ Installing kpdf..."
dcop "$dcopRef" setLabel "Installing kpdf..."
installApp "kpdf-trinity" "kpdf-trinity"
fi
qprogress "$script" 85

#---------------------------------------Strawberry
if echo $Applist1 | grep -q "Strawberry"; then
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





#********************************* Install Extra Apps *************************************************************************************


#---------------------------------------qBittorent
if echo $Applist2 | grep -q "qBittorent"; then
itemdisp "Installing qbittorent"
dcop "$dcopRef" setLabel "Installing qbittorrent..."
installApp "qbittorrent" "qbittorrent/stable"
qprogress "$script" 10

fi


#---------------------------------------Guvcview
if echo $Applist2 | grep -q "Guvcview"; then
itemdisp "Installing guvcview"
dcop "$dcopRef" setLabel "Installing guvcview..."
installApp "guvcview" "guvcview/stable"

fi
qprogress "$script" 15



#---------------------------------------SMPLayer/MPV
if echo $Applist2 | grep -q "SMPlayer"; then
itemdisp "Installing SMPlayer/MPV"
dcop "$dcopRef" setLabel "Installing SMPlayer/MPV..."
    installApp "smplayer" "smplayer/"
mkdir -p "$USER_HOME/.configtde/smplayer/"
tar -xzf apps/smplayer.conf.tar.gz -C "$USER_HOME/.configtde/smplayer/"
sudo chown -R $USER: "$USER_HOME/.configtde/smplayer/smplayer.ini"

fi
qprogress "$script" 20



#---------------------------------------Spotify
if echo $Applist2 | grep -q "Spotify"; then
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

qprogress "$script" 22




#---------------------------------------spotify-qt
if echo $Applist2 | grep -q "spotify-qt"; then
itemdisp "Installing spotify-qt"
dcop "$dcopRef" setLabel "Installing spotify-qt..."
if ! isinstalled "spotify-qt/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="spotify-qt-v3.11.deb";fi
if [ "$osarch" = "i386" ]; then debfile="spotify-qt-v3.11_i386.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="spotify-qt-v3.11_armhf.deb";fi
sudo wget "https://github.com/seb3773/spotify-qt-packages/raw/main/$debfile"
qprogress "$script" 23
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 24

#---------------------------------------spotify-tui
if echo $Applist2 | grep -q "spotify-tui"; then
itemdisp "Installing spotify-tui"
dcop "$dcopRef" setLabel "Installing spotify-tui..."
if ! isinstalled "spotify-tui/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="spotify-tui-0.25.0.deb";fi
if [ "$osarch" = "i386" ]; then debfile="spotify-tui-0.25.0_i386.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="spotify-tui-0.25.0_armhf.deb";fi
sudo wget "https://github.com/seb3773/spotify-tui-packages/raw/main/$debfile"
qprogress "$script" 25
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 26


#---------------------------------------ncspot
if echo $Applist2 | grep -q "ncspot"; then
itemdisp "Installing ncspot"
dcop "$dcopRef" setLabel "Installing ncspot..."
if ! isinstalled "ncspot/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="ncspot-1.1.1.deb";fi
if [ "$osarch" = "i386" ]; then debfile="ncspot-1.1.1_i386.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="ncspot-1.1.1_armhf.deb";fi
sudo wget "https://github.com/seb3773/ncspot-packages/raw/main/$debfile"
qprogress "$script" 27
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 28



#---------------------------------------spotifyd
if echo $Applist2 | grep -q "spotifyd"; then
itemdisp "Installing spotifyd"
dcop "$dcopRef" setLabel "Installing spotifyd..."
if ! isinstalled "spotifyd/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="spotifyd-0.3.5.deb";fi
if [ "$osarch" = "i386" ]; then debfile="spotifyd-0.3.5_i386.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="spotifyd-0.3.5_armhf.deb";fi
sudo wget "https://github.com/seb3773/spotifyd-packages/raw/main/$debfile"
qprogress "$script" 29
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 30

# 
#---------------------------------------deezer
if echo $Applist2 | grep -q "deezer"; then
itemdisp "Installing deezer"
dcop "$dcopRef" setLabel "Installing deezer..."
if ! isinstalled "deezer-desktop/" "common/packages_list.tmp"; then
debfile="deezer-desktop_6.0.150_amd64.deb"
sudo wget "https://github.com/aunetx/deezer-linux/releases/download/v6.0.150-1/$debfile"
qprogress "$script" 31
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 32

# 
#---------------------------------------media-downloader/
if echo $Applist2 | grep -q "media-downloader"; then
itemdisp "Installing media-downloader"
dcop "$dcopRef" setLabel "Installing media-downloader..."
if ! isinstalled "media-downloader/" "common/packages_list.tmp"; then
echo -e "${YELLOW}"
echo 'deb http://download.opensuse.org/repositories/home:/obs_mhogomchungu/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:obs_mhogomchungu.list
curl -fsSL https://download.opensuse.org/repositories/home:obs_mhogomchungu/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_obs_mhogomchungu.gpg > /dev/null
sudo apt update
qprogress "$script" 34
sudo apt install media-downloader
echo -e "${NOCOLOR}"

#install aria2 for media-downloader
if ! isinstalled "aria2/" "common/packages_list.tmp"; then
echo -e "${YELLOW}"
itemdisp "Installing aria2 for media-downloader"
dcop "$dcopRef" setLabel "Installing aria2 for media-downloader..."
qprogress "$script" 35
sudo apt install aria2
echo -e "${NOCOLOR}"
fi

else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi

sep
echo
echo
echo
fi
qprogress "$script" 36


# 
#---------------------------------------spotify-player
if echo $Applist2 | grep -q "spotify-player"; then
itemdisp "Installing spotify-player"
dcop "$dcopRef" setLabel "Installing spotify-player..."
if ! isinstalled "spotify-player/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="spotify_player-0.18.2.deb";fi
if [ "$osarch" = "i386" ]; then debfile="spotify_player-0.18.2_i386.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="spotify_player-0.18.2_armhf.deb";fi
sudo wget "https://github.com/seb3773/spotify-player_packages/raw/main/$debfile"
qprogress "$script" 37
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 38



#---------------------------------------down_on_spot
if echo $Applist2 | grep -q "down_on_spot"; then
itemdisp "Installing DownOnSpot"
dcop "$dcopRef" setLabel "Installing DownOnSpot..."
if ! isinstalled "downonspot/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="down_on_spot-0.3.0.deb";fi
if [ "$osarch" = "i386" ]; then debfile="down_on_spot-0.3.0_i386.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="down_on_spot-0.3.0_armhf.deb";fi
sudo wget "https://github.com/seb3773/down_on_spot-packages/raw/main/$debfile"
qprogress "$script" 39
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 40






#---------------------------------------Microsoft Edge Browser
if echo $Applist2 | grep -q "Microsoft Edge Browser"; then
if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing Microsoft Edge Browser"
dcop "$dcopRef" setLabel "Installing Microsoft Edge Browser..."

if ! isinstalled "microsoft-edge-stable/stable" "common/packages_list.tmp"; then
echo -e "${YELLOW}"
sudo apt install software-properties-common apt-transport-https ca-certificates 
curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
echo 'deb [signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
sudo apt update
qprogress "$script" 41
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
qprogress "$script" 42


#---------------------------------------musikcube
if echo $Applist2 | grep -q "musikcube"; then
itemdisp "Installing musikcube"
dcop "$dcopRef" setLabel "Installing musikcube..."
if ! isinstalled " musikcube/" "common/packages_list.tmp"; then
if [ "$osarch" = "amd64" ]; then debfile="musikcube_3.0.2_linux_x86_64.deb";fi
if [ "$osarch" = "i386" ]; then debfile="musikcube_3.0.2_linux_x86.deb";fi
if [ "$osarch" = "armhf" ]; then debfile="musikcube_3.0.2_linux_rpi_armv8.deb";fi
sudo wget "https://github.com/clangen/musikcube/releases/download/3.0.2/$debfile"
qprogress "$script" 43
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
sep
echo
echo
echo
fi
qprogress "$script" 44






#---------------------------------------Gparted
if echo $Applist2 | grep -q "Gparted"; then
itemdisp "Installing gparted"
dcop "$dcopRef" setLabel "Installing gparted..."
installApp "gparted" "gparted/stable"
fi
qprogress "$script" 45




#---------------------------------------Stacer
if echo $Applist2 | grep -q "Stacer"; then
itemdisp "Installing Stacer"
dcop "$dcopRef" setLabel "Installing Stacer..."
installApp "stacer" "stacer/stable"

fi
qprogress "$script" 46



#---------------------------------------S4 Snapshot
if echo $Applist2 | grep -q "S4 Snapshot"; then
if ( getconf LONG_BIT | grep -q 64 ); then
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
fi 
qprogress "$script" 48




#---------------------------------------Web app manager
if echo $Applist2 | grep -q "Web app manager"; then
itemdisp "Installing Web app manager"
dcop "$dcopRef" setLabel "Installing Web app manager..."

if ! isinstalled "webapp-manager/" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing Web app manager..."
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
qprogress "$script" 50





#---------------------------------------Peazip
if echo $Applist2 | grep -q "Peazip"; then
itemdisp "Installing Peazip"
dcop "$dcopRef" setLabel "Installing Peazip..."
if ! isinstalled "peazip/" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing Peazip..."
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
if echo $Applist2 | grep -q "Pinta"; then
itemdisp "Installing Pinta"
dcop "$dcopRef" setLabel "Installing Pinta..."

if ! isinstalled "pinta/" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing Pinta..."
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
if echo $Applist2 | grep -q "Remmina"; then
itemdisp "Installing remmina"
dcop "$dcopRef" setLabel "Installing Remmina..."
installApp "remmina" "remmina/stable"

fi
qprogress "$script" 58



#---------------------------------------Rustdesk
if echo $Applist2 | grep -q "Rustdesk"; then
itemdisp "Installing Rustdesk"
dcop "$dcopRef" setLabel "Installing Rustdesk..."
sudo wget https://github.com/rustdesk/rustdesk/releases/download/1.2.3-2/rustdesk-1.2.3-2-x86_64.deb
sudo apt install -y ./rustdesk-1.2.3-2-x86_64.deb
sudo rm -f ./rustdesk-1.2.3-2-x86_64.deb

fi
qprogress "$script" 62


#---------------------------------------Free Office
if echo $Applist2 | grep -q "Free Office"; then
if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing free office"
dcop "$dcopRef" setLabel "Installing Free Office..."
if ! isinstalled "softmaker-freeoffice-" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing free office..."
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
fi
sep
echo
echo
echo
fi
qprogress "$script" 65





#---------------------------------------OnlyOffice
if echo $Applist2 | grep -q "OnlyOffice"; then
if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing OnlyOffice"
dcop "$dcopRef" setLabel "Installing Only Office..."
if ! isinstalled "onlyoffice-desktopeditors" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing OnlyOffice..."
echo -e "${YELLOW}"
sudo wget https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb
qprogress "$script" 58
sudo apt install -y ./onlyoffice-desktopeditors_amd64.deb
sudo rm -f ./onlyoffice-desktopeditors_amd64.deb
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
qprogress "$script" 70




#---------------------------------------Bpytop
if echo $Applist2 | grep -q "Bpytop"; then
itemdisp "Installing bpytop"
dcop "$dcopRef" setLabel "Installing bpytop..."
installApp "bpytop" "bpytop/stable"
sep
echo
echo
echo

fi
qprogress "$script" 72


#---------------------------------------Bottom
if echo $Applist2 | grep -q "Bottom"; then
itemdisp "Installing Bottom"
dcop "$dcopRef" setLabel "Installing Bottom..."
if ! isinstalled "bottom/" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing Bottom..."
echo -e "${YELLOW}"
DebSource="https://github.com/ClementTsang/bottom/releases/download/0.9.6/"
if [ "$osarch" = "amd64" ]; then debfile="bottom_0.9.6_amd64.deb";fi
if [ "$osarch" = "i386" ]; then 
debfile="bottom_0.9.6_i386.deb"
DebSource="https://github.com/seb3773/q4osXpack_packages_archive/raw/main/"
fi
if [ "$osarch" = "armhf" ]; then debfile="bottom_0.9.6_armhf.deb";fi
sudo wget "$DebSource$debfile"
qprogress "$script" 73
sudo apt install -y "./$debfile"
sudo rm -f "./$debfile"
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi
fi
qprogress "$script" 74


#---------------------------------------Virtualbox 7
if echo $Applist2 | grep -q "Virtualbox 7"; then
if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing virtualbox 7"
dcop "$dcopRef" setLabel "Installing Virtualbox 7..."

if ! isinstalled "virtualbox-7.0/" "common/packages_list.tmp"; then
echo -e "${YELLOW}"
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
qprogress "$script" 75
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
qprogress "$script" 76





#---------------------------------------Qtscrcpy
if echo $Applist2 | grep -q "Qtscrcpy"; then
if ( getconf LONG_BIT | grep -q 64 ); then
itemdisp "Installing Qtscrcpy"
dcop "$dcopRef" setLabel "Installing Qtscrcpy..."
if [ ! -e "$USER_HOME/qtscrcpy/QtScrcpy" ]; then
echo -e "${YELLOW}"
cd apps
sudo apt install -y libqt5multimedia5
qprogress "$script" 77
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
qprogress "$script" 78




#---------------------------------------WineHQ
if echo $Applist2 | grep -q "WineHQ"; then
itemdisp "Installing WineHQ"
dcop "$dcopRef" setLabel "Installing WineHQ..."
if ! isinstalled "winehq-stable/" "common/packages_list.tmp"; then
echo -e "${YELLOW}"
sudo dpkg --add-architecture i386
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
sudo apt update
sudo apt install -y --install-recommends winehq-stable
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks;sudo mv winetricks /usr/local/bin/
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

qprogress "$script" 80





#---------------------------------------Angry IP scanner
if echo $Applist2 | grep -q "Angry IP scanner"; then
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
qprogress "$script" 82




#---------------------------------------Filezilla
if echo $Applist2 | grep -q "Filezilla"; then
itemdisp "Installing Filezilla"
dcop "$dcopRef" setLabel "Installing Filezilla..."
installApp "filezilla" "filezilla/stable"
sep
echo
echo
echo

fi

qprogress "$script" 84



#---------------------------------------Rclone
if echo $Applist2 | grep -q "Rclone"; then
itemdisp "Installing Rclone"
dcop "$dcopRef" setLabel "Installing Rclone..."
if ! isinstalled "rclone/" "common/packages_list.tmp"; then
echo -e "  \e[35m░▒▓█ Installing Rclone..."
echo -e "${YELLOW}"
if [ "$osarch" = "amd64" ]; then
sudo wget https://downloads.rclone.org/v1.66.0/rclone-v1.66.0-linux-amd64.deb
sudo apt install -y ./rclone-v1.66.0-linux-amd64.deb
sudo rm -f ./rclone-v1.66.0-linux-amd64.deb
fi
if [ "$osarch" = "i386" ]; then
sudo wget https://downloads.rclone.org/v1.66.0/rclone-v1.66.0-linux-386.deb
sudo apt install -y ./rclone-v1.66.0-linux-386.deb
sudo rm -f ./rclone-v1.66.0-linux-386.deb
fi
if [ "$osarch" = "armhf" ]; then
sudo wget https://downloads.rclone.org/v1.66.0/rclone-v1.66.0-linux-arm-v7.deb
sudo apt install -y ./rclone-v1.66.0-linux-arm-v7.deb
sudo rm -f ./rclone-v1.66.0-linux-arm-v7.deb
fi
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed.${NOCOLOR}"
fi

fi
qprogress "$script" 86



#---------------------------------------Rclone browser
if echo $Applist2 | grep -q "rclone-browser"; then
itemdisp "Installing Rclone-browser"
dcop "$dcopRef" setLabel "Installing Rclone-browser..."
installApp "rclone-browser" "rclone-browser/stable"
sep
echo
echo
echo

fi




#---------------------------------------Kdiskmark
if echo $Applist2 | grep -q "Kdiskmark"; then
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
qprogress "$script" 88




#---------------------------------------kweather
if echo $Applist2 | grep -q "Kweather"; then
dcop "$dcopRef" setLabel "Installing Kweather..."
itemdisp "Installing Kweather..."
installApp "kweather-trinity" "kweather-trinity/"
fi
qprogress "$script" 90

##---------------------------------------------------------------------------------- end extra apps part
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
cat common/atyourownrisk
dcop "$dcopRef" close
kdialog --title "q4osXpack » qapps " --icon "$kdicon" --msgbox "⠀⠀⠀Installation Completed.⠀⠀⠀⠀⠀⠀"

exit 2
