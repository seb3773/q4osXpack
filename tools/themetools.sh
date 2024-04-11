#!/bin/bash
centerk(){ ressc=$(xrandr | grep '*' | awk '{print $1}');screenw=$(echo $ressc | cut -d 'x' -f 1);screenh=$(echo $ressc | cut -d 'x' -f 2)
center_x=$(( ($screenw - $1) / 2 ));center_y=$(( ($screenh - $2) / 2 ));kgeo="${1}x${2}+$center_x+$center_y";echo "$kgeo";}
#----------------------------------------
script_path="$0"
script_full_path=$(realpath "$script_path")
script_directory=$(dirname "$script_full_path")
cd "$script_directory"
kdicon="$script_directory/common/Q4OSsebicon.png"
osarch=$(dpkg --print-architecture)
USER_HOME=$(eval echo ~${SUDO_USER})
USER_SU=$USER
#------------------

lowres=0
Xres=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
Yres=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
Ypos=$(echo "$Yres * 0.473" | bc)
Ypos_rounded=$(awk 'BEGIN { printf "%.0f\n", '"$Ypos"' }')
if (( $Xres < 1920 )); then
lowres=1
usz=180
rsz1="180x180^"
rsz2="180x180"
fact="0.15"
else
usz=220
rsz1="220x220^"
rsz2="220x220"
fact="0.2"
fi


testlight () {
lightamount_up=$(sudo convert /opt/trinity/share/apps/tdm/themes/windows/background.jpg -crop x260+0+0 -threshold 50% -format "%[fx:100*image.mean]" info:)
lightamount_center=$(sudo convert /opt/trinity/share/apps/tdm/themes/windows/background.jpg -crop x300+0+400 -threshold 50% -format "%[fx:100*image.mean]" info:)
lightamount_user=$(sudo convert /opt/trinity/share/apps/tdm/themes/windows/background.jpg -crop x$Ypos_rounded+0+40 -threshold 50% -format "%[fx:100*image.mean]" info:)

if (( $(echo "$lightamount_up > 70" | bc -l) )); then
sudo sed -i '/<normal font="Segoe UI 58" color=/c\<normal font="Segoe UI 58" color="#444444"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
sudo sed -i '/<normal font="Segoe UI 48" color=/c\<normal font="Segoe UI 48" color="#444444"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
else
sudo sed -i '/<normal font="Segoe UI 58" color=/c\<normal font="Segoe UI 58" color="#EEEEEE"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
sudo sed -i '/<normal font="Segoe UI 48" color=/c\<normal font="Segoe UI 48" color="#EEEEEE"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
fi
if (( $(echo "$lightamount_center > 70" | bc -l) )); then
sudo sed -i '/<normal color="#FFFFFF" font="Segoe UI 14"/c\<normal color="#333333" font="Segoe UI 14"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
else
sudo sed -i '/<normal color="#FFFFFF" font="Segoe UI 14"/c\<normal color="#FFFFFF" font="Segoe UI 14"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
fi

if (( $(echo "$lightamount_user > 70" | bc -l) )); then
sudo kwriteconfig --file "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER/Theme.rc" --group "KSplash Theme: Redmond10_$USER" --key "Username Text Color" "35,35,35"
sudo kwriteconfig --file "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER/Theme.rc" --group "KSplash Theme: Redmond10_$USER" --key "Action Text Color" "65,65,65"
else
sudo kwriteconfig --file "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER/Theme.rc" --group "KSplash Theme: Redmond10_$USER" --key "Username Text Color" "255,255,255"
sudo kwriteconfig --file "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER/Theme.rc" --group "KSplash Theme: Redmond10_$USER" --key "Action Text Color" "180,180,180"
fi
}

logbck () {
tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Administrator rights needed"
dcopRef=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 500 300) --progressbar "update login screen with current wallpaper ..." 100)

rwallp=$(kreadconfig --file $TDEHOME/share/config/kdesktoprc --group Desktop0 --key Wallpaper)
Xres=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
Yres=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)
sudo convert $rwallp -resize ${Xres}x${Yres}! -filter Gaussian -blur 0x30 /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg

dcop "$dcopRef" setProgress 20

sudo convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg /opt/trinity/share/apps/tdm/themes/windows/userpic.png -geometry +$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:h*$fact]" info:) -composite /opt/trinity/share/apps/tdm/themes/windows/background.jpg

dcop "$dcopRef" setProgress 50

base_bg="/opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg"
user_directories=(/opt/trinity/share/apps/ksplash/Themes/Redmond10_*/)
for user_dir in "${user_directories[@]}"; do
user_dir="${user_dir%/}"
userpic="/opt/trinity/share/apps/ksplash/Themes/$(basename "$user_dir")/userpic.png"
output_bg="/opt/trinity/share/apps/ksplash/Themes/$(basename "$user_dir")/Background.png"
sudo convert "$base_bg" "$userpic" -geometry +$(convert "$base_bg" -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert "$base_bg" -ping -format "%[fx:h*$fact]" info:) -composite "$output_bg"
done

dcop "$dcopRef" setProgress 70

testlight

dcop "$dcopRef" setProgress 100
dcop "$dcopRef" close
return 1
}





LOGBK() {
logbck
kdialog --title "$kdtitle" --caption "$kdcaption" --icon "$kdicon" --msgbox "Current wallpaper applied to login background"⠀
}





RANDWP () {
wallpn=$(( $RANDOM % 25 + 1 ))
rwallp=q4seb_hd_win_$wallpn.jpg
dcop kdesktop KBackgroundIface setWallpaper /opt/trinity/share/wallpapers/$rwallp 6
logbck
kdialog --title "$kdtitle" --caption "$kdcaption" --icon "$kdicon" --msgbox "Random wallpaper applied to login & desktop."⠀
}





USRPC() {

function check_image_size {
    local image_path="$1"
    local min_width=$usz
    local min_height=$usz
    local dimensions
    dimensions=$(identify -format "%w %h" "$image_path")
    local width height
    read -r width height <<< "$dimensions"
    if ((width >= min_width && height >= min_height)); then
       # echo "Picture size: Ok."
        return 0
    else
        kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --error "Picture size must be at least $usz x $usz pixels"
        return 1
    fi
}

function resize_and_create_circle_image {
    local input_image="$1"
    local output_image="$2"
    local small_image_output="$3"
    local circle_size=$usz 
    local small_image_size=64
local temp_image0=$(mktemp "${TMPDIR:-/tmp}/temp_image0.XXXXXXXXXX")    
convert "$input_image" -resize $rsz1 -gravity center -extent $rsz2 "$temp_image0"
    local temp_image=$(mktemp "${TMPDIR:-/tmp}/temp_image.XXXXXXXXXX.png")
    convert "$temp_image0" -alpha set -background none -virtual-pixel transparent -distort SRT 0 +repage \( -size "${circle_size}x${circle_size}" xc:none -fill white -draw "circle $((circle_size / 2)),$((circle_size / 2)) $((circle_size / 2)),0" \) -compose copy-opacity -composite "$temp_image"

    convert "$temp_image" -trim -background none -flatten "$output_image"
    rm "$temp_image"
rm "$temp_image0"
    convert "$output_image" -resize "${small_image_size}x${small_image_size}" "$small_image_output"
}


function applyUserPic {
        tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Administrator rights needed"
        rm -f "$USER_HOME/.face.icon"
        resize_and_create_circle_image "$FILE_SELECTED" "$USER_HOME/userpic.png" "$USER_HOME/faceicon.png"
        \cp "$USER_HOME/faceicon.png" "$USER_HOME/.face.icon"
        sudo \cp "$USER_HOME/faceicon.png" "/opt/trinity/share/apps/tdm/faces/$USER_SU.face.icon"
        sudo \cp "$USER_HOME/userpic.png" "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/userpic.png"
        sudo convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/userpic.png" -geometry +$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:h*$fact]" info:) -composite /opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/Background.png
        kwriteconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "userpic" "custom"

        kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --yesno "Do you want to use this image for login screen user picture too ?\n(this will be global for all users in case of multi accounts usage)"

        if [[ $? -eq 0 ]]; then
        sudo \cp "$USER_HOME/userpic.png" "/opt/trinity/share/apps/tdm/themes/windows/userpic.png"
        sudo convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg /opt/trinity/share/apps/tdm/themes/windows/userpic.png -geometry +$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:h*$fact]" info:) -composite /opt/trinity/share/apps/tdm/themes/windows/background.jpg
        kwriteconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "loginpic" "custom"
        fi
        rm -f "$USER_HOME/userpic.png"
        rm -f "$USER_HOME/faceicon.png"
        echo "Done."
}



userpcchoice()
{
kdtext="$ktext
<font style='color:#828282'>►</font> Choose an option:<br>
<font style='color:#828282'><em>(or hit cancel to return)</em></font><br>"
choix=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 400 480) --menu "$kdtext" "custom" "Select your own image" "classic" "Select a classic windows avatar" "default" "Restore default image")
if [ $? -eq 1 ];then
echo "canceled"
else
echo "$choix"
fi
}


usercustom () 
{
while true; do

FILE_SELECTED=$(kdialog --getopenfilename "$USER_HOME/" '*.jpg')
if [ $? -eq 1 ];then
break
fi


if check_image_size "$FILE_SELECTED"; then
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --yesno "Use this image as user picture ?"
if [[ $? -eq 0 ]]; then
applyUserPic
break
fi
fi


done
}



userwclassic ()
{
if [ -d "/usr/share/avatars" ]; then
    jpg_count=$(find "/usr/share/avatars" -maxdepth 1 -type f -name "*.jpg" | wc -l)

    if [ "$jpg_count" -gt 0 ]; then


while true; do

FILE_SELECTED=$(kdialog --getopenfilename "/usr/share/avatars/" '*.jpg')
if [ $? -eq 1 ];then
break
fi


if check_image_size "$FILE_SELECTED"; then
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --yesno "Use this image as user picture ?"
if [[ $? -eq 0 ]]; then
applyUserPic
break
fi
fi


done
    else
    kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --error "/usr/share/avatars doesn't contains any .jpg files... did you deleted something ?... You must re-apply your theme to restore them."
    fi
else
    kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --error "/usr/share/avatars doesn't exist, did you have deleted it ? You must re-apply your theme to restore it."
fi

}


userdefault()
{
tdesudo -c ls /dev/null > /dev/null 2>&1 -d -i password --comment "Administrator rights needed"
rm -f "$USER_HOME/.face.icon"
#sudo mv -f "/opt/trinity/share/apps/tdm/themes/windows/userpic.png" "/opt/trinity/share/apps/tdm/themes/windows/olduserpic.png"
#sudo tar -xzf theme/tdmwin.tar.gz -C "/opt/trinity/share/apps/tdm/themes/" windows/userpic.png
sudo \cp /opt/trinity/share/apps/tdm/themes/windows/loginpic_default.png "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/userpic.png"
sudo convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/userpic.png" -geometry +$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:h*$fact]" info:) -composite /opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/Background.png
iconth=$(kreadconfig --file $TDEHOME/share/config/kdeglobals --group Icons --key Theme)
sudo \cp "/usr/share/icons/$iconth/64x64/actions/switchuser.png" "$USER_HOME/.face.icon"
sudo \cp "/usr/share/icons/$iconth/64x64/actions/switchuser.png" "/opt/trinity/share/apps/tdm/faces/$USER_SU.face.icon"
kwriteconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "userpic" "default"
sudo \cp "/opt/trinity/share/apps/ksplash/Themes/Redmond10_$USER_SU/userpic.png" "/opt/trinity/share/apps/tdm/themes/windows/userpic.png"
sudo convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg /opt/trinity/share/apps/tdm/themes/windows/userpic.png -geometry +$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:h*$fact]" info:) -composite /opt/trinity/share/apps/tdm/themes/windows/background.jpg
kwriteconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "loginpic" "default"
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --msgbox "Default user picture restored."
}

#=====main USRPC ====

while true; do

choice=$(userpcchoice)
case "$choice" in
custom) usercustom ;;
classic) userwclassic ;;
default) userdefault ;;
canceled) break ;;
*) ;;
esac



done
return 1
}



#############################################################################################################
###################################################" MAIN MENU ##############################################
ktext="<font style='color:#ac6009'><strong>⏺ q4osXpack ⏺</strong></font><br><br>"
kdtitle="■■ q4osXpack "
kdcaption="theme tools"
if [ "$EUID" -eq 0 ]
then
kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --error "This script must not be run as root. Please run it as normal user, elevated rights will be asked when needed. "
exit
fi

while true; do
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kdtext="$ktext
<font style='color:#828282'>►</font> Choose a script to launch:<br>
<font style='color:#828282'><em>(or hit cancel to quit)</em></font><br>"
menuchoice=$(kdialog --icon "$kdicon" --title "$kdtitle" --caption "$kdcaption" --geometry $(centerk 400 480) --menu "$kdtext" "userpic" "► select image for user picture" "loginbg" "► update login screen with current wallpaper" "randombg" "► apply random wallpaper for login & desktop" "userlist" "► display/hide users list at login screen" "clock" "► display/hide clock at login screen" "pointersz" "► change pointer size" "pointerclr" "► change pointer color (white/black)" "konsfont" "► choose Konsole font" "kmenued" "► launch Kmenu edit" "usage" "► normal/remote usage")

if [ $? -eq 1 ];then
break
else
case "$menuchoice" in
loginbg) LOGBK ;;
randombg) RANDWP ;;
userpic) USRPC ;;
*) ;;
esac
fi


done


