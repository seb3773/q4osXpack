#!/bin/bash
dark=0;helpdoc=0;lowres=0;customcolor=0
while [ "$#" -gt 0 ]; do
case "$1" in
-d | --dark)
dark=1
shift
;;
-L | --light)
dark=0
shift
;;
-c | --color)
if [ -n "$2" ] && [[ "$2" != -* ]]; then
customcolor=1
accent="${2//\"/}"
shift 2
else
customcolor=1
shift
fi
;;
-h | --help)
helpdoc=1
shift
;;
--)
shift
break
;;
*)
echo "Invalid option: $1" >&2
exit 1
;;
esac
done
if [ $helpdoc -eq 1 ]; then
script="Help Qtheme"
else
script="Qtheme script"
fi
source common/resizecons
source common/begin
source common/progress
source theme/colorpick
begin "   $script   "
#================================================================================================================



#========== set subscripts perms ================================================================================
progress "$script" 0
sudo chmod +x theme/grubscripts theme/themegrub theme/copyfiles theme/createdeko theme/colordeko common/pklist


#========== Retrieve resolution for res dependent elements ======================================================
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

osarch=$(dpkg --print-architecture)

#========== CREATE BACKUP FOLDER & backup files to be modified ==================================================
create_backup() {
local backup_path="backups/$now/$1.tar.gz"
sudo tar -zcvf "$backup_path" "$2" > /dev/null 2>&1
rota
}
echo -e "${RED}░░▒▒▓▓██\033[0m Backup...${NOCOLOR}"
now=$(date +"%Y-%m-%d_%I-%M%p")
sudo mkdir -p "backups/$now" > /dev/null 2>&1
#create_backup "shutimg" "/opt/trinity/share/apps/ksmserver/pics/shutdownkonq2.png"
create_backup "grub" "/etc/default/grub"
create_backup "konq_fm_entries" "$USER_HOME/.trinity/share/apps/konqsidebartng/filemanagement/entries/"
create_backup "ksides_pics" "/opt/trinity/share/apps/kicker/pics/kside*.*"
create_backup "qtcurve_stylerc" "$USER_HOME/.configtde/qtcurve/stylerc"
create_backup "tde_stylerc_qt" "$USER_HOME/.qt/tdestylerc"
create_backup "tde_stylerc_tqt3" "/etc/tqt3/tdestyler"
create_backup "qtrc_qt" "$USER_HOME/.qt/qtrc"
create_backup "qtrc_tqt3" "/etc/tqt3/qtrc"
create_backup "qtrc" "/root/.qt/qtrc"
create_backup "ksplashrc" "$USER_HOME/.trinity/share/config/ksplashrc"
create_backup "d3lphinrc" "$USER_HOME/.trinity/share/config/d3lphinrc"
create_backup "d3lphinrc_profiles" "$USER_HOME/.trinity/share/apps/d3lphin/"
create_backup "kcminputrc" "$TDEHOME/share/config/kcminputrc"
create_backup "kcminputrc_root" "/root/.config/kcminputrc"
create_backup "gtk3_settings_tde" "$USER_HOME/.configtde/gtk-3.0/settings.ini"
create_backup "gtk3_settings" "$USER_HOME/.config/gtk-3.0/settings.ini"
create_backup "gtk3_settings_tde_root" "/root/.configtde/gtk-3.0/settings.ini"
create_backup "gtk3_settings_root" "/root/.config/gtk-3.0/settings.ini"
create_backup "gtk4_settings_tde" "$USER_HOME/.configtde/gtk-4.0/settings.ini"
create_backup "gtk4_settings" "$USER_HOME/.config/gtk-4.0/settings.ini"
create_backup "gtk4_settings_tde_root" "/root/.configtde/gtk-4.0/settings.ini"
create_backup "gtk4_settings_root" "/root/.config/gtk-4.0/settings.ini"
create_backup "tdmrc" "/etc/trinity/tdm/tdmrc"
create_backup "backgroundrc" "/etc/trinity/tdm/backgroundrc"
create_backup "ksmserverrc" "$TDEHOME/share/config/ksmserverrc"
create_backup "kickerrc" "$TDEHOME/share/config/kickerrc"
create_backup "configtde_menu" "$USER_HOME/.configtde/menus/"
create_backup "kdeglobals" "$TDEHOME/share/config/kdeglobals"
create_backup "kdeglobals_root" "/root/.trinity/share/config/kdeglobals"
create_backup "twindeKoratorrc" "$USER_HOME/.trinity/share/config/twindeKoratorrc"
create_backup "twinrc" "$TDEHOME/share/config/twinrc"
create_backup "twinrc_root" "/root/.trinity/share/config/twinrc"
#create_backup "GTK3-Q4OS02" "/usr/share/themes/Q4OS02/gtk-3.0"
#create_backup "GTK2-Q4OS02" "/usr/share/themes/Q4OS02/gtk-2.0"
create_backup "xcompmgrrc" "$USER_HOME/.xcompmgrrc"
create_backup "xcompmgrrc_root" "/root/.xcompmgrrc"
create_backup "compton-tde" "$USER_HOME/.compton-tde.conf"
create_backup "compton-tde_root" "/root/.compton-tde.conf"
create_backup "kdesktoprc" "$TDEHOME/share/config/kdesktoprc"
create_backup "tdelaunchrc" "$TDEHOME/share/config/tdelaunchrc"
create_backup "kateschemarc" "$TDEHOME/share/config/kateschemarc"
create_backup "kateschemarc_root" "/root/.trinity/share/config/kateschemarc"
create_backup "konquerorrc_config" "$TDEHOME/share/config/konquerorrc"
create_backup "konquerorrc_apps" "$TDEHOME/share/apps/konqueror/"
create_backup "konquerorrc_root" "/root/.trinity/share/config/konquerorrc"
create_backup "ktaskbarrc" "$TDEHOME/share/config/ktaskbarrc"
create_backup "clock_panelapplet_rc" "$TDEHOME/share/config/clock_panelapplet_rc"
create_backup "kcmfonts" "$USER_HOME/.trinity/share/config/kcmfonts"
create_backup "gtkrc-q4os" "$USER_HOME/.gtkrc-q4os"
if [ -f "$USER_HOME/.gtkrc-2.0" ]; then
create_backup "gtkrc-2" "$USER_HOME/.gtkrc-2.0"
fi
create_backup "gtkrc-q4os_root" "/root/.gtkrc-q4os"
create_backup "launcher_panelapplet_rc" "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
create_backup "Xresources" "$USER_HOME/.Xresources"
create_backup "Xresources_root" "/root/.Xresources"
create_backup "x-cursor-theme" "/etc/alternatives/x-cursor-theme"
create_backup "knotify.eventsrc" "$TDEHOME/share/config/knotify.eventsrc"
create_backup "sounds" "/opt/trinity/share/sounds/"
create_backup "shutdown_img" "/opt/trinity/share/apps/tdm/pics/shutdown.jpg"
create_backup "keditrc" "$TDEHOME/share/config/keditrc"
create_backup "konsolerc" "$TDEHOME/share/config/konsolerc"
create_backup "systemtray_panelappletrc" "$TDEHOME/share/config/systemtray_panelappletrc"
create_backup  "tde_xsettingsd.conf" "$USER_HOME/.configtde/xsettingsd/xsettingsd.conf"
if [ -f "/root/xsettingsd.conf" ]; then
create_backup "root_xsettingsd.conf" "/root/xsettingsd.conf"
create_backup "root_config_xsettingsd.conf" "/root/.config/xsettingsd/xsettingsd.conf"
fi
create_backup "Trolltech.conf" "$USER_HOME/.config/Trolltech.conf"
create_backup "desktop-directories" "$USER_HOME/.local/share/desktop-directories/"
create_backup "desktop-directories_opt" "/opt/trinity/share/desktop-directories/"
create_backup "q4tde" "$USER_HOME/.configtde/q4tde"
create_backup "tdm_pic_users" "/opt/trinity/share/apps/tdm/pics/users/"
#
#.trinity/share/config/ksmserverrc
#.trinity/share/config/ksplashrc
#.trinity/share/config/gtkrc
#.trinity/share/config/kateschemarc
#.trinity/share/config/katerc
#.config/fontconfig/fonts.conf
rota
sudo \cp common/restore "backups/restore_$now"
sudo sed -i "s/XxXxXxXxX/$now/g" "backups/restore_$now"
sudo sed -i "s/YyYyYyYyY/Restoring backup created by qtheme script/g" "backups/restore_$now"
sudo chmod +x "backups/restore_$now"
rota
echo
printf '\e[A\e[K'
echo


hex_to_rgb() {
local hex_color="$1"
local r=$(printf "%d" 0x${hex_color:1:2})
local g=$(printf "%d" 0x${hex_color:3:2})
local b=$(printf "%d" 0x${hex_color:5:2})
echo "$r,$g,$b"
}
get_luminance() {
hex_color=$1
r=$((16#${hex_color:1:2}))
g=$((16#${hex_color:3:2}))
b=$((16#${hex_color:5:2}))
echo $(( (r*299 + g*587 + b*114 + 500) / 1000 ))
}
convert_to_rgb_hex() {
local x=$1
rgb_hex=$(printf "#%02x%02x%02x" $x $x $x)
echo $rgb_hex
}
calculate_gray_value() {
local r=$1
local g=$2
local b=$3
local result=$(( (r + g + b) / 3 ))
if (( result >= 0 && result <= 76 )); then
gray_value=$(( 7 + (result * (127 - 7)) / 76 ))
elif (( result >= 77 && result <= 179 )); then
gray_value=127
elif (( result >= 180 && result <= 255 )); then
gray_value=$(( 144 + ((result - 180) * (240 - 144)) / 75 ))
fi
echo $gray_value
}

itemdisp "Fetching latest version of the package list..."
sudo apt update > /dev/null 2>&1
sep
echo
echo
echo


#======== check if customcolor option specified and if there is a color specified
#================= if customcolor is 1 and there is no color given, show the 'color picker'
if [[ $customcolor -eq 1 ]]; then
echo -e "  \e[35m░▒▓█\033[0m Custom accent color"




if [ -z "$accent" ]; then 

if [[ $dark -eq 1 ]]
then
accentsettings=$(kreadconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "dark_custom_color")
themecolor="dark theme"
else
accentsettings=$(kreadconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "light_custom_color")
themecolor="light theme"
fi

echo " ► custom color specified, but no accent color given,"
if [ -n "$accentsettings" ]; then 
closest_color=$(find_closest_color "$accentsettings")
echo -e "  do you want to use previous custom color \e[48;5;${closest_color}m($accentsettings)\e[0m for theme accent color?"
echo -n "  (y:use previous color/enter:choose another color) ?" && read x
if [ "$x" == "y" ] || [ "$x" == "Y" ]; then
accent=$accentsettings
fi

fi
fi

if [ -z "$accent" ]; then 
echo "  please choose a color:"

while true; do
display_palette
selected_color=$(get_user_color)
if [[ "$selected_color" =~ ^[0-9]+$ ]] && ((selected_color >= 0 && selected_color <= 255)); then
display_selected_color "$selected_color"
if confirm_color_choice; then
hex_color=$(ansi_to_hex $selected_color)
break
fi
elif [[ "$selected_color" =~ ^#([0-9a-fA-F]{6})$ ]]; then
hex_color="#${BASH_REMATCH[1]}"
closest_color=$(find_closest_color "$hex_color")
echo "You choose to use hex color: $hex_color"
display_selected_color "$closest_color"
echo " (please note the displayed color preview is not the real color, but"
echo "  a close ansi color. The real color $hex_color will be used in the script)"
if confirm_color_choice; then
echo "You confirm hex color $hex_color."
break
fi
else
echo "Invalid choice. Please enter a number between 0 and 255, or an hexadecimal color value."
fi
done
accent=$hex_color
else
echo -e "  ${BLUE}»${NOCOLOR} Accent color: $accent"
echo
fi

if [[ $dark -eq 1 ]]
then
kwriteconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "dark_custom_color" "$accent"
else
kwriteconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "light_custom_color" "$accent"
fi

else

 if [[ $dark -eq 1 ]]
 then
 accent="#242424"
 #selectcolor=blue (actuel)
 else
 accent="#F8F8F8"
 #selectcolor=blue (actuel)
 fi

fi

#if [[ $dark -eq 1 ]]
#then
#accent2=$(theme/colordeko "$accent" l)
#else
accent2=$(theme/colordeko "$accent" d)
#fi

luminance=$(get_luminance $accent)
if [ $luminance -gt 60 ]; then
accent3=$(theme/colordeko "$accent" d)
else
accent3=$(theme/colordeko "$accent" l)
fi


rgb_accent=$(hex_to_rgb "$accent")
rgb_accent2=$(hex_to_rgb "$accent2")
rgb_accent3=$(hex_to_rgb "$accent3")

#========== retrieve packages list ==============================================================================
echo -e "   ${ORANGE}░▒▓█\033[0m Retrieve packages list..."
echo
cd common
sudo ./pklist
cd ..
echo



#========== Check if 7z is available, else install it ===========================================================
if ! (cat common/packages_list.tmp | grep -q "p7zip-full/stable"); then
echo -e "    ${BLUE}░▒▓█\033[0m Installing 7z..."
echo -e "${YELLOW}"
sudo apt install -y p7zip-full
echo -e "${NOCOLOR}"
fi


#========== Installing plymouth =================================================================================
itemdisp "Install plymouth..."
if ! (cat common/packages_list.tmp | grep -q "plymouth/stable"); then
echo -e "${YELLOW}"
sudo apt-get -y install plymouth
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
sep
echo
echo
echo


#========== Installing plymouth themes ==========================================================================
#not sure if really needed, maybe only creating the theme folder is ok ? Anyway it doesn't take too much disk space...
itemdisp "Install plymouth-themes..." 
if ! (cat common/packages_list.tmp | grep -q "plymouth-themes/stable"); then
echo -e "${YELLOW}"
sudo apt-get -y install plymouth-themes
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
sep
echo
echo
echo
progress "$script" 5




#========== Installing plymouth theme ala windows10 =============================================================
itemdisp "Install Q4Win10 plymouth theme..."
sudo tar -xzf theme/q4win10.tar.gz -C /usr/share/plymouth/themes
if ! (/usr/sbin/plymouth-set-default-theme)|grep -q "q4win10" ; then
sudo /usr/sbin/plymouth-set-default-theme -R q4win10
else
echo "plymouth theme q4win10 already set, skipping..."
fi
sep
echo
echo
echo
progress "$script" 10



#========== Installing grub theme ===============================================================================
itemdisp "Install grub theme..."
sudo mkdir -p /usr/share/grub/themes
sudo tar -xzf theme/q4os_seb.tar.gz -C /usr/share/grub/themes/
if [[ $lowres -eq 1 ]]; then
sudo tar -xzf theme/msboot.pf2_lowres.tar.gz -C /usr/share/grub/themes/q4os_seb/
sudo sed -i '/item_font =/c\item_font = "Microsoft YaHei Boot Regular 16"' /usr/share/grub/themes/q4os_seb/theme.txt
sudo sed -i '/font = "Microsoft YaHei Boot Regular 24"/c\font = "Microsoft YaHei Boot Regular 16"' /usr/share/grub/themes/q4os_seb/theme.txt
fi
if locale|grep -q "LANG=fr_FR."; then
sudo sed -i '/text = "Booting in %d s"/c\text = "Démarrage dans %d s"' /usr/share/grub/themes/q4os_seb/theme.txt
fi
### if someone can help me for the german term ?
#if locale|grep -q "LANG=de_DE."; then
#sudo sed -i '/text = "Booting in %d s"/c\text = "xxxxxx xx %d s"' /usr/share/grub/themes/q4os_seb/theme.txt
#fi
sep
echo
echo
echo
progress "$script" 15




#========== Shutdown images =====================================================================================
itemdisp "Copying shutdown image..."
sudo mkdir -p "$TDEHOME/share/apps/ksmserver/pics"
if [[ $dark -eq 1 ]]
then
sudo \cp theme/shutdownkonq2-dark.png "$TDEHOME/share/apps/ksmserver/pics/shutdownkonq2.png"
else
sudo \cp theme/shutdownkonq2.png "$TDEHOME/share/apps/ksmserver/pics/shutdownkonq2.png"
fi
#tdm can use a png image for this dialog, but we have to change extension to .jpg
sudo \cp theme/shutdownkonq2.png /opt/trinity/share/apps/tdm/pics/shutdown.jpg
sep
echo
echo
echo
progress "$script" 20



#========== quiet printk & grub scripts =========================================================================
# - quiet printk
# - modifications of '10_linux' & '30_uefi-firmware' to have nice icons in boot menu (classes added)
#   add shutdown option to grub menu
cd theme
sudo ./grubscripts
progress "$script" 25



#========== tuning grub for a quiet boot process ================================================================
sudo ./themegrub
progress "$script" 30




#========== copying all files needed ============================================================================
sudo ./copyfiles $dark
progress "$script" 35
cd ..







#========== splash screen =======================================================================================
itemdisp "Configuring splash screen at desktop loading..."
#kwriteconfig --file $TDEHOME/share/config/ksplashrc --group KSplash --key Theme Unified
kwriteconfig --file $TDEHOME/share/config/ksplashrc --group KSplash --key Theme "Redmond10_$USER"
sep
echo
echo
echo
progress "$script" 40





#========== Start menu configuration ============================================================================
itemdisp "Configuring start menu..."
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key CustomSize 40
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key BourbonMenu false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key LegacyKMenu true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Locked true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key AutoHidePanel false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key AutoHideSwitch false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key MenubarPanelTransparent false
rota
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key BackgroundHide false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key BourbonBoldFolders true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ColorizeBackground true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ExpandSize true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowLeftHideButton false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowRightHideButton false
rota
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Size 4
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key SizePercentage 100
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintValue 91
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key MenubarPanelBlurred true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Transparent true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key panelIconWidth 48
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowDeepButtons false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key UseBackgroundTheme false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ColorizeBackground false
rota
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowIconActivationEffect false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowLeftHideButton false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowRightHideButton false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key UseSidePixmap true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key SearchShortcut ""
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key CustomIcon "/usr/share/pixmaps/StartHere.png"
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key ShowText false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key EnableBrowserTiles false
rota
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key EnableDesktopButtonTiles false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key EnableKMenuTiles false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key EnableURLTiles false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key EnableWindowListTiles false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key KMenuTile Colorize
rota
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key UseSearchBar true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key RecentVsOften true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key NumVisibleEntries 0
kwriteconfig --file $TDEHOME/share/config/kickerrc --group buttons --key EnableIconZoom true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group buttons --key EnableTileBackground false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key MenuEntryHeight 28
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key ShowMenuTitles false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key KMenuTileColor "218,83,34"
if [[ $dark -eq 1 ]]
then
 if [[ $customcolor -eq 1 ]]; then
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintColor "$rgb_accent"
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key ClassicKMenuBackgroundColor "$rgb_accent"
 else
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintColor "36,36,36"
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key ClassicKMenuBackgroundColor "36,36,36"
 fi
else
 if [[ $customcolor -eq 1 ]]; then
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintColor "$rgb_accent"
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key ClassicKMenuBackgroundColor "$rgb_accent"
 else
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintColor "248,248,248"
 kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key ClassicKMenuBackgroundColor "248,248,248"
 fi
fi
#menu with categories (& kmenuedit available)
rm -f $USER_HOME/.configtde/menus/tde-applications.menu
rota
pathfold="$USER_HOME/.local/share/desktop-directories/"
if [[ -d $pathfold ]]; then
cd $pathfold
for FILE in *;
do
sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
if [ "$FILE" = "tde-settingsmenu.directory" ]; then
sed -i '/Icon=/c\Icon=menu-settings' "$pathfold$FILE"
fi
if [ "$FILE" = "chrome-apps.directory" ]; then
sed -i '/Icon=/c\Icon=folder_html' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-multimedia.directory" ]; then
sed -i '/Icon=/c\Icon=default-folder-video' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-internet.directory" ]; then
sed -i '/Icon=/c\Icon=folder_html' "$pathfold$FILE"
fi
done
cd - > /dev/null 2>&1
fi

pathfold="/opt/trinity/share/desktop-directories/"
cd $pathfold
for FILE in *;
do
if [ "$FILE" = "tde-system.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-settingsmenu.directory" ]; then
sudo sed -i '/Icon=/c\Icon=menu-settings' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-multimedia.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder-video' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-utilities.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-graphics.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-internet.directory" ]; then
sudo sed -i '/Icon=/c\Icon=folder_html' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-development.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-editors.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-games.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-office.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-science.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-toys.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-edutainment.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
if [ "$FILE" = "tde-unknown.directory" ]; then
sudo sed -i '/Icon=/c\Icon=default-folder' "$pathfold$FILE"
fi
done
cd - > /dev/null 2>&1
rota
#config launcher_panelapplet_modernui_rc (add browser if one found)
if (cat common/packages_list.tmp | grep -q "google-chrome-stable"); then
    sed -i 's/\(Buttons=.*\)/\1,google-chrome.desktop/' "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
elif (cat common/packages_list.tmp | grep -q "chromium/stable"); then
    sed -i 's/\(Buttons=.*\)/\1,chromium.desktop/' "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
elif (cat common/packages_list.tmp | grep -q "firefox/mozilla"); then
    sed -i 's/\(Buttons=.*\)/\1,firefox.desktop/' "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
elif (cat common/packages_list.tmp | grep -q "microsoft-edge-stable"); then
    sed -i 's/\(Buttons=.*\)/\1,microsoft-edge.desktop/' "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
elif (cat common/packages_list.tmp | grep -q "falkon/stable"); then
    sed -i 's/\(Buttons=.*\)/\1,org.kde.falkon.desktop/' "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
fi
echo
printf '\e[A\e[K'
sep
echo
echo
echo
progress "$script" 45





#========== windows style with qtcurve ==========================================================================
itemdisp "Configuring windows style..."
echo -e "  \e[35m░▒▓█\033[0m installing qtcurve-trinity..."
if ! (cat common/packages_list.tmp | grep -q tde-style-qtcurve-trinity); then
echo -e "${YELLOW}"
sudo apt install -y tde-style-qtcurve-trinity
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key widgetStyle qtcurve
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key ShowIconsOnPushButtons false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key EffectsEnabled false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key ShowKonqIconActivationEffect false
if [ ! -f "$USER_HOME/.gtkrc-2.0" ]; then
\cp theme/gtkrc2 "$USER_HOME/.gtkrc-2.0"
fi
if [ ! -f "/root/.gtkrc-2.0" ]; then
sudo \cp theme/gtkrc2 "/root/.gtkrc-2.0"
fi
sed -i '/gtk-button-images="/c\gtk-button-images=0' $USER_HOME/.gtkrc-2.0
sed -i '/gtk-button-images="/c\gtk-button-images=0' $USER_HOME/.gtkrc-q4os
sed -i '/gtk-theme-name="/c\gtk-theme-name="Q4OSWIN10"' $USER_HOME/.gtkrc-q4os
sed -i '/gtk-theme-name="/c\gtk-theme-name="Q4OSWIN10"' $USER_HOME/.gtkrc-2.0
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key widgetStyle qtcurve
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key ShowIconsOnPushButtons false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key EffectsEnabled false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key ShowKonqIconActivationEffect false
sudo sed -i '/gtk-button-images="/c\gtk-button-images=0' /root/.gtkrc-2.0
sudo sed -i '/gtk-button-images="/c\gtk-button-images=0' /root/.gtkrc-q4os
sudo sed -i '/gtk-theme-name="/c\gtk-theme-name="Q4OSWIN10"' /root/.gtkrc-q4os
sudo sed -i '/gtk-theme-name="/c\gtk-theme-name="Q4OSWIN10"' /root/.gtkrc-2.0
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-theme-name Q4OSWIN10
sep
echo
echo
echo
progress "$script" 50





#========== windows decorations & management ====================================================================
itemdisp "Configuring windows decoration & windows management..."
echo
echo -e "  \e[35m░▒▓█\033[0m installing Dekorator for trinity..."
if ! (cat common/packages_list.tmp | grep -q twin-style-dekorator-trinity); then
echo -e "${YELLOW}"
sudo apt install -y twin-style-dekorator-trinity
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
echo -e "  \e[35m░▒▓█\033[0m installing imagemagick..."
if ! (cat common/packages_list.tmp | grep -q "imagemagick/stable" ); then
echo -e "${YELLOW}"
sudo apt install -y imagemagick
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
echo -e "  \e[35m░▒▓█\033[0m Generating windows decorations..."
if [[ $dark -eq 1 ]]; then
sudo theme/createdeko "$accent" "$accent2" "WinTenBasedark"
#sudo tar -xzf theme/WinTen-seb-theme-dark.tar.gz -C /opt/trinity/share/apps/deKorator/themes
sudo tar -xzf theme/twindeKoratorrc-dark.tar.gz -C $USER_HOME/.trinity/share/config/
else
sudo theme/createdeko "$accent" "$accent2" "WinTenBaselight"
#sudo tar -xzf theme/WinTen-seb-theme.tar.gz -C /opt/trinity/share/apps/deKorator/themes
sudo tar -xzf theme/twindeKoratorrc.tar.gz -C $USER_HOME/.trinity/share/config/
fi

#---- kside custom accent color

## old method (try to generate a grey image which will be near to accent color when colorized)
#if [[ $customcolor -eq 1 ]]; then
#IFS=',' read -r r g b <<< "$rgb_accent"
#vgrey=$(calculate_gray_value $r $g $b)
#kcolor=$(convert_to_rgb_hex $vgrey)
#sudo convert -size 24x340 xc:${kcolor} $TDEHOME/share/apps/kicker/pics/kside.png
#sudo convert -size 24x4 xc:${kcolor} $TDEHOME/share/apps/kicker/pics/kside_tile.png
#fi

## new method, make use of Q4OS team modification (ColorizeSidePixmap=false)
sudo mkdir -p $TDEHOME/share/apps/kicker/pics
sudo convert -size 24x340 xc:${accent} $TDEHOME/share/apps/kicker/pics/kside.png
sudo convert -size 24x4 xc:${accent} $TDEHOME/share/apps/kicker/pics/kside_tile.png
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key SideName kside.png
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key SideTileName kside_tile.png
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key ColorizeSidePixmap false

#kickerbar rgb_accent
#sudo convert -size 2x60 xc:${accent} $TDEHOME/share/apps/kicker/pics/panel-win.png



echo
echo -e "  \e[35m░▒▓█\033[0m configuring style..."
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key InactiveShadowColour "0,0,0"
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowColour "0,0,0"
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key PluginLib twin3_deKorator
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key BorderSize 2
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ButtonsOnLeft "M_"
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ButtonsOnRight "IAX"
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key CustomButtonPositions true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key InactiveShadowEnabled false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key InactiveShadowOpacity 0.7
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key InactiveShadowThickness 5
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key InactiveShadowXOffset 0
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key InactiveShadowYOffset 5
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowDocks false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowEnabled false
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowOpacity 0.7
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowOverrides false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowThickness 10
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowTopMenus false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowXOffset 0
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShadowYOffset 10
kwriteconfig --file $TDEHOME/share/config/twinrc --group Style --key ShowToolTips false
kwriteconfig --file $TDEHOME/share/config/twinrc --group ThirdPartyWM --key WMExecutable twin
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key ActiveWindowOpacity 90
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key ActiveWindowShadowSize 300
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key DockOpacity 80
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key DockShadowSize 0
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key InactiveWindowOpacity 85
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key InactiveWindowShadowSize 100
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key MenuShadowSize 0
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key MovingWindowOpacity 70
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key OnlyDecoTranslucent false
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key RemoveShadowsOnMove true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key RemoveShadowsOnResize true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key ResetKompmgr false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key TranslucentActiveWindows false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key TranslucentDocks false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key TranslucentInactiveWindows false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key TranslucentMovingWindows false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Translucency --key TreatKeepAboveAsActive true
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ActiveBorderDelay 50
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ActiveBorders 4
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ActiveBorderDistance 5
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key TilingMode Opaque
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ActiveMouseScreen false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key AltTabStyle KDE
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key AnimateMinimize false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key AnimateMinimizeSpeed 5
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key AnimateShade false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key AutoRaise off
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key BorderSnapZone 10
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ClickRaise on
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key DelayFocus off
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key DelayFocusInterval 750
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key FocusPolicy ClickToFocus
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key FocusStealingPreventionLevel 1
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key GeometryTip false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key HideUtilityWindowsForInactive true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key MaximizeButtonLeftClickCommand Maximize
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key MoveResizeMaximizedWindows false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key Placement Smart
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ResetMaximizedWindowGeometry false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ResizeMode Transparent
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key RollOverDesktops true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key SeparateScreenFocus false
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ShadeHover off
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key SnapOnlyWhenOverlapping true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key TitlebarDoubleClickCommand Maximize
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key WindowSnapZone 10
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key MoveResizeMaximizedWindows true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ResetMaximizedWindowGeometry true
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key Placement Centered
kwriteconfig --file $TDEHOME/share/config/twinrc --group Desktops --key Number 1
rota
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandWindow1 "Activate, raise and pass click"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandWindow2 "Activate and pass click"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandWindow3 "Activate and pass click"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandActiveTitlebar1 Raise
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandActiveTitlebar2 Lower
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandActiveTitlebar3 Operations menu
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandAll1 Move
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandAll2 "Toggle raise and lower"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandAll3 Resize
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandAllKey Alt
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandAllReverseWheel false
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandAllWheel Nothing
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandInactiveTitlebar1 "Activate and raise"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandInactiveTitlebar2 "Activate and lower"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandInactiveTitlebar3 "Operations menu"
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandTitlebarReverseWheel false
kwriteconfig --file $TDEHOME/share/config/twinrc --group MouseBindings --key CommandTitlebarWheel Nothing
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group "Toolbar style" --key TransparentMoving "true"
######### random bug with desktop redrawing icons - need to find out why. too bad as the text with shadows looks much better
###seems to be related to Qtcurve style, this bug doesn't appear when using another style...
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group FMSettings --key ShadowEnabled false
#############


rota
#root
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key InactiveShadowColour "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowColour "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key PluginLib twin3_deKorator
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key BorderSize 2
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ButtonsOnLeft "M_"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ButtonsOnRight "IAX"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key CustomButtonPositions true
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key InactiveShadowEnabled false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key InactiveShadowOpacity 0.7
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key InactiveShadowThickness 5
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key InactiveShadowXOffset 0
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key InactiveShadowYOffset 5
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowDocks false
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowEnabled false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowOpacity 0.7
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowOverrides false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowThickness 10
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowTopMenus false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowXOffset 0
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShadowYOffset 10
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Style --key ShowToolTips false
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group ThirdPartyWM --key WMExecutable twin
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key ActiveWindowOpacity 90
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key ActiveWindowShadowSize 300
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key DockOpacity 80
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key DockShadowSize 0
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key InactiveWindowOpacity 85
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key InactiveWindowShadowSize 100
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key MenuShadowSize 0
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key MovingWindowOpacity 70
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key OnlyDecoTranslucent false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key RemoveShadowsOnMove true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key RemoveShadowsOnResize true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key ResetKompmgr false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key TranslucentActiveWindows false
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key TranslucentDocks false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key TranslucentInactiveWindows false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key TranslucentMovingWindows false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Translucency --key TreatKeepAboveAsActive true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveBorderDelay 50
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveBorders 4
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveMouseScreen false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveBorderDistance 5
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key TilingMode Opaque
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key AltTabStyle KDE
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key AnimateMinimize false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key AnimateMinimizeSpeed 5
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key AnimateShade false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key AutoRaise off
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key BorderSnapZone 10
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ClickRaise on
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key DelayFocus off
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key DelayFocusInterval 750
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key FocusPolicy ClickToFocus
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key FocusStealingPreventionLevel 1
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key GeometryTip false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key HideUtilityWindowsForInactive true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key MaximizeButtonLeftClickCommand Maximize
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key MoveResizeMaximizedWindows false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key Placement Smart
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ResetMaximizedWindowGeometry false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ResizeMode Transparent
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key RollOverDesktops true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key SeparateScreenFocus false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ShadeHover off
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key SnapOnlyWhenOverlapping true
rota
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key TitlebarDoubleClickCommand Maximize
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key WindowSnapZone 10
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key MoveResizeMaximizedWindows true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ResetMaximizedWindowGeometry true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key Placement Centered
#sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key MoveMode Opaque
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Desktops --key Number 1
#sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group "Notification Messages" --key UseTranslucency true
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandWindow1 "Activate, raise and pass click"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandWindow2 "Activate and pass click"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandWindow3 "Activate and pass click"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandActiveTitlebar1 Raise
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandActiveTitlebar2 Lower
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandActiveTitlebar3 Operations menu
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandAll1 Move
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandAll2 "Toggle raise and lower"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandAll3 Resize
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandAllKey Alt
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandAllReverseWheel false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandAllWheel Nothing
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandInactiveTitlebar1 "Activate and raise"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandInactiveTitlebar2 "Activate and lower"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandInactiveTitlebar3 "Operations menu"
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandTitlebarReverseWheel false
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group MouseBindings --key CommandTitlebarWheel Nothing
######### random bug with desktop redrawing icons - need to find out why. too bad as the text with shadows looks much better
sudo kwriteconfig --file /root/.trinity/share/config/kdesktoprc --group FMSettings --key ShadowEnabled false
#######
rota
echo
printf '\e[A\e[K'

echo -e "  \e[35m░▒▓█\033[0m enabling compton-tde compositing..."
kwriteconfig --file $TDEHOME/share/config/twinrc --group "Windows" --key "MoveMode" "Opaque"
kwriteconfig --file $TDEHOME/share/config/twinrc --group "Notification Messages" --key "UseTranslucency" true

echo -e "  \e[35m░▒▓█\033[0m configuring GTK2/GTK3/GTK4 styles..."
#to do: edit values in
#  $USER_HOME/configtde/gtk-3.0/settings.ini
#
sudo mkdir -p /usr/share/themes/Q4OSWIN10/gtk-3.0/
sudo mkdir -p /usr/share/themes/Q4OSWIN10/gtk-2.0/
sudo rm -rf /usr/share/themes/Q4OSWIN10/gtk-3.0/{*,.[!.]*}
sudo mkdir -p $USER_HOME/.configtde/gtk-4.0
sudo rm -rf $USER_HOME/.configtde/gtk-4.0/{*,.[!.]*}
sudo rm -rf $USER_HOME/.config/gtk-4.0/{*,.[!.]*}
if [[ $dark -eq 1 ]]; then
sudo tar -xzf theme/gtk3winten-dark.tar.gz -C  /usr/share/themes/Q4OSWIN10/gtk-3.0/
sudo tar -xzf theme/gtk2winten-dark.tar.gz -C  /usr/share/themes/Q4OSWIN10/gtk-2.0/
sudo tar -xzf theme/gtk4winten-dark.tar.gz -C  $USER_HOME/.configtde/gtk-4.0/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme-dark/buttons/hover/* /usr/share/themes/Q4OSWIN10/gtk-3.0/assets/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme-dark/buttons/normal/* /usr/share/themes/Q4OSWIN10/gtk-3.0/assets/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme-dark/buttons/press/* /usr/share/themes/Q4OSWIN10/gtk-3.0/assets/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme-dark/buttons/hover/* $USER_HOME/.configtde/gtk-4.0/assets
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme-dark/buttons/normal/* $USER_HOME/.configtde/gtk-4.0/assets
else
sudo tar -xzf theme/gtk3winten.tar.gz -C  /usr/share/themes/Q4OSWIN10/gtk-3.0/
sudo tar -xzf theme/gtk2winten.tar.gz -C  /usr/share/themes/Q4OSWIN10/gtk-2.0/
sudo tar -xzf theme/gtk4winten.tar.gz -C  $USER_HOME/.configtde/gtk-4.0/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme/buttons/hover/* /usr/share/themes/Q4OSWIN10/gtk-3.0/assets/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme/buttons/normal/* /usr/share/themes/Q4OSWIN10/gtk-3.0/assets/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme/buttons/press/* /usr/share/themes/Q4OSWIN10/gtk-3.0/assets/
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme/buttons/hover/* $USER_HOME/.configtde/gtk-4.0/assets
sudo \cp /opt/trinity/share/apps/deKorator/themes/WinTen-seb-theme/buttons/normal/* $USER_HOME/.configtde/gtk-4.0/assets
fi

#ADJUST GTK3 colors (+selected color GTK2)
#if [[ $customcolor -eq 1 ]]; then
sudo sed -E -i 's/(selected_bg_color:#)[0-9A-Fa-f]+/\1'"${accent3/#\#/}"'/g' /usr/share/themes/Q4OSWIN10/gtk-2.0/gtkrc
sudo sed -i 's/@define-color theme_selected_bg_color .*/@define-color theme_selected_bg_color '"$accent3"';/' /usr/share/themes/Q4OSWIN10/gtk-3.0/gtk.css
acct="$accent}"
sudo sed -i '/decoration{.*border-color:/ s/border-color:[^;]*/border-color:'"$acct"'/g' /usr/share/themes/Q4OSWIN10/gtk-3.0/gtk-contained.css
sudo sed -i '/\.titlebar,headerbar{.*background-color:@theme_base_color;/ s/@theme_base_color/'"$accent"'/g' /usr/share/themes/Q4OSWIN10/gtk-3.0/gtk-contained.css
sudo sed -i '/button.titlebutton{.*background-image:none;/ s/background-image:none;/&background-color:'"$accent"';/' /usr/share/themes/Q4OSWIN10/gtk-3.0/gtk-contained.css
sudo sed -i '/button.titlebutton:hover{.*color:.*background-color:/ s/@theme_bg_color/'"$accent"'/g' /usr/share/themes/Q4OSWIN10/gtk-3.0/gtk-contained.css
sudo sed -i '/button.titlebutton:active{.*color:.*background-color:/ s/@theme_bg_color/'"$accent"'/g' /usr/share/themes/Q4OSWIN10/gtk-3.0/gtk-contained.css
b_accent="background-color: $accent"
sudo sed -E -i '/^headerbar[[:space:]]*\{/ s/(background-color:[[:space:]]*#[0-9a-fA-F]*)/'"$b_accent"'/g' $USER_HOME/.configtde/gtk-4.0/gtk.css
bb_accent="border-bottom: 1px solid $accent"
sudo sed -E -i '/^headerbar[[:space:]]*\{/ s/(border-bottom:[[:space:]]*[^;]*)/'"$bb_accent"'/g' $USER_HOME/.configtde/gtk-4.0/gtk.css
wb_accent="border: solid 1px $accent2"
sudo sed -E -i '/^window\.solid-csd[[:space:]]*\{/ s/(border:[[:space:]]*[^;]*)/'"$wb_accent"'/g' $USER_HOME/.configtde/gtk-4.0/gtk.css
wbb_accent="box-shadow: inset 0 0 0 4px $accent, inset 0 0 0 3px $accent"
sudo sed -E -i '/^window\.solid-csd[[:space:]]*\{/ s/(box-shadow:[[:space:]]*[^;]*)/'"$wbb_accent"'/g' $USER_HOME/.configtde/gtk-4.0/gtk.css
wbs_accent="box-shadow: inset 0 0 0 4px $accent, inset 0 0 0 3px $accent" 
sudo sed -E -i '/^window\.solid-csd:backdrop[[:space:]]*\{/ s/(box-shadow:[[:space:]]*[^;]*)/'"$wbs_accent"'/g' $USER_HOME/.configtde/gtk-4.0/gtk.css
wbm_accent="box-shadow: inset 0 0 0 3px $accent"
sudo sed -E -i '/^window\.maximized[[:space:]]*\{/ s/(box-shadow:[[:space:]]*[^;]*)/'"$wbm_accent"'/g' $USER_HOME/.configtde/gtk-4.0/gtk.css
#fi
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-theme-name Q4OSWIN10
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-theme-name Q4OSWIN10



echo -e "  \e[35m░▒▓█\033[0m configuring xcompmgr..."
#sudo kwriteconfig --file $USER_HOME/.xcompmgrrc --group xcompmgr --key useOpenGL true
sudo tar -xzf theme/xcompmgrrc.tar.gz -C $USER_HOME/
sudo tar -xzf theme/xcompmgrrc.tar.gz -C /root/
echo -e "  \e[35m░▒▓█\033[0m configuring compton-tde..."
if [[ $dark -eq 1 ]]; then
#sudo is needed for this extraction as we want the root user owner for this file, this is is
#because without that, the configuration (especially the exclude part) is destroyed by trinity if we want to adjust something
#from the cli configuration panel. We don't want that. But by doing this, the configuration panel can't be used to ajust settings.
sudo tar -xzf theme/compton-tde.conf-dark.tar.gz -C $USER_HOME/
sudo tar -xzf theme/compton-tde.conf-dark.tar.gz -C /root
else
sudo tar -xzf theme/compton-tde.conf.tar.gz -C $USER_HOME/
sudo tar -xzf theme/compton-tde.conf.tar.gz -C /root
fi
echo -e "  \e[35m░▒▓█\033[0m disable screensaver & lock after suspend..."
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group ScreenSaver --key Enabled false
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group ScreenSaver --key Lock false
echo -e "  \e[35m░▒▓█\033[0m Configuring Konqueror ui..."
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key AlwaysNewWin false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key DisplayFileSizeInBytes false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key DoubleClickMoveToParent false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key HoverCloseButton true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key MMBOpensTab false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key ShowFileTips true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key ShowPreviewsInFileTips false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key StandardFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file $TDEHOME/share/config/konqiconviewrc --group Settings --key IconSize 48

rota
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key TabCloseActivatePrevious true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key TextHeight 2
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key UnderlineLinks false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group Trash --key ConfirmDelete true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group Trash --key ConfirmTrash false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KFileDialog Settings" --key "Automatic Preview" true
sudo kwriteconfig --file $TDEHOME/share/config/tdecmshellrc --group "KFileDialog Settings" --key "Automatic Preview" true
rota
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar Speech Toolbar" --key IconText IconOnly
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar Speech Toolbar" --key Index 4
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar bookmarkToolBar" --key Hidden true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar bookmarkToolBar" --key IconText IconTextRight
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar bookmarkToolBar" --key Index 1
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar extraToolBar" --key IconText IconOnly
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar extraToolBar" --key Index 2
rota
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar locationToolBar" --key IconText IconOnly
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar locationToolBar" --key Index 3
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar mainToolBar" --key IconSize 32
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar mainToolBar" --key IconText IconTextBottom
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar mainToolBar" --key Index 0
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar mainToolBar" --key Offset 19
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4fmToolBar1" --key IconText IconTextRight
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4fmToolBar1" --key Index 2
rota
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4fmToolBar2" --key IconText IconOnly
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4fmToolBar2" --key Index 4
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4wbToolBar1" --key Hidden true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4wbToolBar1" --key IconText IconTextRight
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4wbToolBar1" --key Index 5
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4wbToolBar2" --key Hidden true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4wbToolBar2" --key IconText IconTextRight
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KonqMainWindow Toolbar q4wbToolBar2" --key Index 6
rota
sudo kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PreviewSettings --key UseFileThumbnails true
sudo kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PreviewSettings --key BoostSize true
sudo kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PreviewSettings --key file true
sudo kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PreviewSettings --key home true
sudo kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PreviewSettings --key system true
sudo kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PreviewSettings --key MaximumSize 20971520
rota
deskfold=$(xdg-user-dir DESKTOP)
picfold=$(xdg-user-dir PICTURES)
docfold=$(xdg-user-dir DOCUMENTS)
musicfold=$(xdg-user-dir MUSIC)
vidfold=$(xdg-user-dir VIDEOS)
vidfoldroot=$(sudo xdg-user-dir VIDEOS)
downlfold=$(xdg-user-dir DOWNLOAD)
usrfold=$(xdg-user-dir USER)
downlfoldroot=$(xdg-user-dir DOWNLOAD)
#~~~~~~~~~~~~~~~~~~~~~ if dolphin is installed
if [[ -f "$TDEHOME/share/config/d3lphinrc" ]]; then
echo -e "  \e[35m░▒▓█\033[0m Configuring Dolphin ui..."
mkdir -p $TDEHOME/share/apps/d3lphin/
sudo tar -xzf theme/d3lphinui.rc.tar.gz -C $TDEHOME/share/apps/d3lphin/
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "D3lphin Toolbar style" --key IconSize 32
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "Details Mode" --key "Font Family" "Segoe UI"
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "Details Mode" --key "Font Size" 10
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "Icons Mode" --key Arrangement "Left to Right"
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "Icons Mode" --key "Font Family" "Segoe UI"
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "Icons Mode" --key "Font Size" 10
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "MainWindow Toolbar mainToolBar" --key IconSize 32
kwriteconfig --file $TDEHOME/share/config/d3lphinrc --group "MainWindow Toolbar mainToolBar" --key IconText IconTextBottom
#root
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "D3lphin Toolbar style" --key IconSize 32
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "Details Mode" --key "Font Family" "Segoe UI"
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "Details Mode" --key "Font Size" 10
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "Icons Mode" --key Arrangement "Left to Right"
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "Icons Mode" --key "Font Family" "Segoe UI"
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "Icons Mode" --key "Font Size" 10
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "MainWindow Toolbar mainToolBar" --key IconSize 32
sudo kwriteconfig --file /root/.trinity/share/config/d3lphinrc --group "MainWindow Toolbar mainToolBar" --key IconText IconTextBottom
rota
cat << EOF > $TDEHOME/share/apps/d3lphin/bookmarks.xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xbel>
<xbel>
 <bookmark icon="computer" href="system:/" >
<title>Systeme</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="desktop" href="file://$deskfold" >
<title>Bureau</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="folder_doc_q4os_startmenu" href="file://$docfold" >
<title>Documents</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="folder-pictures" href="file://$picfold" >
<title>Images</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="folder-music" href="file://$musicfold" >
<title>Musique</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="folder-download" href="file://$downlfold" >
<title>Téléchargements</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="folder_video" href="file://$vidfold" >
<title>Vidéos</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="folder_home" href="file://$usrfold" >
<title>Dossier personnel</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
<bookmark icon="network_local" href="remote:/" >
<title>Réseau</title>
<info>
<metadata owner="http://www.kde.org" />
</info>
</bookmark>
</xbel>
EOF
fi
#~~~~~~~~~~~~~~~~~~~~~ end if dolphin
echo -e "  \e[35m░▒▓█\033[0m Adjusting folders icons"
cat << EOF > $downlfold/.directory
[Desktop Entry]
Icon=folder-download
EOF
cat << EOF > $vidfold/.directory
[Desktop Entry]
Icon=folder-videos
EOF
rota
echo
printf '\e[A\e[K'
sep
echo
echo
echo
progress "$script" 55




#========== No start indicator (no cpu cycles wasting ;) ) ======================================================
itemdisp "Disabling start indicator"
kwriteconfig --file $TDEHOME/share/config/tdelaunchrc --group BusyCursorSettings --key Blinking false
kwriteconfig --file $TDEHOME/share/config/tdelaunchrc --group BusyCursorSettings --key Bouncing false
kwriteconfig --file $TDEHOME/share/config/tdelaunchrc --group BusyCursorSettings --key Timeout 12
kwriteconfig --file $TDEHOME/share/config/tdelaunchrc --group FeedbackStyle --key BusyCursor false
kwriteconfig --file $TDEHOME/share/config/tdelaunchrc --group FeedbackStyle --key TaskbarButton false
sep
echo
echo
echo
progress "$script" 60




#========== Pointers ============================================================================================
itemdisp "Configuring pointers & set acceleration to 1"
#pointer size
#32 /48 /64 /
pointersizesetting=$(kreadconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "pointersize")
pointercolorsetting=$(kreadconfig --file $USER_HOME/.q4oswin10.conf --group "Settings" --key "pointercolor")

if [ -n "$pointersizesetting" ]; then
if [ "$pointersizesetting" == "default" ]; then
ptsize=32
else
ptsize=$pointersizesetting
fi
else
ptsize=32
fi

if [ -n "$pointercolorsetting" ]; then
if [ "$pointercolorsetting" == "Dark" ]; then
pc="Dark"
else
pc="Light"
fi
else
pc="Light"
fi


if ! grep -q "Xcursor.size" "$USER_HOME/.Xresources"; then
echo "Xcursor.size: $ptsize" | sudo tee -a $USER_HOME/.Xresources
fi
sudo sed -i "/Xcursor.size:/c\Xcursor.size: $ptsize" $USER_HOME/.Xresources


if ! grep -q "Xcursor.theme" "$USER_HOME/.Xresources"; then
echo "Xcursor.theme: Windows10$pc" | sudo tee -a $USER_HOME/.Xresources
fi
sudo sed -i "/Xcursor.theme:/c\Xcursor.theme: Windows10$pc" $USER_HOME/.Xresources

if ! grep -q "Xcursor.size" "/root/.Xresources"; then
echo "Xcursor.size: $ptsize" | sudo tee -a /root/.Xresources
fi
sudo sed -i "/Xcursor.size:/c\Xcursor.size: $ptsize" /root/.Xresources

if ! grep -q "Xcursor.theme" "/root/.Xresources"; then
echo "Xcursor.theme: Windows10$pc" | sudo tee -a /root/.Xresources
fi
sudo sed -i "/Xcursor.theme:/c\Xcursor.theme: Windows10$pc" /root/.Xresources
#
kwriteconfig --file $TDEHOME/share/config/kcminputrc --group Mouse --key cursorTheme Windows10$pc
kwriteconfig --file $TDEHOME/share/config/kcminputrc --group Mouse --key Acceleration 1
kwriteconfig --file $USER_HOME/.trinitykde/share/config/kcminputrc --group Mouse --key cursorTheme Windows10$pc
kwriteconfig --file $USER_HOME/.trinitykde/share/config/kcminputrc --group Mouse --key Acceleration 1
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
kwriteconfig --file $USER_HOME/.configtde/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
kwriteconfig --file $USER_HOME/.config/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc

sudo kwriteconfig --file /root/.config/kcminputrc --group Mouse --key cursorTheme Windows10$pc
sudo kwriteconfig --file /root/.config/kcminputrc --group Mouse --key Acceleration 1
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
sudo kwriteconfig --file /root/.configtde/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
sudo kwriteconfig --file /root/.config/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10$pc
sudo kwriteconfig --file /root/.trinity/share/config/kcminputrc --group Mouse --key cursorTheme Windows10$pc
sudo kwriteconfig --file /root/.trinitykde/share/config/kcminputrc --group Mouse --key cursorTheme Windows10$pc
#cursor theme for x
sudo mkdir -p  /etc/X11/cursors
sudo \cp /usr/share/icons/Windows10$pc/cursor.theme /etc/X11/cursors/Windows10$pc\_cursor.theme
sudo ln -nfs /etc/X11/cursors/Windows10$pc\_cursor.theme /etc/alternatives/x-cursor-theme
sudo ln -nfs /etc/alternatives/x-cursor-theme /usr/share/icons/default/index.theme
if [ "$1" = "Dark" ]
then 
sed -i '/gtk-cursor-theme-name="/c\gtk-cursor-theme-name="Windows10Dark"' $USER_HOME/.gtkrc-2.0
sudo sed -i '/gtk-cursor-theme-name="/c\gtk-cursor-theme-name="Windows10Dark"' /root/.gtkrc-2.0
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Dark"' "$USER_HOME/.configtde/xsettingsd/xsettingsd.conf"
if [ -f "/root/xsettingsd.conf" ]; then
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Dark"' "$USER_HOME/.config/xsettingsd/xsettingsd.conf"
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Dark"' "/root/xsettingsd.conf"
fi
else
sed -i '/gtk-cursor-theme-name="/c\gtk-cursor-theme-name="Windows10Light"' $USER_HOME/.gtkrc-2.0
sudo sed -i '/gtk-cursor-theme-name="/c\gtk-cursor-theme-name="Windows10Light"' /root/.gtkrc-2.0
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Light"' "$USER_HOME/.configtde/xsettingsd/xsettingsd.conf"
if [ -f "/root/xsettingsd.conf" ]; then
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Light"' "$USER_HOME/.config/xsettingsd/xsettingsd.conf"
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Light"' "/root/xsettingsd.conf"
fi
fi
sep
echo
echo
echo
progress "$script" 65





#========== Color scheme & win10 & 11 wallpapers ================================================================
itemdisp "Applying color scheme & wallpaper..."
wallpn=$(( $RANDOM % 25 + 1 ))
rwallp=q4seb_hd_win_$wallpn.jpg
dcop kdesktop KBackgroundIface setWallpaper /opt/trinity/share/wallpapers/$rwallp 6
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key alternateBackground "244,244,244"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key background "244,244,244"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key buttonBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key linkColor "0,0,192"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectForeground "255,255,255"
if [[ $customcolor -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectBackground "$rgb_accent3"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBackground "$rgb_accent"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBackground "$rgb_accent"
kwriteconfig --file $TDEHOME/share/config/kickerrc  --group WM --key activeBackground "$rgb_accent"
kwriteconfig --file $TDEHOME/share/config/kickerrc  --group WM --key inactiveBackground "$rgb_accent"
else
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectBackground "61,174,233"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBackground "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kickerrc  --group WM --key activeBackground "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kickerrc  --group WM --key inactiveBackground "240,240,240"
fi
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key visitedLinkColor "128,0,128"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key windowBackground "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key buttonForeground "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key foreground "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key windowForeground "0,0,0"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key ActiveColor "169,156,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key ActiveColor2 "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DefaultColor "144,128,248"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DefaultColor2 "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DisabledColor "34,202,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DisabledColor2 "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DefaultColor "144,128,248"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DefaultColor2 "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DisabledColor "34,202,0"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DisabledColor2 "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBlend "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeForeground "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeTitleBtnBg "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key frame "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key handle "240,240,240"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBlend "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveForeground "142,142,142"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveFrame "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveHandle "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveTitleBtnBg "240,240,240"
kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key NormalTextColor "0,0,0"
kwriteconfig --file $TDEHOME/share/config/konquerorrc --group Settings --key BgColor "255,255,255"
rota
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "kate - Normal" --key "Color Background" "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "kate - Normal" --key "Color Highlighted Line" "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "kwrite - Normal" --key "Color Background" "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "kwrite - Normal" --key "Color Highlighted Line" "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "krusader - Normal" --key "Color Background" "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "krusader - Normal" --key "Color Highlighted Line" "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key colorScheme q4seb-color-scheme.kcsrc
#~~~~~~~~~~~~~ dark mods ~~~~~~~~~~~~~~~~~
               if [[ $dark -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key alternateBackground "32,33,34"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key background "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key buttonBackground "30,31,32"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key linkColor "90,130,180"
if [[ $customcolor -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectBackground "$rgb_accent3"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBackground "$rgb_accent"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBackground "$rgb_accent"
kwriteconfig --file $TDEHOME/share/config/kickerrc  --group WM --key activeBackground "$rgb_accent"
kwriteconfig --file $TDEHOME/share/config/kickerrc  --group WM --key inactiveBackground "$rgb_accent"
else
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectBackground "50,70,120"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBackground "40,40,40"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBackground "40,40,40"
kwriteconfig --file $TDEHOME/share/config/kickerrc --group WM --key activeBackground "40,40,40"
kwriteconfig --file $TDEHOME/share/config/kickerrc --group WM --key inactiveBackground "40,40,40"
fi
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key visitedLinkColor "90,60,120"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key windowBackground "30,31,32"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key buttonForeground "180,180,180"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key foreground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key windowForeground "215,215,215"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBlend "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeForeground "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeTitleBtnBg "40,40,40"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key frame "237,249,255"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key handle "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBlend "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveForeground "94,104,114"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveFrame "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveHandle "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveTitleBtnBg "39,41,42"
kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key NormalTextColor "255,255,255"
rota
kwriteconfig --file $TDEHOME/share/config/konquerorrc --group Settings --key BgColor "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key colorScheme q4seb-dark-color-scheme.kcsrc
               fi
#~~~~~~~~~~~~~ end dark mods ~~~~~~~~~~~~~
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key shadeSortColumn true
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key EffectsEnabled false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key EffectFadeMenu false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key EffectFadeTooltip false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key OpaqueResize false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key contrast 5
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key macStyle false
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key ActiveEffect none
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key ActiveSemiTransparent false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key ActiveValue 1
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key Animated false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DefaultEffect none
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DefaultSemiTransparent false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DefaultValue 1
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DisabledEffect togray
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group MainToolbarIcons --key DisabledSemiTransparent true
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key ActiveColor invalid
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key ActiveColor2 invalid
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key ActiveEffect none
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key ActiveSemiTransparent false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key ActiveValue 0
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key Animated false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DefaultEffect none
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DefaultSemiTransparent false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DefaultValue 1
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DisabledEffect togray
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DisabledSemiTransparent true
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group PanelIcons --key DisabledValue 1
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key alternateBackground "244,244,244"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key background "244,244,244"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key buttonBackground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key linkColor "0,0,192"
if [[ $customcolor -eq 1 ]]; then
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key selectBackground "$rgb_accent3"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBackground "$rgb_accent"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBackground "$rgb_accent"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc  --group WM --key activeBackground "$rgb_accent"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc  --group WM --key inactiveBackground "$rgb_accent"
else
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key selectBackground "61,174,233"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBackground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBackground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc --group WM --key activeBackground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc --group WM --key inactiveBackground "240,240,240"
fi
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key visitedLinkColor "128,0,128"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key windowBackground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key buttonForeground "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key foreground "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key windowForeground "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key Foreground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key ActiveColor "169,156,255"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key ActiveColor2 "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DefaultColor "144,128,248"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DefaultColor2 "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DisabledColor "34,202,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DisabledColor2 "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DefaultColor "144,128,248"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DefaultColor2 "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DisabledColor "34,202,0"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DisabledColor2 "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBlend "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeForeground "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeTitleBtnBg "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key frame "240,240,240"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key handle "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBlend "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveForeground "142,142,142"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveFrame "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveHandle "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveTitleBtnBg "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/konquerorrc --group FMSettings --key NormalTextColor "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/konquerorrc --group Settings --key BgColor "255,255,255"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "kate - Normal" --key "Color Background" "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "kate - Normal" --key "Color Highlighted Line" "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "kwrite - Normal" --key "Color Background" "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "kwrite - Normal" --key "Color Highlighted Line" "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "krusader - Normal" --key "Color Background" "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "krusader - Normal" --key "Color Highlighted Line" "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key colorScheme q4seb-color-scheme.kcsrc
#~~~~~~~~~~~~~ dark mods ~~~~~~~~~~~~~~~~~
               if [[ $dark -eq 1 ]]; then
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key alternateBackground "32,33,34"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key background "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key buttonBackground "30,31,32"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key linkColor "90,130,180"
if [[ $customcolor -eq 1 ]]; then
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key selectBackground "$rgb_accent3"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBackground "$rgb_accent"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBackground "$rgb_accent"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc  --group WM --key activeBackground "$rgb_accent"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc  --group WM --key inactiveBackground "$rgb_accent"
else
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key selectBackground "50,70,120"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBackground "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBackground "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc --group WM --key activeBackground "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kickerrc --group WM --key inactiveBackground "39,41,42"
fi
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key visitedLinkColor "90,60,120"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key windowBackground "30,31,32"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key buttonForeground "180,180,180"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key foreground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key windowForeground "215,215,215"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBlend "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeForeground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeTitleBtnBg "40,40,40"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key frame "237,249,255"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key handle "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBlend "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveForeground "94,104,114"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveFrame "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveHandle "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveTitleBtnBg "39,41,42"
rota
sudo kwriteconfig --file /root/.trinity/share/config/konquerorrc --group FMSettings --key NormalTextColor "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/konquerorrc --group Settings --key BgColor "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key colorScheme q4seb-dark-color-scheme.kcsrc
               fi
#~~~~~~~~~~~~~ end dark mods ~~~~~~~~~~~~~
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key shadeSortColumn true
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key EffectsEnabled false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key EffectFadeMenu false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key EffectFadeTooltip false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key OpaqueResize false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key contrast 5
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key macStyle false
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key ActiveEffect none
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key ActiveSemiTransparent false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key ActiveValue 1
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key Animated false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DefaultEffect none
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DefaultSemiTransparent false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DefaultValue 1
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DisabledEffect togray
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group MainToolbarIcons --key DisabledSemiTransparent true
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key ActiveColor invalid
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key ActiveColor2 invalid
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key ActiveEffect none
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key ActiveSemiTransparent false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key ActiveValue 0
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key Animated false
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DefaultEffect none
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DefaultSemiTransparent false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DefaultValue 1
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DisabledEffect togray
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DisabledSemiTransparent true
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group PanelIcons --key DisabledValue 1
rota
echo
printf '\e[A\e[K'
sep
echo
echo
echo
progress "$script" 70





#========== Login style ala windows10 ===========================================================================
itemdisp "Configuring login style..."
echo
echo -e "  \e[35m░▒▓█\033[0m installing tdmtheme-trinity..."
if ! (cat common/packages_list.tmp | grep -q tdmtheme-trinity ); then
echo -e "${YELLOW}"
sudo apt install -y tdmtheme-trinity
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi



echo -e "  \e[35m░▒▓█\033[0m configuring wallpaper for login & ksplash"
echo "       (please be patient this could take some time...)"
#sudo convert /opt/trinity/share/wallpapers/$rwallp -filter Gaussian -blur 0x40 /opt/trinity/share/apps/tdm/themes/windows/background.jpg
#sudo convert /opt/trinity/share/wallpapers/$rwallp -filter Gaussian -blur 0x40 /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg
sudo convert /opt/trinity/share/wallpapers/$rwallp -resize ${Xres}x${Yres}! -filter Gaussian -blur 0x40 /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg
## here imagemagick apply loginpic
sudo convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg /opt/trinity/share/apps/tdm/themes/windows/userpic.png -geometry +$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert /opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg -ping -format "%[fx:h*$fact]" info:) -composite /opt/trinity/share/apps/tdm/themes/windows/background.jpg



#test dark or light
#lightamount=$(sudo convert /opt/trinity/share/apps/tdm/themes/windows/background.jpg -threshold 50% -format "%[fx:100*image.mean]" info:)


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
## here imagemagick apply userpic
base_bg="/opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg"
user_directories=(/opt/trinity/share/apps/ksplash/Themes/Redmond10_*/)
for user_dir in "${user_directories[@]}"; do
user_dir="${user_dir%/}"
userpic="/opt/trinity/share/apps/ksplash/Themes/$(basename "$user_dir")/userpic.png"
output_bg="/opt/trinity/share/apps/ksplash/Themes/$(basename "$user_dir")/Background.png"
sudo convert "$base_bg" "$userpic" -geometry +$(convert "$base_bg" -ping -format "%[fx:(w-$usz)/2]" info:)+$(convert "$base_bg" -ping -format "%[fx:h*$fact]" info:) -composite "$output_bg"
done
############

sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key LogoPixmap "/opt/trinity/share/apps/tdm/pics/tuxlogo.png"
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key LogoArea Logo
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key GUIStyle QtCurve
sudo kwriteconfig --file /etc/trinity/tdm/backgroundrc --group Desktop0 --key BackgroundMode Flat
sudo kwriteconfig --file /etc/trinity/tdm/backgroundrc --group Desktop0 --key WallpaperMode NoWallpaper
sudo kwriteconfig --file /etc/trinity/tdm/backgroundrc --group Desktop0 --key Color1 "0,0,0"
sudo kwriteconfig --file $TDEHOME/share/config/ksmserverrc --group Logout --key doFadeaway false
sudo kwriteconfig --file $TDEHOME/share/config/ksmserverrc --group Logout --key doFancyLogout false
sudo rm -f /opt/trinity/share/apps/ksmserver/pics/shutdown.jpg
#tdmtheme
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key UseTheme true
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key Theme "/opt/trinity/share/apps/tdm/themes/windows"
sep
echo
echo
echo
progress "$script" 75






#========== Configuring taskbar =================================================================================
itemdisp "Configuring taskbar..."
	if [[ $dark -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key ActiveTaskTextColor "235,235,235"
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key InactiveTaskTextColor "93,93,93"
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key TaskBackgroundColor "119,119,119"
	else
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key ActiveTaskTextColor "255,255,255"
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key InactiveTaskTextColor "195,195,195"
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key TaskBackgroundColor "255,255,255"
	fi
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key HaloText true
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key IconSize 22
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key Q4ButtonFrameType 1
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key UseCustomColors true
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key ShowButtonOnHover ""
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key DrawButtons ""
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key HaloText true
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key CycleWheel false
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key DisplayIconsNText DisplayIconsOnly
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key MinimumButtonHeight 38
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key MinimumButtonWidth 80
sed -i "/ShowButtonOnHover=/d" $TDEHOME/share/config/ktaskbarrc
#kwriteconfig --file $TDEHOME/share/config/launcher_panelapplet_modernui_rc --group General --key ConserveSpace true
#kwriteconfig --file $TDEHOME/share/config/launcher_panelapplet_modernui_rc --group General --key DragEnabled true
#kwriteconfig --file $TDEHOME/share/config/launcher_panelapplet_modernui_rc --group General --key IconDim 30
#kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key BackgroundTheme "/opt/trinity/share/apps/kicker/pics/panel-win.png"
####kwriteconfig --file $TDEHOME/share/config/kickerrc --group Applet_1 --key 'ConfigFile[$e]' taskbar_panelapplet_rc
sed -i '/^ConfigFile\[/d' $TDEHOME/share/config/kickerrc
sed -i '/^DesktopFile\[/d' $TDEHOME/share/config/kickerrc
sed -i '/^FreeSpace2=/d' $TDEHOME/share/config/kickerrc
sed -i '/^WidthForHeightHint=/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[KMenuButton_1\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[WindowListButton_1\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[ExtensionButton_1\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_1\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_2\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_3\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_4\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_5\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_6\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_7\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_8\]/d' $TDEHOME/share/config/kickerrc
sed -i '/^\[Applet_9\]/d' $TDEHOME/share/config/kickerrc
cat theme/kickpart >> $TDEHOME/share/config/kickerrc
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Applets2 "KMenuButton_1,ExtensionButton_1,WindowListButton_1,Applet_4,Applet_1,Applet_2,Applet_3,Applet_6,Applet_5"
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key UseResizeHandle false
#echo -e ">> Wait for kicker to restart..."
#dcop kicker kicker restart
#sleep 10

#installing showdeskten applet
echo -e "  \e[35m░▒▓█\033[0m installing showdeskten kicker applet"
sudo tar -xzf theme/showdeskten_applet.desktop.tar.gz -C /opt/trinity/share/apps/kicker/applets/
if [ "$osarch" = "amd64" ]; then
sudo tar -xzf theme/showdeskten_libs.tar.gz -C /opt/trinity/lib/trinity/
fi
if [ "$osarch" = "i386" ]; then
sudo tar -xzf theme/showdeskten_libs_32.tar.gz -C /opt/trinity/lib/trinity/
fi
if [ "$osarch" = "armhf" ]; then
sudo tar -xzf theme/showdeskten_libs_armhf.tar.gz -C /opt/trinity/lib/trinity/
fi
sudo convert -size 5x64 xc:${accent} /opt/trinity/share/apps/kicker/pics/showdesk10.png
#installing actioncenter applet
echo -e "  \e[35m░▒▓█\033[0m installing actioncenter kicker applet"
sudo tar -xzf theme/actioncenter_applet.desktop.tar.gz -C /opt/trinity/share/apps/kicker/applets/
sudo tar -xzf theme/actioncenter_assets.tar.gz -C /opt/trinity/share/apps/
if [ "$osarch" = "amd64" ]; then
sudo tar -xzf theme/actioncenter_libs.tar.gz -C /opt/trinity/lib/trinity/
fi
if [ "$osarch" = "i386" ]; then
sudo tar -xzf theme/actioncenter_libs_32.tar.gz -C /opt/trinity/lib/trinity/
fi
if [ "$osarch" = "armhf" ]; then
sudo tar -xzf theme/actioncenter_libs_armhf.tar.gz -C /opt/trinity/lib/trinity/
fi
echo -e "  \e[35m░▒▓█\033[0m installing xdotool"
if ! (cat common/packages_list.tmp | grep -q "xdotool/stable"); then
cd apps
echo -e "${YELLOW}"
sudo apt install -y xdotool
cd ..
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi

echo -e "  \e[35m░▒▓█\033[0m installing xsel"
if ! (cat common/packages_list.tmp | grep -q "xsel/stable"); then
cd apps
echo -e "${YELLOW}"
sudo apt install -y xsel
cd ..
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi

sep
echo
echo
echo
progress "$script" 80





#========== Configuring systray clock ===========================================================================
itemdisp "Configuring systray clock..."
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key Foreground_Color "220,220,220"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key Shadow_Color "255,255,255"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Date --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Date --key Font "Segoe UI,8,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Date --key Foreground_Color "33,33,33"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Digital --key Foreground_Color "195,195,195"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Digital --key Shadow_Color "240,240,240"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Digital --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Fuzzy --key Foreground_Color "228,228,228"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Fuzzy --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Plain --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Plain --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Plain --key Foreground_Color "1,0,0"
if [[ $dark -eq 1 ]]
then
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Background_Color "39,41,42"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Background_Color "39,41,42"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Plain --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Date --key Background_Color "39,41,42"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Date --key Foreground_Color "215,215,215"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Digital --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Digital --key Background_Color "39,41,42"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Fuzzy --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Fuzzy --key Background_Color "39,41,42"
fi
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key Antialias 2
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key LCD_Style false
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Analog --key Show_Seconds false
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Fuzzy --key Show_Date false
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Plain --key Show_Date true
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group "System Tray" --key ShowClockInTray true
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group "System Tray" --key systrayIconWidth 22
sudo sed -i '/Type=/d' $USER_HOME/.trinity/share/config/systemtray_panelappletrc
sudo sed -i '/Use_Shadow=/d' $USER_HOME/.trinity/share/config/systemtray_panelappletrc
sep
echo
echo
echo
progress "$script" 85





#========== Fonts. Mostly Segoe UI & consolas for Konsole ========================================================
itemdisp "Configuring fonts"
#kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key fixed "Droid Sans Mono,9,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key fixed "Consolas,11,-1,5,50,0,0,0,0,0"
#kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key fixed "Cascadia Code,11,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key font "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key menuFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key taskbarFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key toolBarFont "Segoe UI,9,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key desktopFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group FMSettings --key StandardFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key defaultfont "Consolas,11,-1,5,50,0,0,0,0,0"
#kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key defaultfont "Cascadia Code,10,-1,5,50,0,0,0,0,0"
if [[ $dark -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key TabColor "255,255,255"
else
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key TabColor "0,0,0"
fi
kwriteconfig --file $TDEHOME/share/config/keditrc --group "Text Font" --key KEditFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/krusaderrc --group "Look&Feel" --key "Filelist Font" "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/krusaderrc --group UserActions --key "Fixed Font" "Consolas,11,-1,5,50,0,0,0,0,0"
#kwriteconfig --file $TDEHOME/share/config/krusaderrc --group UserActions --key "Fixed Font" "Cascadia Code,11,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/krusaderrc --group UserActions --key "Normal Font" "Segoe UI,11,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "kate - Normal" --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "krusader - Normal" --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kateschemarc --group "kwrite - Normal" --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-font-name "Segoe UI 10"
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-font-name "Segoe UI 10"
sed -i '/gtk-font-name="/c\gtk-font-name="Segoe UI 10"' $USER_HOME/.gtkrc-q4os
sed -i '/gtk-font-name="/c\gtk-font-name="Segoe UI 10"' $USER_HOME/.gtkrc-q4os
sed -i '/font_name="/c\font_name="Segoe UI 10"' $USER_HOME/.gtkrc-q4os
sed -i '/font_name="/c\font_name="Segoe UI 10"' $USER_HOME/.gtkrc-2.0
# in  $USER_HOME/.gtkrc-2.0, assign text[SELECTED] = { 1.000, 1.000, 1.000 }
sudo sed -i '/Gtk\/FontName/c\Gtk\/FontName "Segoe UI 10"' "$USER_HOME/.configtde/xsettingsd/xsettingsd.conf"
sudo sed -i '/Gtk\/FontName/c\Gtk\/FontName "Segoe UI 10"' "/root/.config/xsettingsd/xsettingsd.conf"
if [ -f "/root/xsettingsd.conf" ]; then
sudo sed -i '/Gtk\/FontName/c\Gtk\/FontName "Segoe UI 10"' "/root/xsettingsd.conf"
sudo sed -i '/Gtk\/FontName/c\Gtk\/FontName "Segoe UI 10"' "$USER_HOME/.config/xsettingsd/xsettingsd.conf"
fi
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key FailFont "Segoe UI,9,-1,5,75,0,0,0,0,0"
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key StdFont "Segoe UI,18,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /etc/trinity/tdm/tdmrc --group "X-*-Greeter" --key GreetFont=Segoe UI,12,-1,5,75,0,0,0,0,0
kwriteconfig --file $USER_HOME/.tderc --group General --key StandardFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key activeFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key desktopFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key fixed "Consolas,11,-1,5,75,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key font "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key menuFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key taskbarFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.tderc --group General --key toolBarFont "Segoe UI,9,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/systemtray_panelappletrc --group Plain --key Font "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $USER_HOME/.config/Trolltech.conf --group qt --key font "Segoe UI,10,-1,0,50,0,0,0,0,0"
#root
#sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key fixed "Droid Sans Mono,9,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key fixed "Consolas,11,-1,5,50,0,0,0,0,0"
#sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key fixed "Cascadia Code,11,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key font "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key menuFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key taskbarFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key toolBarFont "Segoe UI,9,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdesktoprc --group FMSettings --key StandardFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key desktopFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/konsolerc --group "Desktop Entry" --key defaultfont "Consolas,11,-1,5,50,0,0,0,0,0"
#kwriteconfig --file /root/.trinity/share/config/konsolerc --group "Desktop Entry" --key defaultfont "Cascadia Code,10,-1,5,50,0,0,0,0,0"
if [[ $dark -eq 1 ]]; then
sudo kwriteconfig --file /root/.trinity/share/config/konsolerc --group "Desktop Entry" --key TabColor "255,255,255"
else
sudo kwriteconfig --file /root/.trinity/share/config/konsolerc --group "Desktop Entry" --key TabColor "0,0,0"
fi
sudo kwriteconfig --file /root/.trinity/share/config/keditrc --group "Text Font" --key KEditFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/krusaderrc --group "Look&Feel" --key "Filelist Font" "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/krusaderrc --group UserActions --key "Fixed Font" "Consolas,11,-1,5,50,0,0,0,0,0"
#kwriteconfig --file /root/.trinity/share/config/krusaderrc --group UserActions --key "Fixed Font" "Cascadia Code,11,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/krusaderrc --group UserActions --key "Normal Font" "Segoe UI,11,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "kate - Normal" --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarc --group "krusader - Normal" --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kateschemarcc --group "kwrite - Normal" --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-font-name "Segoe UI 10"
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-font-name "Segoe UI 10"
sudo sed -i '/gtk-font-name="/c\gtk-font-name="Segoe UI 10"' /root/.gtkrc-q4os > /dev/null 2>&1
sudo sed -i '/font_name="/c\font_name="Segoe UI 10"' /root/.gtkrc-q4os > /dev/null 2>&1
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key StandardFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key activeFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key desktopFont "Segoe UI,10,-1,5,63,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key fixed "Consolas,11,-1,5,75,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key font "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key menuFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key taskbarFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file $USER_HOME/.tderc --group General --key toolBarFont "Segoe UI,9,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/systemtray_panelappletrc --group Plain --key Font "Segoe UI,10,-1,5,50,0,0,0,0,0"
sudo kwriteconfig --file /root/.qt/qtrc --group General --key font "Segoe UI,9,-1,5,50,0,0,0,0,0"
if ! grep -q "xterm\\*faceName" "$USER_HOME/.Xresources"; then echo "xterm*faceName: Consolas" | sudo tee -a $USER_HOME/.Xresources ; fi
sudo sed -i "/xterm*faceName:/c\xterm*faceName: Consolas" $USER_HOME/.Xresources
if ! grep -q "xterm\\*faceSize" "$USER_HOME/.Xresources"; then echo "xterm*faceSize: 12" | sudo tee -a $USER_HOME/.Xresources ; fi
sudo sed -i "/xterm*faceSize:/c\xterm*faceSize: 10" $USER_HOME/.Xresources
if ! grep -q "xterm\\*foreground" "$USER_HOME/.Xresources"; then echo "xterm*foreground: grey" | sudo tee -a $USER_HOME/.Xresources ; fi
sudo sed -i "/xterm*foreground:/c\xterm*foreground: grey" $USER_HOME/.Xresources
if ! grep -q "xterm\\*background" "$USER_HOME/.Xresources"; then echo "xterm*background: black" | sudo tee -a $USER_HOME/.Xresources ; fi
sudo sed -i "/xterm*background:/c\xterm*background: black" $USER_HOME/.Xresources
#
kwriteconfig --file $TDEHOME/share/config/kcmfonts --group General --key dontChangeAASettings false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key XftSubPixel none
#------#------


sep
echo
echo
echo
progress "$script" 90




#========== Configuring icons ===================================================================================
# based on kdeten from Q4os Plasma edition :p with some modifications
itemdisp "Configuring icons..."
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key IconUseRoundedRect false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group DesktopIcons --key Size 48
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group SmallIcons --key DoublePixels false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group SmallIcons --key Size 24
if [[ $dark -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group Icons --key Theme kdeten_dark
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_dark"' $USER_HOME/.gtkrc-q4os
sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_dark"' $USER_HOME/.gtkrc-2.0
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group Icons --key Theme kdeten_dark
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
sudo sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_dark"' /root/.gtkrc-q4os
sudo sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_dark"' /root/.gtkrc-2.0
else
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group Icons --key Theme kdeten_light
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_light"' $USER_HOME/.gtkrc-q4os
sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_light"' $USER_HOME/.gtkrc-2.0
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group Icons --key Theme kdeten_light
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
sudo sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_light"' /root/.gtkrc-q4os
sudo sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="kdeten_light"' /root/.gtkrc-2.0
fi
sep
echo
echo
echo

#========== Configuring usb fast removal (sync) - slower writes to media storage
#========== but users can remove them without worrying about unmounting first like it is the case on windows.
itemdisp "Configuring « usb fast removal »..."
kwriteconfig --file $TDEHOME/share/config/mediamanagerrc --group DefaultOptions --key sync true
sep
echo
echo
echo


itemdisp "Installing lxtask-mod (taskmanager)..."
if ! (cat common/packages_list.tmp | grep -q "lxtask-mod/now"); then
cd apps
echo -e "${YELLOW}"
if ( getconf LONG_BIT | grep -q 64 ); then
sudo apt install -y ./lxtask-mod.deb
else
sudo apt install -y ./lxtask-mod_i386.deb
fi
cd ..
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
sep
echo
echo
echo



itemdisp "Installing gwenview (image viewer)..."
if ! (cat common/packages_list.tmp | grep -q "gwenview-trinity/"); then
echo -e "${YELLOW}"
sudo apt install -y gwenview-trinity
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
sep
echo
echo
echo


itemdisp "Installing admin tools..."
if ! (cat common/packages_list.tmp | grep -q "tde-guidance-trinity/"); then
echo -e "${YELLOW}"
sudo apt install -y tde-guidance-trinity
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
sep
echo
echo
echo


itemdisp "Installing .themepack/.deskthemepack installer..."
sudo \cp apps/themeinst.sh /usr/local/bin/themeinst.sh
cd /usr/local/bin/
sudo chmod +x themeinst.sh
themeinst.sh install
cd - > /dev/null 2>&1
sep
echo
echo
echo

itemdisp "Configuring global shortcuts & default apps integration..."
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group "Global Shortcuts" --key "Popup Launch Menu" "Super_L"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group "Global Shortcuts" --key "Show Taskmanager" "default(Ctrl+Escape)"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "application/x-deb - 1" --key Application appsetup2.exu.desktop
#gwenview integration
sudo mkdir -p "$USER_HOME/.trinity/share/apps/gwenview"
sudo tar -xzf theme/gwenviewui.tar.gz -C $USER_HOME/.trinity/share/apps/gwenview/
sudo chown -R $USER: $USER_HOME/.trinity/share/apps/gwenview
sudo mkdir -p $USER_HOME/.trinity/share/mimelnk/image/
sudo tar -xzf theme/mimelnk_image.tar.gz -C $USER_HOME/.trinity/share/mimelnk/image/
sudo chown -R $USER: $USER_HOME/.trinity/share/mimelnk/image
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "KFileDialog Settings" --key "Automatic Preview" true
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar locationToolBar" --key Hidden true
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar locationToolBar" --key IconText IconOnly
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar locationToolBar" --key Index 0
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar locationToolBar" --key NewLine true
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar mainToolBar" --key IconSize 22
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar mainToolBar" --key IconText IconTextBottom
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "MainWindow Toolbar mainToolBar" --key Index 1
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "file widget" --key "item text pos" 0
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "file widget" --key "start with thumbnails" false
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "file widget" --key "thumbnail size" 116
if [[ $dark -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "background color" "39,41,42"
else
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "background color" "244,244,244"
fi
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "delayed smoothing" true
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "max repaint size" 10000000
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "max scale repaint size" 10000000
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "max smooth repaint size" 7172575
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "pixmap widget" --key "smooth scale" Fast
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "slide show" --key delay 8
kwriteconfig --file $TDEHOME/share/config/gwenviewrc --group "slide show" --key loop true
kwriteconfig --file "$USER_HOME/.local/share/applications/tde-gwenview.desktop" --group "Desktop Entry" --key "MimeType" "image/gif;image/x-xpm;image/x-xbm;image/jpeg;image/x-pcx;image/x-bmp;image/png;image/x-ico;image/x-portable-bitmap;image/x-portable-pixmap;image/x-portable-greymap;image/tiff;image/x-targa;image/svg+xml;image/jp2"
#
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/gif - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/gif - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/gif - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/gif - 1" --key ServiceType "image/gif"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jpeg - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jpeg - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jpeg - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jpeg - 1" --key ServiceType "image/jpeg"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jp2 - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jp2 - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jp2 - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/jp2 - 1" --key ServiceType "image/jp2"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/png - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/png - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/png - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/png - 1" --key ServiceType "image/png"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-bmp - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-bmp - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-bmp - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-bmp - 1" --key ServiceType "image/x-bmp"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xpm - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xpm - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xpm - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xpm - 1" --key ServiceType "image/x-xpm"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xbm - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xbm - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xbm - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-xbm - 1" --key ServiceType "image/x-xbm"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-pcx - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-pcx - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-pcx - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-pcx - 1" --key ServiceType "image/x-pcx"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-ico - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-ico - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-ico - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-ico - 1" --key ServiceType "image/x-ico"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-bitmap - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-bitmap - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-bitmap - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-bitmap - 1" --key ServiceType "image/x-portable-bitmap"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-pixmap - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-pixmap - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-pixmap - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-pixmap - 1" --key ServiceType "image/x-portable-pixmap"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-greymap - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-greymap - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-greymap - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-portable-greymap - 1" --key ServiceType "image/x-portable-greymap"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/tiff - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/tiff - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/tiff - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/tiff - 1" --key ServiceType "image/tiff"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-targa - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-targa - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-targa - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/x-targa - 1" --key ServiceType "image/x-targa"
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/svg+xml - 1" --key Application tde-gwenview.desktop
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/svg+xml - 1" --key AllowAsDefault true
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/svg+xml - 1" --key GenericServiceType Application
kwriteconfig --file $TDEHOME/share/config/profilerc --group "image/svg+xml - 1" --key ServiceType "image/svg+xml"
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group "Global Shortcuts" --key "Popup Launch Menu" "Super_L"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group "Global Shortcuts" --key "Show Taskmanager" "default(Ctrl+Escape)"
#desktop images preview
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group "Desktop Icons" --key "Preview" "svgthumbnail,imagethumbnail"
#usuals win commands
cd /usr/local/bin/
sudo rm calc charmap cmd ksysguard notepad paint snapshot stickynotes taskmgr taskschd > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/kwrite /usr/local/bin/notepad > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/kcharselect /usr/local/bin/charmap > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/kcalc /usr/local/bin/calc > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/kolourpaint /usr/local/bin/paint > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/konsole /usr/local/bin/cmd > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/ksnapshot /usr/local/bin/snapshot > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/knotes /usr/local/bin/stickynotes > /dev/null 2>&1
sudo ln -s /opt/trinity/bin/kcron /usr/local/bin/taskschd > /dev/null 2>&1
#default task manager (CTRL+ESC)
sudo ln -s /usr/bin/lxtask /usr/local/bin/taskmgr > /dev/null 2>&1
sudo ln -s /usr/bin/lxtask /usr/local/bin/ksysguard > /dev/null 2>&1
cd - > /dev/null 2>&1
#ipconfig :p (kind of)
sudo \cp apps/ipconfig /usr/local/bin/ipconfig
sudo tar -xzf theme/services.msc.tar.gz -C /usr/local/bin/
sudo chmod +x /usr/local/bin/ipconfig
#konsolerc settings
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key "RealTransparency" "true"
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key "MenuBar" "Disabled"
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key "tabbar" 0
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key "has frame" "false"
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key "AllowResize" "true"
kwriteconfig --file $TDEHOME/share/config/konsolerc --group "Desktop Entry" --key "TabsCycleWheel" "false"
#default root apps icon overlay
sudo kwriteconfig --file "/opt/trinity/share/applications/tde/konsolesu.desktop" --group "Desktop Entry" --key Icon xconsole_root
sudo kwriteconfig --file "/opt/trinity/share/applications/tde/konquerorsu.desktop" --group "Desktop Entry" --key Icon kfm_root
sudo kwriteconfig --file "/usr/share/applications/bleachbit-root.desktop" --group "Desktop Entry" --key Icon bleachbit_root > /dev/null 2>&1
sudo kwriteconfig --file "/usr/share/applications/htop_root-mode.desktop" --group "Desktop Entry" --key Icon htop_root
rooticons () {
find ${HOME} -type f -name "konquerorsu.desktop" | while read -r fichier; do
sudo kwriteconfig --file "$fichier" --group "Desktop Entry" --key Icon kfm_root
done
find ${HOME} -type f -name "konsolesu.desktop" | while read -r fichier; do
sudo kwriteconfig --file "$fichier" --group "Desktop Entry" --key Icon xconsole_root
done
find ${HOME} -type f -name "bleachbit-root.desktop" | while read -r fichier; do
sudo kwriteconfig --file "$fichier" --group "Desktop Entry" --key Icon bleachbit_root
done
}
rooticons > /dev/null 2>&1
sep
echo
echo
echo
progress "$script" 95


#========== Cleaning ============================================================================================
itemdisp "Cleaning temp files..."
sudo rm -f common/packages_list.tmp
echo
sep
echo
echo
echo
progress "$script" 100

touch $USER_HOME/.q4oswin10.conf
#========== DONE. ==================================================================================================
alldone

m1="${ORANGE}════════════════════════════════════════════════════════════════════════════════${NOCOLOR}"
m2="${ORANGE}═══${NOCOLOR} Customizing"
echo -e $m1;echo -e $m2
echo -e " ${YELLOW}►${NOCOLOR} Do you want to customize the theme (this can be done anytime"
echo "   by launching qmenu-->Qtools-->Theming tools) (y:customize/enter:skip) ?" && read x
if [ "$x" == "y" ] || [ "$x" == "Y" ]; then
tools/themetools
clear
echo -e $m1;echo -e $m2
echo
fi
sep
echo
echo
echo

if [ -n "$vm" ]; then
echo
echo -e "${GRAY}█ It seems you're running Q4OS inside a virtualized machine."
echo -e "${GRAY}█ Please ensure that you have enabled 3D acceleration and enough video RAM."
if [ "$vmsys" = "(VirtualBox)" ]; then
echo -e "${GRAY}█ For virtualbox which seems to be used in this case, check 3D acceleration in"
echo -e "${GRAY}█ configuration display of the virtual machine, and set video ram to 128Mb."
fi
fi
echo
echo -e "\e[5m~~ reboot is required ~~\e[25m"
echo
echo -e " ${RED}►${NOCOLOR} Do you want to reboot right now ? (y:reboot/enter:skip)" && read x && [[ "$x" == "y" ]] && sudo /sbin/reboot;
echo
wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
exit 2

