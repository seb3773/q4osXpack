#!/bin/bash
# author: Whizzzkid (me@nishantarora.in) // forked  & improved for Trinity DE by seb3773
checkint=3
wpath="$HOME/Pictures/Bing/"
size="1920x1200"
#################################
bing="http://www.bing.com";api="/HPImageArchive.aspx?"
format="&format=js";day="&idx=0";market="&mkt=en-US";const="&n=1"
extn=".jpg";incron=0
run_once=true;name="bingwallpaper.sh"
sep="+------------------------+"
scfold=$(dirname "$(readlink -f "$0")")
col_lrbg='\033[101m';col_wt='\033[97m'
col_r='\033[0m';col_lrt='\033[91m'
col_lgt='\033[92m';col_lot='\033[38;5;214m'
col_bt='\033[30m';col_ybg='\033[43m'
col_btt='\033[38;5;81m';col_ytx='\033[38;5;226m'
col_lbbg='\033[48;5;159m';col_ct='\033[96m'
col_dgbg='\033[100m';col_mt='\033[95m'
titl="          ${col_lbbg}${col_bt}      -= bingwallpaper =-      ${col_r}"
usage(){ echo -e "${col_wt}${col_dgbg}Usage:${col_r}"
echo -e " \"$name\"       ${col_ct}run and exit${col_r}"
echo -e " \"$name -d\"    ${col_ct}run as daemon${col_r}"
echo -e " \"$name -k\"    ${col_ct}kill daemon${col_r}"
echo -e " \"$name -c\"    ${col_ct}add task to cron${col_r}"
echo -e " \"$name -r\"    ${col_ct}remove task from cron${col_r}"
echo -e " \"$name -i\"    ${col_ct}set check interval${col_r}"
echo -e " \"$name -f\"    ${col_ct}set wallpapers download folder${col_r}"
echo -e " \"$name -s\"    ${col_ct}set image size${col_r}"
echo -e " \"$name -p\"    ${col_ct}display status/settings${col_r}"
echo -e " \"$name -h\"    ${col_ct}help${col_r}";echo;}
helptxt(){ echo -e "${col_lot} §-${col_r}$name is a simple script that retrieves 'Bing image of the day' and"
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
testapi(){ attempt=1;while [ $attempt -le 2 ]
do apiResp=$(curl -s $reqImg);if [ $? -gt 0 ];then
echo -e -n "${col_lrt}API not responding.${col_r} Retry $attempt/2 in 10s"
dotsleep;attempt=$((attempt + 1));else return 0;fi;done;return 1;}
getimage(){ attempt=1;while [ $attempt -le 2 ]
do defImgURL=$bing$(echo $apiResp | grep -oP "url\":\"[^\"]*" | cut -d "\"" -f 3)
reqImgURL=$bing$(echo $apiResp | grep -oP "urlbase\":\"[^\"]*" | cut -d "\"" -f 3)"_"$size$extn
if ! wget --quiet --spider --max-redirect 0 $reqImgURL; then
reqImgURL=$defImgURL;fi
if [[ $reqImgURL == *".jpg"* ]]; then return 0;else
echo -e -n "${col_lrt}Image url not valid${col_r} Retry $attempt/2 in 10s"
dotsleep;attempt=$((attempt + 1));fi;done;return 1;}
echo;if [ "$#" -gt 1 ]; then
echo -e "${col_lrbg}${col_wt}Error: only one argument is allowed at a time.${col_r}";usage
echo;exit;fi
if [ -n "$1" ]; then case "$1" in
-d) if crontab -l 2>/dev/null | grep -q "bingwallpaper_entry"; then
echo -e "${col_lrbg}${col_wt}* bingwallpaper job is present in cron, this is redudant to launch it as daemon too.${col_r}"
echo "(to run bingwallpaper as daemon, please remove cron job first: $name -r)"
echo;exit;fi
countbp=$(pgrep -fc "bingwallpaper.sh -d") > /dev/null 2>&1
if (( countbp > 1 )); then
echo -e "${col_lrbg}${col_wt}bingwallpaper already running in daemon mode.${col_r}";echo;exit;fi
run_once=false
echo -e "${col_lgt}Running as daemon. Check interval: $checkint hours ${col_r}" ;;
-k) if pgrep -fc "bingwallpaper.sh -d"> /dev/null 2>&1;then
echo -e "${col_lgt}Stopping bingwallpaper daemon ${col_r}"
kill $(pgrep -f "bingwallpaper.sh -d") > /dev/null 2>&1
else echo -e "${col_lrt}bingwallpaper daemon not found. Nothing to stop.${col_r}";echo;fi;exit ;;
-c) if crontab -l 2>/dev/null | grep -q "bingwallpaper_entry"; then
echo -e "${col_lrt}bingwallpaper job entry already in crontab.${col_r}";echo;exit
else if pgrep -fc "bingwallpaper.sh -d"> /dev/null 2>&1;then
echo -e "${col_lrbg}${col_wt}* bingwallpaper is running in daemon mode, this is redudant to add it to cron jobs too.${col_r}"
echo "(to add bingwallpaper to cron jobs, please stop the daemon first: $name -k)"
echo;exit
else run_once=true
echo -e "${col_lgt}Adding task to cron - Check interval: $checkint hours ${col_r}"
(crontab -l 2>/dev/null | grep -v bingwallpaper_entry; echo "0 */$checkint * * * USR=$USER $scfold/bingwallpaper.sh -cron #bingwallpaper_entry") | crontab
echo "done.";fi;fi ;;
-r) if crontab -l 2>/dev/null | grep -q "bingwallpaper_entry"; then
echo -e "${col_lgt}Removing task from cron${col_r}"
crontab -l 2>/dev/null | grep -v bingwallpaper_entry | crontab
echo done.
else echo -e "${col_lrt}No bingwallpaper job entry found in crontab. Nothing to remove.${col_r}";fi;echo;exit ;;
-i) echo -e "Current check interval: ${col_lgt}$checkint hours${col_r}";echo $sep
while true; do
echo -e -n "Enter new interval (in hours) / ${col_mt}q to quit${col_r} : ";read new_checkint
if [[ "$new_checkint" == "q" ]]; then echo "Exited.";break
elif [[ "$new_checkint" =~ ^[0-9]+$ ]] && [ "$new_checkint" -ge 1 ] && [ "$new_checkint" -le 12 ]; then
echo -e "${col_lgt}New check interval: $new_checkint hours ${col_r}"
if crontab -l 2>/dev/null | grep -q "bingwallpaper_entry"; then
echo -e "${col_lot}  > updating cronjob run interval${col_r}"
(crontab -l 2>/dev/null | grep -v bingwallpaper_entry; echo "0 */$new_checkint * * * USR=$USER $scfold/bingwallpaper.sh -cron #bingwallpaper_entry") | crontab
fi
echo -e "${col_lot}  > updating script source ${col_r}"
sudo sed -i "s/^checkint=.*/checkint=$new_checkint/" "$scfold/bingwallpaper.sh"
if pgrep -f "bingwallpaper.sh -d";then
echo -e "${col_lot}  > restarting daemon${col_r}"
kill $(pgrep -f "bingwallpaper.sh -d")
nohup $scfold/bingwallpaper.sh -d > /dev/null 2>&1 &
fi;break;exit
else echo -e "${col_lrt}Invalid value, please enter a value between 1 and 12.${col_r}";fi
done;echo;exit ;;
-f) echo -e "Current bing wallpapers folder: ${col_lgt}$wpath${col_r}";echo $sep
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
echo -e "${col_lgt}New bing wallpapers folder:  $selected_path ${col_r}"
echo -e "${col_lot} > updating script source ${col_r}"
sudo sed -i "s|^wpath=.*|wpath=\"$selected_path\"|" "$scfold/bingwallpaper.sh"
if pgrep -f "bingwallpaper.sh -d";then
echo -e "${col_lot} > restarting daemon${col_r}"
kill $(pgrep -f "bingwallpaper.sh -d")
nohup $scfold/bingwallpaper.sh -d > /dev/null 2>&1 &
fi;break;exit
else echo -e "${col_lrt}Error: Cannot write to the directory $selected_path ${col_r}"
echo " Please select another path.";fi
else echo -e "${col_lrt}Error: Cannot create or access the directory $selected_path ${col_r}"
echo " Please select another path.";fi
done;echo;exit ;;
-cron) run_once=true;incron=1 ;;
-h|-\?) echo -e "$titl";echo;helptxt;usage;exit ;;
-s) echo -e "Current image size: ${col_lgt}$size ${col_r}";echo $sep
echo "> possible sizes choices:";echo "   1 -   1920x1200";echo "   2 -   1920x1080";
echo "   3 -   1366x768";echo "   4 -   800x600"
while true; do
echo -e -n "Select image size (1-4) / ${col_mt}q to quit${col_r} : ";read selected_size
if [[ "$selected_size" == "q" ]]; then echo "Exited.";break
elif [[ "$selected_size" =~ ^[0-4]+$ ]] && [ "$selected_size" -ge 1 ] && [ "$selected_size" -le 4 ]; then
case $selected_size in 1) size="1920x1200" ;; 2) size="1920x1080" ;;
3) size="1366x768" ;; 4) size="800x600" ;; esac;size="\"$size\"";echo -e "${col_lgt}New selected image size: $size ${col_r}"
echo -e "${col_lot}  > updating script source ${col_r}"
sudo sed -i "s/^size=.*/size=$size/" "$scfold/bingwallpaper.sh"
if pgrep -f "bingwallpaper.sh -d";then
echo -e "${col_lot}  > restarting daemon${col_r}"
kill $(pgrep -f "bingwallpaper.sh -d")
nohup $scfold/bingwallpaper.sh -d > /dev/null 2>&1 &
fi;break;exit
else echo -e "${col_lrt}Invalid value, please enter a value between 1 and 4.${col_r}";fi
done;echo;exit ;;
-p) echo -e "$titl"
echo -e "- Current check interval: ${col_lgt}$checkint hours${col_r}"
bfiles=$(find "$wpath" -maxdepth 1 -type f | wc -l)
if [ $bfiles -gt 0 ]; then msgfiles="  ($bfiles files.)";else msgfiles="  (empty)";fi
echo -e "- Current bing wallpapers folder: ${col_lgt}$wpath $msgfiles${col_r}"
echo -e "- Current image size: ${col_lgt}$size${col_r}"
if pgrep -fc "bingwallpaper.sh -d"> /dev/null 2>&1;then
echo -e "-${col_lgt} Daemon is running.${col_r}";else echo -e "-${col_lot} Daemon not running.${col_r}";fi
if crontab -l 2>/dev/null | grep -q "bingwallpaper_entry"; then
echo -e "-${col_lgt} bingwallpaper job entry present in crontab:${col_r}"-
crontab -l;else echo -e "-${col_lot} bingwallpaper job entry not in crontab.${col_r}";fi
echo;exit ;;
*) echo -e "${col_lrbg}${col_wt}Invalid option \"$1\"${col_r}";usage;exit ;;
esac
else run_once=true;fi
reqImg=$bing$api$format$day$market$const
while [ 1 ]
do testapi
if [ $? -eq 0 ]; then getimage
if [ $? -eq 0 ]; then
echo -e "${col_ybg}${col_bt}Bing Image of the day:${col_r} ${col_ytx} $reqImgURL ${col_r}"
imgName=${reqImgURL##*/}
shortName=${imgName#*OHR.}
shortName=${shortName%%_$size.jpg*}
if [ ! -d "$wpath" ]; then mkdir -p "$wpath";fi
curl -L -s -o $wpath$imgName $reqImgURL
echo -e "${col_ybg}${col_bt}Saving image to:${col_r}  ${col_btt} $wpath ${col_r}"
if [ $incron -eq 0 ];then
/opt/trinity/bin/dcop kdesktop KBackgroundIface setWallpaper "$wpath$imgName" 6
else /opt/trinity/bin/dcop --no-user-time --user $USR --all-sessions kdesktop KBackgroundIface setWallpaper "$wpath$imgName" 6
fi;if [ "$run_once" == true ] && [ "$incron" -eq 0 ];then
/opt/trinity/bin/dcop knotify Notify notify "bingwallpaper" "knotify" "bingwallpaper \"$shortName\" applied." "" "" 16 2
fi;fi;fi;if [ $run_once == true ];then break;fi
sleep $((checkint * 3600))
done;echo
