#!/bin/bash
dark=0
helpdoc=0
lowres=0
VALID_ARGS=$(getopt -o hdL --long help,dark,light -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi
eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -d | --dark)
        dark=1
        shift
        ;;
    -L | --light)
        dark=0
        shift
        ;;
    -h | --help)
        helpdoc=1
        shift
        ;;
     --) shift; 
        break 
        ;;
  esac
done
if [ $helpdoc -eq 1 ]; then
script="Help Qtheme"
else
script="Qtheme script"
fi
source common/begin
source common/progress
begin "$script"
#================================================================================================================



#========== set subscripts perms ================================================================================
progress "$script" 0
sudo chmod +x theme/grubscripts theme/themegrub theme/copyfiles common/pklist


#========== Retrieve resolution for res dependent elements ======================================================
Xres=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
if (( $Xres < 1920 )); then
lowres=1
fi




#========== CREATE BACKUP FOLDER & backup files to be modified ==================================================
create_backup() {
    local backup_path="backups/$now/$1.tar.gz"
    sudo tar -zcvf "$backup_path" "$2" > /dev/null 2>&1
    rota
}
echo -e "${RED}░░▒▒▓▓██\033[0m Backup...${NOCOLOR}"
now=$(date +"%Y-%m-%d_%I-%M%p")
sudo mkdir -p "backups/$now" > /dev/null 2>&1
create_backup "shutimg" "/opt/trinity/share/apps/ksmserver/pics/shutdownkonq2.png"
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
create_backup "kcminputrc" "$TDEHOME/share/config/kcminputrc"
create_backup "kcminputrc_root" "/root/.config/kcminputrc"
create_backup "gtk3_settings_tde" "$USER_HOME/.configtde/gtk-3.0/settings.ini"
create_backup "gtk3_settings" "$USER_HOME/.config/gtk-3.0/settings.ini"
create_backup "gtk3_settings_tde_root" "/root/.configtde/gtk-3.0/settings.ini"
create_backup "gtk3_settings_root" "/root/.config/gtk-3.0/settings.ini"
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
create_backup "GTK3-Q4OS02" "/usr/share/themes/Q4OS02/gtk-3.0"
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
create_backup "gtkrc-q4os_root" "/root/.gtkrc-q4os"
create_backup "launcher_panelapplet_rc" "$TDEHOME/share/config/launcher_panelapplet_modernui_rc"
create_backup "Xresources" "$USER_HOME/.Xresources"
create_backup "Xresources_root" "/root/.Xresources"
create_backup "x-cursor-theme" "/etc/alternatives/x-cursor-theme"
create_backup "knotify.eventsrc" "$TDEHOME/share/config/knotify.eventsrc"
create_backup "sounds" "/opt/trinity/share/sounds/"
create_backup "shutdown_img" "/opt/trinity/share/apps/tdm/pics/shutdown.jpg"
create_backup "keditrc" "$TDEHOME/share/config/keditrc"
if [ -d "/opt/program_files/q4os-update-manager" ]; then
create_backup "update-manager_icons" "/opt/program_files/q4os-update-manager/share/icons"
fi
create_backup "konsolerc" "$TDEHOME/share/config/konsolerc"
create_backup "systemtray_panelappletrc" "$TDEHOME/share/config/systemtray_panelappletrc"
if [ -f "/root/xsettingsd.conf" ]; then
create_backup "root_xsettingsd.conf" "/root/xsettingsd.conf"
create_backup "root_config_xsettingsd.conf" "/root/.config/xsettingsd/xsettingsd.conf"
fi
create_backup "Trolltech.conf" "$USER_HOME/.config/Trolltech.conf"
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
sudo chmod +x "backups/restore_$now"
rota
echo
printf '\e[A\e[K'
echo





#========== retrieve packages list ==============================================================================
echo -e "    ${ORANGE}░▒▓█\033[0m Retrieve packages list..."
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
sudo tar -xzf theme/q4os_seb.tar.gz -C /usr/share/grub/themes
if [[ $lowres -eq 1 ]]; then
sudo tar -xzf theme/segoebold.pf2_lowres.tar.gz -C /usr/share/grub/themes/q4os_seb/
sudo sed -i '/item_font =/c\item_font = "Segoe UI Bold 18"' /usr/share/grub/themes/q4os_seb/theme.txt
sudo sed -i '/font = "Segoe UI Bold 24"/c\font = "Segoe UI Bold 18"' /usr/share/grub/themes/q4os_seb/theme.txt
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
if [[ $dark -eq 1 ]]
then
sudo \cp theme/shutdownkonq2-dark.png /opt/trinity/share/apps/ksmserver/pics/shutdownkonq2.png
else
sudo \cp theme/shutdownkonq2.png /opt/trinity/share/apps/ksmserver/pics/shutdownkonq2.png
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
kwriteconfig --file $TDEHOME/share/config/ksplashrc --group KSplash --key Theme Unified
sep
echo
echo
echo
progress "$script" 40







#========== Pointers ============================================================================================
itemdisp "Configuring pointers & set acceleration to 1"
#pointer size
if ! grep -q "Xcursor.size" "$USER_HOME/.Xresources"; then
echo "Xcursor.size: 32" | sudo tee -a $USER_HOME/.Xresources
fi
sudo sed -i "/Xcursor.size:/c\Xcursor.size: 32" $USER_HOME/.Xresources

if ! grep -q "Xcursor.size" "/root/.Xresources"; then
echo "Xcursor.size: 32" | sudo tee -a /root/.Xresources
fi
sudo sed -i "/Xcursor.size:/c\Xcursor.size: 32" /root/.Xresources
#Xcursor.theme: Windows10Light ?
#
kwriteconfig --file $TDEHOME/share/config/kcminputrc --group Mouse --key cursorTheme Windows10Light
kwriteconfig --file $TDEHOME/share/config/kcminputrc --group Mouse --key Acceleration 1
kwriteconfig --file $USER_HOME/.trinitykde/share/config/kcminputrc --group Mouse --key cursorTheme Windows10Light
kwriteconfig --file $USER_HOME/.trinitykde/share/config/kcminputrc --group Mouse --key Acceleration 1
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10Light
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10Light
kwriteconfig --file $USER_HOME/.config/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10Light
#root
sudo kwriteconfig --file /root/.config/kcminputrc --group Mouse --key cursorTheme Windows10Light
sudo kwriteconfig --file /root/.config/kcminputrc --group Mouse --key Acceleration 1
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10Light
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10Light
sudo kwriteconfig --file /root/.config/gtk-4.0/settings.ini --group Settings --key gtk-cursor-theme-name Windows10Light
sudo kwriteconfig --file /root/.trinity/share/config/kcminputrc --group Mouse --key cursorTheme Windows10Light
sudo kwriteconfig --file /root/.trinitykde/share/config/kcminputrc --group Mouse --key cursorTheme Windows10Light
#cursor theme for x
sudo \cp /usr/share/icons/Windows10Light/cursor.theme /etc/X11/cursors/Windows10Light_cursor.theme
sudo ln -nfs /etc/X11/cursors/Windows10Light_cursor.theme /etc/alternatives/x-cursor-theme
if [ -f "/root/xsettingsd.conf" ]; then
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Light"' "$USER_HOME/.config/xsettingsd/xsettingsd.conf"
sudo sed -i '/Gtk\/CursorThemeName/c\Gtk\/CursorThemeName "Windows10Light"' "/root/xsettingsd.conf"
fi
sep
echo
echo
echo
progress "$script" 45






#========== Start menu configuration ============================================================================
itemdisp "Configuring start menu..."
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key CustomSize 34
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key BourbonMenu false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key LegacyKMenu true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Locked true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key AutoHidePanel false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key AutoHideSwitch false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key MenubarPanelBlurred false
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
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintValue 99
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Transparent true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key panelIconWidth 48
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowDeepButtons false
rota
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowIconActivationEffect false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowLeftHideButton false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key ShowRightHideButton false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key UseSidePixmap true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key SearchShortcut "/"
kwriteconfig --file $TDEHOME/share/config/kickerrc --group KMenu --key CustomIcon "/usr/share/pixmaps/StartHere4.png"
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
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key NumVisibleEntries 5
kwriteconfig --file $TDEHOME/share/config/kickerrc --group buttons --key EnableIconZoom true
kwriteconfig --file $TDEHOME/share/config/kickerrc --group buttons --key EnableTileBackground false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key MenuEntryHeight 28
kwriteconfig --file $TDEHOME/share/config/kickerrc --group menus --key ShowMenuTitles false
kwriteconfig --file $TDEHOME/share/config/kickerrc --group button_tiles --key KMenuTileColor "218,83,34"
if [[ $dark -eq 1 ]]
then
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintColor "36,36,36"
else
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key TintColor "248,248,248"
fi
#menu with categories (& kmenuedit available)
rm -f $USER_HOME/.configtde/menus/tde-applications.menu
rota
echo
printf '\e[A\e[K'
sep
echo
echo
echo
progress "$script" 50





#========== windows style with qtcurve ==========================================================================
itemdisp "Configuring windows style..."
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key widgetStyle qtcurve
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key ShowIconsOnPushButtons false
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group KDE --key EffectsEnabled false
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key widgetStyle qtcurve
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key ShowIconsOnPushButtons false
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group KDE --key EffectsEnabled false
sep
echo
echo
echo
progress "$script" 55





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
if [[ $dark -eq 1 ]]; then
sudo tar -xzf theme/WinTen-seb-theme-dark.tar.gz -C /opt/trinity/share/apps/deKorator/themes
sudo tar -xzf theme/twindeKoratorrc-dark.tar.gz -C $USER_HOME/.trinity/share/config/
else
sudo tar -xzf theme/WinTen-seb-theme.tar.gz -C /opt/trinity/share/apps/deKorator/themes
sudo tar -xzf theme/twindeKoratorrc.tar.gz -C $USER_HOME/.trinity/share/config/
fi
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
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ActiveBorderDelay 150
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key ActiveBorders 4
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
kwriteconfig --file $TDEHOME/share/config/twinrc --group Windows --key MoveMode Opaque
kwriteconfig --file $TDEHOME/share/config/twinrc --group Desktops --key Number 1
kwriteconfig --file $TDEHOME/share/config/twinrc --group "Notification Messages" --key UseTranslucency true
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group FMSettings --key ShadowEnabled false
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
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveBorderDelay 150
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveBorders 4
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key ActiveMouseScreen false
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
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Windows --key MoveMode Opaque
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group Desktops --key Number 1
sudo kwriteconfig --file /root/.trinity/share/config/twinrc --group "Notification Messages" --key UseTranslucency true
sudo kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group FMSettings --key ShadowEnabled false
rota
echo
printf '\e[A\e[K'
echo -e "  \e[35m░▒▓█\033[0m configuring GTK3 style..."
sudo rm -rf /usr/share/themes/Q4OS02/gtk-3.0/{*,.[!.]*}
if [[ $dark -eq 1 ]]; then
sudo tar -xzf theme/gtk3winten-dark.tar.gz -C  /usr/share/themes/Q4OS02/gtk-3.0/
else
sudo tar -xzf theme/gtk3winten.tar.gz -C  /usr/share/themes/Q4OS02/gtk-3.0/
fi
echo -e "  \e[35m░▒▓█\033[0m configuring xcompmgr..."
#sudo kwriteconfig --file $USER_HOME/.xcompmgrrc --group xcompmgr --key useOpenGL true
sudo tar -xzf theme/xcompmgrrc.tar.gz -C $USER_HOME/
sudo tar -xzf theme/xcompmgrrc.tar.gz -C /root/
echo -e "  \e[35m░▒▓█\033[0m configuring compton-tde..."
sudo tar -xzf theme/compton-tde.conf.tar.gz -C $USER_HOME/
sudo tar -xzf theme/compton-tde.conf.tar.gz -C /root
echo -e "  \e[35m░▒▓█\033[0m disable screensaver & lock after suspend..."
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group ScreenSaver --key Enabled false
kwriteconfig --file $TDEHOME/share/config/kdesktoprc --group ScreenSaver --key Lock false
echo -e "  \e[35m░▒▓█\033[0m Configuring Konqueror ui..."
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key AlwaysNewWin false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key DisplayFileSizeInBytes false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key DoubleClickMoveToParent false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key HoverCloseButton true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key MMBOpensTab true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key ShowFileTips true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key ShowPreviewsInFileTips true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key StandardFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
rota
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key TabCloseActivatePrevious true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key TextHeight 2
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group FMSettings --key UnderlineLinks false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group Trash --key ConfirmDelete true
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group Trash --key ConfirmTrash false
sudo kwriteconfig --file $TDEHOME/share/config/konquerorrc --group "KFileDialog Settings" --key "Automatic Preview" true
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
echo
printf '\e[A\e[K'
sep
echo
echo
echo
progress "$script" 60






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
progress "$script" 65







#========== Color scheme & win10 & 11 wallpapers ================================================================
itemdisp "Applying color scheme & wallpaper..."
wallpw=$(( $RANDOM % 2 ));wallpn=$(( $RANDOM % 4 + 1 ))
if [ $wallpw -eq 1 ]; then
winn=11
else
winn=10
fi
swps="_"
rwallp=q4seb_hd_win$winn$swps$wallpn.jpg
dcop kdesktop KBackgroundIface setWallpaper /opt/trinity/share/wallpapers/$rwallp 6
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key alternateBackground "244,244,244"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key background "244,244,244"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key buttonBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key linkColor "0,0,192"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectBackground "61,174,233"
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
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBackground "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBlend "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeForeground "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeTitleBtnBg "0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key frame "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key handle "240,240,240"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBackground "239,239,239"
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
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key selectBackground "50,70,120"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key visitedLinkColor "90,60,120"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key windowBackground "30,31,32"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key buttonForeground "180,180,180"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key foreground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key windowForeground "215,215,215"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBackground "40,40,40"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeBlend "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeForeground "255,255,255"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeTitleBtnBg "40,40,40"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key frame "237,249,255"
rota
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key handle "39,41,42"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key inactiveBackground "39,41,42"
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
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key selectBackground "61,174,233"
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
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBackground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBlend "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeForeground "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeTitleBtnBg "0,0,0"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key frame "240,240,240"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key handle "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBackground "239,239,239"
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
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key selectBackground "50,70,120"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key visitedLinkColor "90,60,120"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key windowBackground "30,31,32"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key buttonForeground "180,180,180"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key foreground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group General --key windowForeground "215,215,215"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBackground "40,40,40"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeBlend "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeForeground "255,255,255"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key activeTitleBtnBg "40,40,40"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key alternateBackground "240,240,240"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key frame "237,249,255"
rota
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key handle "39,41,42"
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group WM --key inactiveBackground "39,41,42"
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
echo -e "  \e[35m░▒▓█\033[0m installing imagemagick..."
if ! (cat common/packages_list.tmp | grep -q "imagemagick/stable" ); then
echo -e "${YELLOW}"
sudo apt install -y imagemagick
echo -e "${NOCOLOR}"
else
echo -e "${ORANGE}      ¤ Already installed."
fi
echo -e "  \e[35m░▒▓█\033[0m configuring wallpaper for login"
echo "       (please be patient this could take some time...)"
sudo convert /opt/trinity/share/wallpapers/$rwallp -filter Gaussian -blur 0x55 /opt/trinity/share/apps/tdm/themes/windows/background.jpg
if [[ $lowres -eq 1 ]]; then
sudo tar -xzf theme/tdmwin_lowres.tar.gz -C /opt/trinity/share/apps/tdm/themes/windows/
fi
#test dark or light
lightamount=$(sudo convert /opt/trinity/share/apps/tdm/themes/windows/background.jpg -threshold 50% -format "%[fx:100*image.mean]" info:)
if (( $(echo "$lightamount > 60" | bc -l) )); then
sudo sed -i '/<normal font="Segoe UI 58" color=/c\<normal font="Segoe UI 58" color="#555555"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
sudo sed -i '/<normal font="Segoe UI 48" color=/c\<normal font="Segoe UI 48" color="#555555"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
sudo sed -i '/<normal color="#FFFFFF" font="Segoe UI 14"/c\<normal color="#555555" font="Segoe UI 14"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
#sudo sed -i '/<normal color="#FFFFFF" font="Segoe UI 14"/c\<normal color="#000000" font="Segoe UI 14"/>' /opt/trinity/share/apps/tdm/themes/windows/windows.xml
fi
#sudo \cp /opt/trinity/share/wallpapers/$rwallp /opt/trinity/share/apps/ksplash/Themes/Redmond10/Background.png
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
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group Appearance --key HaloText true
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key CycleWheel false
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key DisplayIconsNText DisplayIconsOnly
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key MinimumButtonHeight 38
kwriteconfig --file $TDEHOME/share/config/ktaskbarrc --group General --key MinimumButtonWidth 80
sed -i "/ShowButtonOnHover=/d" $TDEHOME/share/config/ktaskbarrc
kwriteconfig --file $TDEHOME/share/config/launcher_panelapplet_modernui_rc --group General --key ConserveSpace true
kwriteconfig --file $TDEHOME/share/config/launcher_panelapplet_modernui_rc --group General --key DragEnabled true
kwriteconfig --file $TDEHOME/share/config/launcher_panelapplet_modernui_rc --group General --key IconDim 32
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
kwriteconfig --file $TDEHOME/share/config/kickerrc --group General --key Applets2 "KMenuButton_1,ExtensionButton_1,WindowListButton_1,Applet_4,Applet_1,Applet_2,Applet_3,Applet_5"
#echo -e ">> Wait for kicker to restart..."
#dcop kicker kicker restart
#sleep 10
sep
echo
echo
echo
progress "$script" 80








#========== Configuring systray clock ===========================================================================
itemdisp "Configuring systray clock..."
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Foreground_Color "220,220,220"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Shadow_Color "255,255,255"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Date --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Date --key Font "Segoe UI,8,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Date --key Foreground_Color "33,33,33"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Digital --key Foreground_Color "195,195,195"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Digital --key Shadow_Color "240,240,240"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Digital --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Fuzzy --key Foreground_Color "228,228,228"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Fuzzy --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Font "Segoe UI,10,-1,5,63,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Background_Color invalid
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Foreground_Color "1,0,0"
if [[ $dark -eq 1 ]]
then
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Background_Color "39,41,42"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Background_Color "39,41,42"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Date --key Background_Color "39,41,42"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Date --key Foreground_Color "215,215,215"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Digital --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Digital --key Background_Color "39,41,42"
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Fuzzy --key Foreground_Color "215,215,215"
#kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Fuzzy --key Background_Color "39,41,42"
fi
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Antialias 2
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key LCD_Style false
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Analog --key Show_Seconds false
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Fuzzy --key Show_Date false
kwriteconfig --file $TDEHOME/share/config/clock_panelapplet_rc --group Plain --key Show_Date true
sudo sed -i '/Type=/d' $USER_HOME/.trinity/share/config/clock_panelapplet_rc
sudo sed -i '/Use_Shadow=/d' $USER_HOME/.trinity/share/config/clock_panelapplet_rc
sep
echo
echo
echo
progress "$script" 85







#========== Fonts. Mostly Segoe UI & conslas for Konsole ========================================================
itemdisp "Configuring fonts"
kwriteconfig --file $TDEHOME/share/config/kcmfonts --group General --key dontChangeAASettings true
#kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key fixed "Droid Sans Mono,9,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key fixed "Consolas,11,-1,5,50,0,0,0,0,0"
#kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key fixed "Cascadia Code,11,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key font "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key menuFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key taskbarFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group General --key toolBarFont "Segoe UI,9,-1,5,50,0,0,0,0,0"
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group WM --key activeFont "Segoe UI,10,-1,5,50,0,0,0,0,0"
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
sed -i '/font_name="/c\font_name="Segoe UI 10"' $USER_HOME/.gtkrc-q4os
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
kwriteconfig --file /root/.trinity/share/config/konsolerc --group "Desktop Entry" --key defaultfont "Consolas,11,-1,5,50,0,0,0,0,0"
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
sep
echo
echo
echo
progress "$script" 90




#========== Configuring icons ===================================================================================
# based on kdeten from Q4os Plasma edition :p with some modifications
itemdisp "Configuring icons..."
if [[ $dark -eq 1 ]]; then
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group Icons --key Theme kdeten_dark
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="Windows10Light"' $USER_HOME/.gtkrc-q4os
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group Icons --key Theme kdeten_dark
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_dark
sudo sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="Windows10Light"' /root/.gtkrc-q4os
else
kwriteconfig --file $TDEHOME/share/config/kdeglobals --group Icons --key Theme kdeten_light
kwriteconfig --file $USER_HOME/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
kwriteconfig --file $USER_HOME/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="Windows10Light"' $USER_HOME/.gtkrc-q4os
#root
sudo kwriteconfig --file /root/.trinity/share/config/kdeglobals --group Icons --key Theme kdeten_light
sudo kwriteconfig --file /root/.configtde/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
sudo kwriteconfig --file /root/.config/gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name kdeten_light
sudo sed -i '/gtk-icon-theme-name="/c\gtk-icon-theme-name="Windows10Light"' /root/.gtkrc-q4os
fi
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


#========== DONE. ==================================================================================================
alldone

echo
echo -e "\e[5m~~ reboot is required ~~\e[25m"
echo
echo " > Do you want to reboot right now ? (y/n)" && read x && [[ "$x" == "y" ]] && sudo /sbin/reboot;
echo
wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz

