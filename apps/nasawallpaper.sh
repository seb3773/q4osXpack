#!/bin/bash
# Nasa wallpaper of the day  for Trinity DE by seb3773
checkint=3
wpath="$HOME/Pictures/Nasa/"
#################################
incron=0;req=""
run_once=true;name="nasawallpaper.sh"
sep="+------------------------+"
scfold=$(dirname "$(readlink -f "$0")")
col_lrbg='\033[101m';col_wt='\033[97m'
col_r='\033[0m';col_lrt='\033[91m'
col_lgt='\033[92m';col_lot='\033[38;5;214m'
col_bt='\033[30m';col_ybg='\033[43m'
col_btt='\033[38;5;81m';col_ytx='\033[38;5;226m'
col_lbbg='\033[48;5;159m';col_ct='\033[96m'
col_dgbg='\033[100m';col_mt='\033[95m'
titl="          ${col_lbbg}${col_bt}      -= nasawallpaper =-      ${col_r}"
usage(){ echo -e "${col_wt}${col_dgbg}Usage:${col_r}"
echo -e " \"$name\"       ${col_ct}run and exit${col_r}"
echo -e " \"$name -d\"    ${col_ct}run as daemon${col_r}"
echo -e " \"$name -k\"    ${col_ct}kill daemon${col_r}"
echo -e " \"$name -c\"    ${col_ct}add task to cron${col_r}"
echo -e " \"$name -r\"    ${col_ct}remove task from cron${col_r}"
echo -e " \"$name -i\"    ${col_ct}set check interval${col_r}"
echo -e " \"$name -f\"    ${col_ct}set wallpapers download folder${col_r}"
echo -e " \"$name -p\"    ${col_ct}display status/settings${col_r}"
echo -e " \"$name -h\"    ${col_ct}help${col_r}";echo;}
helptxt(){ echo -e "${col_lot} §-${col_r}$name is a simple script that retrieves 'Nasa image of the day' and"
echo "   set it as current wallpaper. It is designed for Trinity DE."
echo "   You can run it 'singleshot' by just executing the script without arguments,"
echo -e "   run it as a daemon (${col_wt}${col_dgbg}-d${col_r}), or add it to cron jobs (${col_wt}${col_dgbg}-c${col_r})."
echo -e "${col_lot} §-${col_r}You can set the check interval in daemon/cronjob mode (${col_wt}${col_dgbg}-i${col_r}); don't forget the image"
echo "   is renewed only once a day, so depending of your usage it's maybe not usefull";echo "   to set a too short interval."
echo -e "   You can specify too the folder where images will be downloaded (${col_wt}${col_dgbg}-f${col_r}); if it doesn't exist"
echo "   yet, it will be created if possible."
echo -e "${col_lot} §-${col_r}You can put the script anywhere, but I recommend the folder /usr/local/bin"
echo "   so it will be available for all users as a direct command.";}
dotsleep(){ for i in {1..10};do sleep 1;echo -n ".";done;echo;}
testsiteok(){ attempt=1;while [ $attempt -le 2 ]
do req=$(curl -s https://apod.nasa.gov/apod/)
if [ $? -gt 0 ];then
echo -e -n "${col_lrt}Nasa website not responding.${col_r} Retry $attempt/2 in 10s"
dotsleep;attempt=$((attempt + 1));else return 0;fi;done;return 1;}
getimage(){ attempt=1;while [ $attempt -le 2 ]
do reqImgURL=$(echo "$req" | grep -oP '(?<=<IMG SRC=")[^"]*')
if [[ $reqImgURL == *".jpg"* ]]; then return 0;else
echo -e -n "${col_lrt}Image url not valid${col_r} Retry $attempt/2 in 10s"
dotsleep;attempt=$((attempt + 1));req=$(curl -s https://apod.nasa.gov/apod/);fi;done;return 1;}
echo;if [ "$#" -gt 1 ]; then
echo -e "${col_lrbg}${col_wt}Error: only one argument is allowed at a time.${col_r}";usage
echo;exit;fi
if [ -n "$1" ]; then case "$1" in
-d) if crontab -l 2>/dev/null | grep -q "nasawallpaper_entry"; then
echo -e "${col_lrbg}${col_wt}* nasawallpaper job is present in cron, this is redudant to launch it as daemon too.${col_r}"
echo "(to run nasawallpaper as daemon, please remove cron job first: $name -r)"
echo;exit;fi
countbp=$(pgrep -fc "nasawallpaper.sh -d") > /dev/null 2>&1
if (( countbp > 1 )); then
echo -e "${col_lrbg}${col_wt}nasawallpaper already running in daemon mode.${col_r}";echo;exit;fi
run_once=false
echo -e "${col_lgt}Running as daemon. Check interval: $checkint hours ${col_r}" ;;
-k) if pgrep -fc "nasawallpaper.sh -d"> /dev/null 2>&1;then
echo -e "${col_lgt}Stopping nasawallpaper daemon ${col_r}"
kill $(pgrep -f "nasawallpaper.sh -d") > /dev/null 2>&1
else echo -e "${col_lrt}nasawallpaper daemon not found. Nothing to stop.${col_r}";echo;fi;exit ;;
-c) if crontab -l 2>/dev/null | grep -q "nasawallpaper_entry"; then
echo -e "${col_lrt}nasawallpaper job entry already in crontab.${col_r}";echo;exit
else if pgrep -fc "nasawallpaper.sh -d"> /dev/null 2>&1;then
echo -e "${col_lrbg}${col_wt}* nasawallpaper is running in daemon mode, this is redudant to add it to cron jobs too.${col_r}"
echo "(to add nasawallpaper to cron jobs, please stop the daemon first: $name -k)"
echo;exit
else run_once=true
echo -e "${col_lgt}Adding task to cron - Check interval: $checkint hours ${col_r}"
(crontab -l 2>/dev/null | grep -v nasawallpaper_entry; echo "0 */$checkint * * * USR=$USER $scfold/nasawallpaper.sh -cron #nasawallpaper_entry") | crontab
echo "done.";fi;fi ;;
-r) if crontab -l 2>/dev/null | grep -q "nasawallpaper_entry"; then
echo -e "${col_lgt}Removing task from cron${col_r}"
crontab -l 2>/dev/null | grep -v nasawallpaper_entry | crontab
echo done.
else echo -e "${col_lrt}No nasawallpaper job entry found in crontab. Nothing to remove.${col_r}";fi;echo;exit ;;
-i) echo -e "Current check interval: ${col_lgt}$checkint hours${col_r}";echo $sep
while true; do
echo -e -n "Enter new interval (in hours) / ${col_mt}q to quit${col_r} : ";read new_checkint
if [[ "$new_checkint" == "q" ]]; then echo "Exited.";break
elif [[ "$new_checkint" =~ ^[0-9]+$ ]] && [ "$new_checkint" -ge 1 ] && [ "$new_checkint" -le 12 ]; then
echo -e "${col_lgt}New check interval: $new_checkint hours ${col_r}"
if crontab -l 2>/dev/null | grep -q "nasawallpaper_entry"; then
echo -e "${col_lot}  > updating cronjob run interval${col_r}"
(crontab -l 2>/dev/null | grep -v nasawallpaper_entry; echo "0 */$new_checkint * * * USR=$USER $scfold/nasawallpaper.sh -cron #nasawallpaper_entry") | crontab
fi
echo -e "${col_lot}  > updating script source ${col_r}"
sudo sed -i "s/^checkint=.*/checkint=$new_checkint/" "$scfold/nasawallpaper.sh"
if pgrep -f "nasawallpaper.sh -d";then
echo -e "${col_lot}  > restarting daemon${col_r}"
kill $(pgrep -f "nasawallpaper.sh -d")
nohup $scfold/nasawallpaper.sh -d > /dev/null 2>&1 &
fi;break;exit
else echo -e "${col_lrt}Invalid value, please enter a value between 1 and 12.${col_r}";fi
done;echo;exit ;;
-f) echo -e "Current nasa wallpapers folder: ${col_lgt}$wpath${col_r}";echo $sep
while true; do
echo -e -n "Enter a new folder /  ${col_mt}q to quit ${col_r}: ";read selected_path
if [[ "$selected_path" == "q" ]]; then
echo "Exited.";break;fi
selected_path=$(realpath -m "$selected_path")
if [[ "${selected_path: -1}" != "/" ]]; then selected_path="${selected_path}/";fi
mkdir -p "$selected_path" 2>/dev/null
if [[ -d "$selected_path" && -w "$selected_path" ]]; then
touch "$selected_path/writetest" 2>/dev/null
if [[ -f "$selected_path/writetest" ]]; then
rm "$selected_path/writetest"
echo -e "${col_lgt}New nasa wallpapers folder:  $selected_path ${col_r}"
echo -e "${col_lot} > updating script source ${col_r}"
sudo sed -i "s|^wpath=.*|wpath=\"$selected_path\"|" "$scfold/nasawallpaper.sh"
if pgrep -f "nasawallpaper.sh -d";then
echo -e "${col_lot} > restarting daemon${col_r}"
kill $(pgrep -f "nasawallpaper.sh -d")
nohup $scfold/nasawallpaper.sh -d > /dev/null 2>&1 &
fi;break;exit
else echo -e "${col_lrt}Error: Cannot write to the directory $selected_path ${col_r}"
echo " Please select another path.";fi
else echo -e "${col_lrt}Error: Cannot create or access the directory $selected_path ${col_r}"
echo " Please select another path.";fi
done;echo;exit ;;
-cron) run_once=true;incron=1 ;;
-h|-\?) echo -e "$titl";echo;helptxt;usage;exit ;;
-p) echo -e "$titl"
echo -e "- Current check interval: ${col_lgt}$checkint hours${col_r}"
bfiles=$(find "$wpath" -maxdepth 1 -type f | wc -l)
if [ $bfiles -gt 0 ]; then msgfiles="  ($bfiles files.)";else msgfiles="  (empty)";fi
echo -e "- Current nasa wallpapers folder: ${col_lgt}$wpath $msgfiles${col_r}"
if pgrep -fc "nasawallpaper.sh -d"> /dev/null 2>&1;then
echo -e "-${col_lgt} Daemon is running.${col_r}";else echo -e "-${col_lot} Daemon not running.${col_r}";fi
if crontab -l 2>/dev/null | grep -q "nasawallpaper_entry"; then
echo -e "-${col_lgt} nasawallpaper job entry present in crontab:${col_r}"-
crontab -l;else echo -e "-${col_lot} nasawallpaper job entry not in crontab.${col_r}";fi
echo;exit ;;
*) echo -e "${col_lrbg}${col_wt}Invalid option \"$1\"${col_r}";usage;exit ;;
esac;else run_once=true;fi
while [ 1 ]
do testsiteok
if [ $? -eq 0 ]; then getimage
if [ $? -eq 0 ]; then
echo -e "${col_ybg}${col_bt}Nasa Image of the day:${col_r} ${col_ytx} $reqImgURL ${col_r}"
imgName=$(basename "$reqImgURL")
if [ ! -d "$wpath" ]; then mkdir -p "$wpath";fi
curl -L -s -o $wpath$imgName "https://apod.nasa.gov/apod/"$reqImgURL
echo -e "${col_ybg}${col_bt}Saving image to:${col_r}  ${col_btt} $wpath ${col_r}"
if [ $incron -eq 0 ];then
/opt/trinity/bin/dcop kdesktop KBackgroundIface setWallpaper "$wpath$imgName" 6
else /opt/trinity/bin/dcop --no-user-time --user $USR --all-sessions kdesktop KBackgroundIface setWallpaper "$wpath$imgName" 6
fi;if [ "$run_once" == true ] && [ "$incron" -eq 0 ];then
/opt/trinity/bin/dcop knotify Notify notify "nasawallpaper" "knotify" "nasawallpaper \"$imgName\" applied." "" "" 16 2
fi;fi;fi;if [ $run_once == true ];then break;fi
sleep $((checkint * 3600))
done;echo
