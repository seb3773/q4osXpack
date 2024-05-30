#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
kdicon="$script_directory/../common/Q4OSsebicon.png"
kdtitle="q4osXpack"
kdcaption="winapps - Photoshop CC"
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Photoshop CC 2020</em><br>
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


totfiles=35
filenumber=1
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Downloading..." $totfiles)
mkdir -p "$HOME/wine_photoshopcc_setup/files"
cd "$HOME/wine_photoshopcc_setup/files"
base_url="https://github.com/seb3773/wine_photoshopcc/raw/main/files"
output_file="PhotoshopCC_folder_part_aa"
wget "${base_url}/PhotoshopCC_folder_part_aa"
dcop "$dcopRef" setProgress $filenumber;((filenumber++))

for partn in {b..z}; do
wget "${base_url}/PhotoshopCC_folder_part_a${partn}"
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
tee "${output_file}" --append < "PhotoshopCC_folder_part_a${partn}" > /dev/null
rm "PhotoshopCC_folder_part_a${partn}"
done
for partn in {a..e}; do
wget "${base_url}/PhotoshopCC_folder_part_b${partn}"
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
tee "${output_file}" --append < "PhotoshopCC_folder_part_b${partn}" > /dev/null
rm "PhotoshopCC_folder_part_b${partn}"
done
mv PhotoshopCC_folder_part_aa PhotoshopCC_folder.tar.xz
wget https://github.com/seb3773/wine_photoshopcc/raw/main/files/photoshop-cc.png
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://github.com/seb3773/wine_photoshopcc/raw/main/files/photoshop.desktop
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://github.com/seb3773/wine_photoshopcc/raw/main/files/photoshop.sh
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
cd ..
wget https://github.com/seb3773/wine_photoshopcc/raw/main/install_photoshop.sh
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
dcop "$dcopRef" close

if ! dpkg -l | grep -q winehq-stable; then
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Installing wine..." 100)
sudo dpkg --add-architecture i386 >> ./setup.log 2>&1
sudo apt install -y gnupg2 software-properties-common wget cabextract >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 10
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key >> ./setup.log 2>&1
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources >> ./setup.log 2>&1
sudo apt update >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 15
sudo apt install -y --install-recommends winehq-stable >> ./setup.log 2>&1
else
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Installing winetricks..." 100)
fi

dcop "$dcopRef" setProgress 20
dcop "$dcopRef" setLabel "Installing winetricks..."
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks >> ./setup.log 2>&1
chmod +x winetricks;sudo mv winetricks /usr/local/bin/
dcop "$dcopRef" setProgress 25
dcop "$dcopRef" setLabel "Creating PhotoshopCC prefix..."
mkdir -p "$HOME/PhotoshopCC"
dcop "$dcopRef" setProgress 30
dcop "$dcopRef" setLabel "winetricks: installing vcrun2019..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2019  >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 35
dcop "$dcopRef" setLabel "winetricks: installing vcrun2012..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2012 >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 40
dcop "$dcopRef" setLabel "winetricks: installing vcrun2013..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2013 >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 45
dcop "$dcopRef" setLabel "winetricks: installing vcrun2010..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2010 >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 50
dcop "$dcopRef" setLabel "winetricks: installing gdiplus..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose fontsmooth=rgb gdiplus >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 55
dcop "$dcopRef" setLabel "winetricks: installing msxml3 & msxml6..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose msxml3 msxml6 >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 60
dcop "$dcopRef" setLabel "winetricks: installing atmlib..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose atmlib >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 65
dcop "$dcopRef" setLabel "winetricks: installing corefonts..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose corefonts >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 70
dcop "$dcopRef" setLabel "winetricks: installing dxvk..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose dxvk >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 75
echo

dcop "$dcopRef" setLabel "Configuring prefixe..."
WINEARCH=win64 WINEPREFIX="$HOME/PhotoshopCC" winecfg /v win7 >> ./setup.log 2>&1
while pgrep wine > /dev/null; do sleep 1; done
sleep 2
dcop "$dcopRef" setProgress 80
dcop "$dcopRef" setLabel "Extracting archive, please wait..."
tar -xf "$HOME/wine_photoshopcc_setup/files/PhotoshopCC_folder.tar.xz" -C "$HOME/PhotoshopCC"
dcop "$dcopRef" setLabel "Creating menu entries..."
dcop "$dcopRef" setProgress 95
sudo cp -f "$HOME/wine_photoshopcc_setup/files/photoshop-cc.png" /usr/share/icons/hicolor/128x128/apps
sudo cp -f "$HOME/wine_photoshopcc_setup/files/photoshop.desktop" "$HOME/.local/share/applications/"
sudo cp -f "$HOME/wine_photoshopcc_setup/files/photoshop.sh" "$HOME/PhotoshopCC"
sudo chmod +x "$HOME/PhotoshopCC/photoshop.sh"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/photoshop.desktop"
dcop "$dcopRef" setProgress 100
sleep 1
dcop "$dcopRef" close

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Photoshop CC 2020 installed.</em><br><br>
Do you want to install CameraRaw ?<br>
</font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --yesno "$kdtext"
if [ $? -eq 0 ]; then
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Downloading CameraRaw..." 100)
wget -P "$HOME/PhotoshopCC/" https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 50
dcop "$dcopRef" setLabel "Installing CameraRaw..."
WINEPREFIX=$HOME/PhotoshopCC wine $HOME/PhotoshopCC/CameraRaw_12_2_1.exe >> ./setup.log 2>&1
dcop "$dcopRef" setProgress 100
rm -f "$HOME/PhotoshopCC/CameraRaw_12_2_1.exe"
sleep 1
dcop "$dcopRef" close
kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>CameraRaw installed.</em><br><br>
</font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --msgbox "$kdtext"
fi

WINEPREFIX=$HOME/PhotoshopCC wine $HOME/PhotoshopCC/Photoshop-CC/Photoshop.exe </dev/null >/dev/null 2>&1 &
