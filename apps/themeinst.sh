#!/bin/bash
n="themepack";if [ -t 0 ];then term=1;else term=0;fi
if [ $# -eq 0 ];then if [ $term -eq 1 ];then
echo "Usage:";echo "- Apply $n :    $0 <xxxx.themepack>";echo "- Install association: $0 install"
fi;exit 1;fi;USH=$(eval echo ~${SUDO_USER})
if [ "$term" -eq 1 ] && [ "$1" = "install" ];then echo "installing...";scfold=$(dirname "$(readlink -f "$0")")
dskf="[Desktop Entry]
Exec[\$e]=$scfold/themeinst.sh
MimeType=application/ms_$n
Icon=preferences-desktop-theme
Name=MS $n installer
Terminal=false
Type=Application
X-TDE-InitialPreference=2
";deskfp="$HOME/.trinity/share/applnk/.hidden/themeinst.sh.desktop"
mkdir -p "$HOME/.trinity/share/applnk/.hidden";echo "$dskf" | tee "$deskfp" > /dev/null 2>&1
deskfp2="$HOME/.trinity/share/applnk/.hidden/themeinst.sh-2.desktop"
\cp "$deskfp" "$deskfp2"
sed -i 's/^MimeType=.*/MimeType=application\/ms_deskthemepack/' "$HOME/.trinity/share/applnk/.hidden/themeinst.sh-2.desktop"
mdskf="[Desktop Entry]
Comment=Microsoft $n
Hidden=false
Icon=preferences-desktop-wallpaper
MimeType=application/ms_$n
Patterns=*.$n
Type=MimeType
";mdeskfp="$HOME/.trinity/share/mimelnk/application/ms_themepack.desktop"
echo "$mdskf" | tee "$mdeskfp" > /dev/null 2>&1
mdeskfp2="$HOME/.trinity/share/mimelnk/application/ms_deskthemepack.desktop"
\cp "$mdeskfp" "$mdeskfp2"
sed -i 's/^MimeType=.*/MimeType=application\/ms_deskthemepack/' "$mdeskfp2"
sed -i 's/^Patterns=.*/Patterns=*.deskthemepack/' "$mdeskfp2"
echo "Done.";exit;fi
fn=$(basename "$1");if [[ $fn == *.themepack ]];then fn_noext="${fn%.themepack}"
elif [[ $fn == *.deskthemepack ]];then fn_noext="${fn%.deskthemepack}"
else echo "Extension must be .$n or .desk$n";exit;fi
fn=$fn_noext;wpdir="$TDEHOME/share/wallpapers/$fn";mkdir -p "$wpdir"
7z x "$1" -o"$wpdir" -y > /dev/null 2>&1
rm -f "$TDEHOME/share/wallpapers/$fn/"*.theme
kwriteconfig --file "$USH/.trinity/share/config/kdesktoprc" --group Desktop0 --key WallpaperList "$TDEHOME/share/wallpapers/$fn/DesktopBackground/"
kwriteconfig --file "$USH/.trinity/share/config/kdesktoprc" --group Desktop0 --key MultiWallpaperMode Random
kwriteconfig --file "$USH/.trinity/share/config/kdesktoprc" --group Desktop0 --key CrossFadeBg true
kwriteconfig --file "$USH/.trinity/share/config/kdesktoprc" --group Desktop0 --key ChangeInterval 10
dcop kdesktop KBackgroundIface configure
if  [ $term -eq 1 ];then echo "$n $fn installed."
else dcop knotify Notify notify "$n installation" "knotify" "$n $fn applied." "" "" 16 2;fi
