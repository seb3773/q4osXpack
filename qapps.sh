#!/bin/bash
script="Qapps script"
source common/begin
source common/progress
begin "$script"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
progress "$script" 0

itemdisp "Installing GIT..."
echo -e "${YELLOW}"
sudo apt install -y git
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 5



itemdisp "Installing Ark..."
echo -e "${YELLOW}"
sudo apt install -y ark
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 10


itemdisp "Installing Dolphin..."
echo -e "${YELLOW}"
sudo apt install -y dolphin-trinity
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 15



itemdisp "Installing Baobab..."
echo -e "${YELLOW}"
sudo apt install -y baobab
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 20

itemdisp "Installing system-config-printer..."
echo -e "${YELLOW}"
sudo apt install -y system-config-printer
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 25

itemdisp "Installing flashfetch"
cd apps
echo -e "${YELLOW}"
sudo tar -xzf flashfetch.tar.gz -C /usr/bin/
echo "flashfetch binary copied in /usr/bin/"
cd ..
echo -e "${NOCOLOR}"
flashfetch
sep
echo
echo
echo
progress "$script" 30



itemdisp "Installing Stacer..."
echo -e "${YELLOW}"
sudo apt install -y stacer
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 35



itemdisp "Installing bleachbit..."
echo -e "${YELLOW}"
sudo apt install -y bleachbit
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 40



itemdisp "Installing vlc..."
echo -e "${YELLOW}"
sudo apt install -y vlc
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 45

#classics tools, may be already installed with desktop version
itemdisp "Installing Kolourpaint,KCharSelect,Ksnapshot,knotes..."
echo
echo -e "  \e[35m░▒▓█\033[0m Installing Kolourpaint..."
echo -e "${YELLOW}"
sudo apt install -y kolourpaint-trinity
echo -e "${NOCOLOR}"
echo -e "  \e[35m░▒▓█\033[0m Installing KCharSelect..."
echo -e "${YELLOW}"
sudo apt install -y kcharselect-trinity
echo -e "${NOCOLOR}"
echo -e " \e[35m░▒▓█\033[0m Installing Ksnapshot..."
echo -e "${YELLOW}"
sudo apt install -y ksnapshot-trinity
echo -e "${NOCOLOR}"
echo -e " \e[35m░▒▓█\033[0m Installing Knotes..."
echo -e "${YELLOW}"
sudo apt install -y knotes-trinity
echo -e "${NOCOLOR}"
sep
echo
echo
echo
progress "$script" 50



itemdisp "Installing qbittorent"
echo
echo -e "${RED}█ ${ORANGE}Install qbittorrent ?${NOCOLOR}"
optionz=("Install qbittorrent" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install qbittorrent")
            echo -e "  \e[35m░▒▓█\033[0m Installing qbittorrent..."
            echo -e "${YELLOW}"
            sudo apt-get install -y qbittorrent
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 55



itemdisp "Installing spotify"
echo
echo -e "${RED}█ ${ORANGE}Install spotify ?${NOCOLOR}"
optionz=("Install spotify" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install spotify")
            echo -e "  \e[35m░▒▓█\033[0m Installing spotify..."
            echo -e "${YELLOW}"
            curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
            echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
            sudo apt-get update
            sudo apt-get install -y spotify-client
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 60




itemdisp "Installing gparted"
echo
echo -e "${RED}█ ${ORANGE}Install gparted ? (partitions manager)${NOCOLOR}"
optionz=("Install gparted" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install gparted")
            echo -e "  \e[35m░▒▓█\033[0m Installing gparted..."
            echo -e "${YELLOW}"
            sudo apt install -y gparted
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 65




itemdisp "Installing S4 Snapshot"
echo
echo -e "${RED}█ ${ORANGE}Install S4 Snapshot ? (create an bootable iso of a running system)${NOCOLOR}"
optionz=("Install S4 Snapshot" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install S4 Snapshot")
            echo -e "  \e[35m░▒▓█\033[0m Installing S4 Snapshot..."
            echo -e "${YELLOW}"
            cd apps
            sudo qsinst setup_q4os-s4-snapshot_4.1-a1_amd64.qsi
            cd ..
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 70





itemdisp "Installing remmina"
echo
echo -e "${RED}█ ${ORANGE}Install remmina ? (rdp / vnc / ssh remote desktop client)${NOCOLOR}"
optionz=("Install remmina" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install remmina")
            echo -e "  \e[35m░▒▓█\033[0m Installing remmina..."
            echo -e "${YELLOW}"
            sudo apt install -y remmina
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 75




itemdisp "Installing free office"
echo
echo -e "${RED}█ ${ORANGE}Install free office (a word/excel/ppoint clone) ?${NOCOLOR}"
optionz=("Install free office" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install free office")
            echo -e "  \e[35m░▒▓█\033[0m Installing free office..."
            echo -e "${YELLOW}"
            mkdir -p /etc/apt/keyrings
            sudo bash -c 'wget -qO- https://shop.softmaker.com/repo/linux-repo-public.key | gpg --dearmor > /etc/apt/keyrings/softmaker.gpg'
            sudo bash -c 'echo "deb [signed-by=/etc/apt/keyrings/softmaker.gpg] https://shop.softmaker.com/repo/apt stable non-free" > /etc/apt/sources.list.d/softmaker.list'
            sudo apt update
            sudo apt install -y softmaker-freeoffice-2021
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 80



itemdisp "Installing bpytop"
echo
echo -e "${RED}█ ${ORANGE}Install bpytop ? (CLI htop alternative)${NOCOLOR}"
optionz=("Install bpytop" "Skip")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install bpytop")
            echo -e "  \e[35m░▒▓█\033[0m Installing bpytop"
            echo -e "${YELLOW}"
            #sudo qsinst setup_q4os-skype_3.2-a1_amd64.esh
            sudo apt install -y bpytop
            echo -e "${NOCOLOR}"
            break
            ;;
        "Skip")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
sep
echo
echo
echo
progress "$script" 85







itemdisp "Cleaning files..."
echo
sudo apt clean
sudo apt autoremove -y
sep
echo
echo
echo
progress "$script" 100


alldone
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
