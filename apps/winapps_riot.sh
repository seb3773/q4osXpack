#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
kdicon="$script_directory/../common/Q4OSsebicon.png"
kdtitle="q4osXpack"
kdcaption="winapps - Riot"
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Riot images optimizer</em><br>
═══════════════════════════<br><br>
<font style='color:#828282'>►</font> Proceed with the installation ?<br>
<font style='color:#828282'><em>(or hit cancel to return)</em></font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --warningcontinuecancel "$kdtext"
if [ $? -eq 2 ]; then
exit
fi

tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Root authentification  needed to continue"
oksu=$(sudo -n echo 1 2>&1 | grep 1);if [[ ! $oksu -eq 1 ]];then kdialog --title "q4osXpack » winapps " --icon "$kdicon" --msgbox "Can't continue without root authentification.";exit;fi

totfiles=5
filenumber=0
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Downloading..." $totfiles)

mkdir -p "$HOME/wine_riot_setup/files"
cd "$HOME/wine_riot_setup/files"
base_url="https://raw.githubusercontent.com/seb3773/wine_riot/main"

wget $base_url/files/Riot-setup-x64.exe
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget $base_url/files/riot.desktop
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget $base_url/files/riot.png
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget $base_url/files/riot.sh
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
cd ..
wget wget $base_url/install_riot.sh
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
dcop "$dcopRef" close

if ! dpkg -l | grep -q winehq-stable; then
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Installing wine..." 100)
sudo dpkg --add-architecture i386 >> ./setup.log 2>&1
sudo apt install -y gnupg2 software-properties-common wget cabextract >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 20
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key >> ./setup.log 2>&1
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources >> ./setup.log 2>&1
sudo apt update >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 30
sudo apt install -y --install-recommends winehq-stable >> ./setup.log 2>&1
else
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Installing winetricks..." 100)
fi
dcop "$dcopRef" setProgress 40

if [ ! -d "$HOME/.win64" ]; then
dcop "$dcopRef" setLabel "Creating .win64 prefix..."
mkdir -p "$HOME/.win64"
WINEARCH=win64 WINEPREFIX="$HOME/.win64" winecfg /v win7
while pgrep wine > /dev/null; do sleep 1; done
sleep 2
WINEPREFIX="$HOME/.win64" wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 0x6e /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingGamma /t REG_DWORD /d 0x578 /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingOrientation /t REG_DWORD /d 1 /f
WINEPREFIX="$HOME/.win64" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f
fi

dcop "$dcopRef" setProgress 50
dcop "$dcopRef" setLabel "Running install program..."
WINEPREFIX="$HOME/.win64" wine "./files/Riot-setup-x64.exe"

dcop "$dcopRef" setLabel "Creating menu entries..."
dcop "$dcopRef" setProgress 90

sudo cp -f ./files/riot.png /usr/share/icons/hicolor/64x64/apps
sudo cp -f ./files/riot.desktop "$HOME/.local/share/applications"
sudo cp -f ./files/riot.sh "$HOME/.win64"
sudo chmod +x "$HOME/.win64/riot.sh"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/riot.desktop"
dcop "$dcopRef" setProgress 100
sleep 1
dcop "$dcopRef" close

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Riot installed.</em><br><br>
*you can remove \"$HOME/wine_riot_setup\" folder if you want.
</font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --msgbox "$kdtext"

