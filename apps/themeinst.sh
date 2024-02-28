#!/bin/bash
if [ -t 0 ]; then interm=1; else interm=0; fi
if [ $# -eq 0 ]; then
if  [ $interm -eq 1 ]; then
echo "Usage:";echo "- Apply themepack:      $0 <xxxx.themepack>";echo "- Install association:  $0 install"
fi; exit 1; fi
USER_HOME=$(eval echo ~${SUDO_USER})
if [ "$interm" -eq 1 ] && [ "$1" = "install" ]; then
echo "installing...";scriptfolder=$(dirname "$(readlink -f "$0")")
desktopfilecontent="[Desktop Entry]
Exec[\$e]=$scriptfolder/themeinst.sh
MimeType=application/ms_themepack
Icon=preferences-desktop-theme
Name=MS themepack installer
Terminal=false
Type=Application
X-TDE-InitialPreference=2
";desktopfilepath="$HOME/.trinity/share/applnk/.hidden/themeinst.sh.desktop"
sudo mkdir -p "$HOME/.trinity/share/applnk/.hidden"
echo "$desktopfilecontent" | sudo tee "$desktopfilepath" > /dev/null 2>&1
desktopfilecontent="[Desktop Entry]
Exec[\$e]=$scriptfolder/themeinst.sh
MimeType=application/ms_deskthemepack
Icon=preferences-desktop-theme
Name=MS themepack installer
Terminal=false
Type=Application
X-TDE-InitialPreference=2
";desktopfilepath="$HOME/.trinity/share/applnk/.hidden/themeinst.sh-2.desktop"
sudo mkdir -p "$HOME/.trinity/share/applnk/.hidden"
echo "$desktopfilecontent" | sudo tee "$desktopfilepath" > /dev/null 2>&1
mdesktopfilecontent="[Desktop Entry]
Comment=Microsoft themepack
Hidden=false
Icon=preferences-desktop-wallpaper
MimeType=application/ms_themepack
Patterns=*.themepack
Type=MimeType
";mdesktopfilepath="$HOME/.trinity/share/mimelnk/application/ms_themepack.desktop"
echo "$mdesktopfilecontent" | sudo tee "$mdesktopfilepath" > /dev/null 2>&1
mdesktopfilecontent="[Desktop Entry]
Comment=Microsoft deskthemepack
Hidden=false
Icon=preferences-desktop-wallpaper
MimeType=application/ms_deskthemepack
Patterns=*.deskthemepack
Type=MimeType
";mdesktopfilepath="$HOME/.trinity/share/mimelnk/application/ms_deskthemepack.desktop"
echo "$mdesktopfilecontent" | sudo tee "$mdesktopfilepath" > /dev/null 2>&1
echo "Done."; exit; fi
filename=$(basename "$1")
if [[ $filename == *.themepack ]]; then filename_no_extension="${filename%.themepack}"
elif [[ $filename == *.deskthemepack ]]; then filename_no_extension="${filename%.deskthemepack}"
else echo "Extension must be .themepack or .deskthemepack"; exit; fi
filename=$filename_no_extension
wallpapers_dir="$TDEHOME/share/wallpapers/$filename"
mkdir -p "$wallpapers_dir"
7z x "$1" -o"$wallpapers_dir" -y > /dev/null 2>&1
rm -f "$TDEHOME/share/wallpapers/$filename/"*.theme
kwriteconfig --file $USER_HOME/.trinity/share/config/kdesktoprc --group Desktop0 --key WallpaperList "$TDEHOME/share/wallpapers/$filename/DesktopBackground/"
kwriteconfig --file $USER_HOME/.trinity/share/config/kdesktoprc --group Desktop0 --key MultiWallpaperMode Random
kwriteconfig --file $USER_HOME/.trinity/share/config/kdesktoprc --group Desktop0 --key CrossFadeBg true
kwriteconfig --file $USER_HOME/.trinity/share/config/kdesktoprc --group Desktop0 --key ChangeInterval 10
dcop kdesktop KBackgroundIface configure
if  [ $interm -eq 1 ]; then echo "Themepack $filename installed."
else dcop knotify Notify notify "Themepack installation" "knotify" "Themepack $filename Applied." "" "" 16 2
fi
