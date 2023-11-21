# Q4OSseb

Scripts to reconfigure a bit Q4OS Trinity to fit my needs. (theming, performances, laptop configuration and 'defaults' applications selected by me).
They were designed for Q4OS Aquarius 64bits, but I think nothing prevents the main parts to work with a 32bits version. Please report to me if there are problems.
I don't think it will work 'as is' on another distribution using Trinity, but you can try :p
Classic desktop usage is targeted.

There are 4 main scripts:

## ██ Qtheme script:
This is a script that will modify your Q4OS Trinity installation to make it a bit like like Windows 10. Not the real thing of course, I had to 'adapt' some things because I doesn't know how to mimic some parts with TDE Trinity, but it's the closest I can do now. I did it in the first place because I wanted to 'recycle' old computers at my work who weren't... let's say windows 10 capables :p 
This is my attempt to have the responsivness of Q4OS Trinity and the windows 10 look & feel (kind of) for customers who used to work with windows before.
You can choose between a 'light' theme and a 'dark' one. It's somekind of a full theme with icons, pointers, windows decorations, widgets style, color schemes, sounds, taskbar setup, konqueror profiles,boot splash, gtk theme, etc...

## ▓▓ Qperf script:
This one is designed to try to improve performances of your system. If you have a very recent computer, you maybe don't need it. But my testing on differents systems shows that even modern computers can gain some benefits from it. You can install a new optimized kernel (choice between xanmod & liquorix), optional of course. It will install preload, disabling some services not really needed for classic desktop usage, disable javascript in libre office (if installed),tune compton-tde conf, removes ufw & some fonts, do some sysctl tweaks, disable core dump, setup temp directories as tmps, disabling some loggin, install zram, install kexec for faster reboot, trim initramfs size and finally some cleaning.
I tested it a lot, but if something horrible happens, you can restore the backup created in the folder backup/ , by simply launching the restore script.

## ▒▒ Qlaptop:
This will adjust some things in the system to adapt it better to a laptop usage. First it will uninstall TDEPowersave. I had a lots of problems with it (crash on some very old  laptops) and I prefer to use TLP. It will install xfce4-power-manager (please note I adapted the iconset for it, there was a naming problem with the *battery* icons with all the iconsets I tried). It enables two fingers scrolling & disable pad middle click (something which annoy me a lot on large pads). It will remove powertop and install TLP (with the optionnal option to install the TLP graphical interface for easier tuning of the settings). It will then configures xfce4-power-manager & logind.conf to handle suspend on lid switch action.
You will have the option to create a swap file for hibernation, and it will then configure the settings to allow suspend-then-hibernate.

## ░░ Qapps:
Designed to install a set of apps I consider usefull for the usage I have. This reflect only my choices, so you maybe don't need it.

-Apps installed by default: GIT, Ark (archive manager), Dolphin trinity, Baobab (disk usage), system-config-printer, flashfetch (fast cli system info), Stacer, Bleachbit, vlc, Kolourpaint,KCharSelect,Ksnapshot,knote. [some of them could be already installed, depending of your Q4os profile choice at install]

-Apps with choice to install: qbittorent, spotify, gparted, S4 Snapshot, remmina (rdp / vnc / ssh remote desktop client), free office, bpytop (improved htop), virtualbox 7.


¤¤ Please note that these scripts were initially designed for my own usage, and only for Q4OS, never thought of sharing them at the first place, but it may be of interest for some other people... Be aware that they reflects my choices, so maybe not yours. Please take a look a the sources of the scripts before trying them, you're welcome to modify or improve them for you :)    ¤¤¤
¤¤ Nearly everything was coded on an old laptop, a celeron N3060 with 4gb of non upgradable ram, so it's a good system to see what impacts or not performances. It's nearly unusable on windows 10, even with considerable tweaking, but works very good with Q4os, even without tweaking by the way :) So thanks again to the Q4OS team for this gem :) ¤¤

One last note: This is a "work in progress", especially the theming part. It's usable (I work with this theme on my laptop :p ) but I'm still improving it (tuning some icons or some other ui parts...), so don't hesitate to always retrieve the last version :)

______________________________________________________________________________________________________________________________________
Installation:

Clone the repository:
git clone https://github.com/seb3773/Q4OSseb

Then go to the new folder:
cd Q4OSseb/

Make the scripts executables:
sudo chmod +x *

And then launch the main menu:
./qmenu

You can launch directly the script you want too, for example Qtheme:
./qtheme.sh

 

Parameters for all scripts:  -h  (display a little description of the script)

Parameters for Qtheme:
                             -L  (light theme, default if nothing specified)
                             -d  (dark theme)

Parameters for Qapps:
                             -a  (install everything whithout asking)
______________________________________________________________________________________________________________________________________

Some screenshots:
Dark theme
![Alt text](/screenshots/q4os_seb_screenshot_dark1.jpg?raw=true "dark theme")
![Alt text](/screenshots/q4os_seb_screenshot_dark2.jpg?raw=true "dark theme")

Classic light theme
![Alt text](/screenshots/q4os_seb_screenshot_light.jpg?raw=true "light theme")
![Alt text](/screenshots/q4os_seb_screenshot_light2.jpg?raw=true "light theme")

Login screen (sorry for the bad quality)
![Alt text](/screenshots/q5os_seb_screenshot_login.jpg?raw=true "login screen")

Scripts command line interface
![Alt text](/screenshots/q5os_seb_screenshot_scripts.jpg?raw=true "dark theme")
![Alt text](/screenshots/q5os_seb_screenshot_scripts_2.jpg?raw=true "dark theme")





  
