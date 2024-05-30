#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
kdicon="$script_directory/../common/Q4OSsebicon.png"
kdtitle="q4osXpack"
kdcaption="winapps - Notepad++"
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Notepad++</em><br>
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

osarch=$(dpkg --print-architecture)
if [ "$osarch" = "amd64" ]; then
prefx=".win64";warch="win64"
setupfile="npp.8.6.4.Installer.x64.exe"
else
prefx=".win32";warch="win32"
setupfile="npp.8.6.6.Installer.exe"
fi

mkdir -p "$HOME/wine_notepadpp_setup/files"
cd "$HOME/wine_notepadpp_setup/files"
base_url="https://raw.githubusercontent.com/seb3773/wine_notepadpp/main"


wget $base_url/files/$setupfile
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget $base_url/files/notepadpp.desktop
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget $base_url/files/notepadpp.png
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget $base_url/files/notepadpp.sh
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
cd ..
wget wget $base_url/install_notepadpp.sh
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

if [ ! -d "$HOME/$prefx" ]; then
dcop "$dcopRef" setLabel "Creating $prefx prefix..."
mkdir -p "$HOME/$prefx"
WINEARCH=$warch WINEPREFIX="$HOME/$prefx" winecfg /v win7
while pgrep wine > /dev/null; do sleep 1; done
sleep 2
WINEPREFIX="$HOME/$prefx" wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 0x6e /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingGamma /t REG_DWORD /d 0x578 /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingOrientation /t REG_DWORD /d 1 /f
WINEPREFIX="$HOME/$prefx" wine reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f
fi

dcop "$dcopRef" setProgress 50
dcop "$dcopRef" setLabel "Running install program..."
WINEPREFIX="$HOME/$prefx" wine "./files/$setupfile"

dcop "$dcopRef" setLabel "Creating menu entries..."
dcop "$dcopRef" setProgress 90

sudo cp -f ./files/notepadpp.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/notepadpp.desktop "$HOME/.local/share/applications"
sudo cp -f ./files/notepadpp.sh "$HOME/$prefx"
sudo chmod +x "$HOME/$prefx/notepadpp.sh"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/notepadpp.desktop"
sudo sed -i "s|\.win64|$prefx|g" "$HOME/.local/share/applications/notepadpp.desktop"
sudo sed -i "s|\.win64|$prefx|g" "$HOME/$prefx/notepadpp.sh"
dcop "$dcopRef" setProgress 100
sleep 1
dcop "$dcopRef" close

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Mp3Tag installed.</em><br><br>
*you can remove \"$HOME/wine_notepadpp_setup\" folder if you want.
</font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --msgbox "$kdtext"

