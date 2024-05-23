#!/bin/bash
LIGHTGRAY='\033[0;37m'
NOCOLOR='\033[0m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
YELLOW='\033[0;93m'
InstallTLPgui() {
sudo apt install -y python3-gi git python3-setuptools python3-stdeb dh-python
            sudo git clone https://github.com/d4nj1/TLPUI
            cd TLPUI
            sudo python3 setup.py --command-packages=stdeb.command bdist_deb
            sudo dpkg -i deb_dist/python3-tlpui_*all.deb
            cd ..
            sudo rm -R TLPUI
}
echo
echo
if [ $# -gt 0 ] && [ "$1" = "yes" ]; then
InstallTLPgui
else
echo -e "${RED}█ ${ORANGE}Install tlpui ? (gui for tlp settings)${NOCOLOR}"
optionz=("Install tlpui" "Skip tlpui install")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install tlpui")
            echo -e "  \e[35m░▒▓█\033[0m Installing TLP gui..."
            echo -e "${YELLOW}"
            InstallTLPgui
            echo -e "${NOCOLOR}"
            kdialog --msgbox "TLPUI will open now, you can just close the windows \n to accept standard settings or edit them"  --caption "TLPUI" --title "Qlaptop"
            tlpui > /dev/null 2>&1
            break
            ;;
        "Skip tlpui install")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
echo

