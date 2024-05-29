#!/bin/bash
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
cd ..
kdicon="$script_directory/../common/Q4OSsebicon.png"
kdtitle="q4osXpack"
kdcaption="winapps - Office 365"
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Office 365 (Office 2019) {fr/en/de/ru}</em><br>
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


totfiles=44
filenumber=1
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 150) --progressbar "Downloading..." $totfiles)
mkdir -p "$HOME/wine_office365_setup/files"
cd "$HOME/wine_office365_setup/files"
base_url="https://raw.githubusercontent.com/seb3773/wine_office365/main/files/"
output_file="Microsoft_Office_365_part_aa"
wget "${base_url}/Microsoft_Office_365_part_aa"
dcop "$dcopRef" setProgress $filenumber;((filenumber++))

for partn in {b..z}; do
wget "${base_url}/Microsoft_Office_365_part_a${partn}"
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
tee "${output_file}" --append < "Microsoft_Office_365_part_a${partn}" > /dev/null
rm "Microsoft_Office_365_part_a${partn}"
done
for partn in {a..i}; do
wget "${base_url}/Microsoft_Office_365_part_b${partn}"
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
tee "${output_file}" --append < "Microsoft_Office_365_part_b${partn}" > /dev/null
rm "Microsoft_Office_365_part_b${partn}"
done
mv Microsoft_Office_365_part_aa Microsoft_Office_365.tar.xz
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/Excel.desktop
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/PowerPoint.desktop
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/Word.desktop
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/excel.png
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/powerpoint.png
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/word.png
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/files/hkeyuser.reg
dcop "$dcopRef" setProgress $filenumber;((filenumber++))
cd ..
wget https://raw.githubusercontent.com/seb3773/wine_office365/main/install_office.sh
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
dcop "$dcopRef" setLabel "Creating Microsoft_Office_365 prefix..."
mkdir -p "$HOME/Microsoft_Office_365"
WINEARCH=win32 WINEPREFIX="$HOME/Microsoft_Office_365" winecfg /v win7 >> ./setup.log 2>&1
while pgrep wine > /dev/null; do sleep 1; done
sleep 2

dcop "$dcopRef" setProgress 50
dcop "$dcopRef" setLabel "Extracting archive, please wait..."
tar -xf ./files/Microsoft_Office_365.tar.xz -C "$HOME/"
dcop "$dcopRef" setProgress 80

cp -f ./files/hkeyuser.reg "$HOME/Microsoft_Office_365/drive_c"
sed -i 's/XXuserXX/'"$USER"'/g' "$HOME/Microsoft_Office_365/drive_c/hkeyuser.reg"
WINEPREFIX="$HOME/Microsoft_Office_365" regedit /S "$HOME/Microsoft_Office_365/drive_c/hkeyuser.reg"  >> ./setup.log 2>&1
while pgrep wine > /dev/null; do sleep 1; done
sleep 2
dcop "$dcopRef" setProgress 90
rm "$HOME/Microsoft_Office_365/drive_c/hkeyuser.reg"
rm -rf "$HOME/Microsoft_Office_365/drive_c/users/$USER"
mv "$HOME/Microsoft_Office_365/drive_c/users/XXuserXX" "$HOME/Microsoft_Office_365/drive_c/users/$USER"
cd  "$HOME/Microsoft_Office_365/drive_c/users/$USER"
ln -s $(xdg-user-dir DESKTOP) Desktop
ln -s $(xdg-user-dir DOWNLOAD) Downloads
ln -s $(xdg-user-dir DOCUMENTS) Documents
ln -s $(xdg-user-dir MUSIC) Music
ln -s $(xdg-user-dir PICTURES) Pictures
ln -s $(xdg-user-dir VIDEOS) Videos
cd -
sudo cp -f ./files/word.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/excel.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/powerpoint.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/Word.desktop "$HOME/.local/share/applications/"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/Word.desktop"
sudo cp -f ./files/Excel.desktop "$HOME/.local/share/applications/"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/Excel.desktop"
sudo cp -f ./files/PowerPoint.desktop "$HOME/.local/share/applications/"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/PowerPoint.desktop"
dcop "$dcopRef" setProgress 100
sleep 1
dcop "$dcopRef" close

kdtext="<font style='color:#ac6009'><strong>⏺ q4osXpack winapps ⏺</strong></font><br><br>
═══════════════════════════<br>
<em>Microsoft Office 365 installed.</em><br><br>
</font>
"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 350) --msgbox "$kdtext"

