#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})
#-------------------------------------------------**
qv=$(get-q4os-version)
qvint=$(echo $qv | cut -d '.' -f 1)
if [ $qvint -eq 5 ]; then
versionname="Aquarius"
elif [ $qvint -eq 4 ]; then
versionname="Gemini"
elif [ $qvint -eq 3 ]; then
versionname="Centaurus"
else
versionname="Version inconnue"
fi
new_value="\"distro_markup\": \"<span font-size='xx-large'><span font-weight='bold'>Q4OS - </span>$versionname</span>\","
sed -i "s#\"distro_markup\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
description_line=$(lsb_release -a | grep "Description:")
distro=$(echo "$description_line" | awk -F ': *' '{print $2}')
distro=$(echo "$distro" | sed 's/^[ \t]*//')
new_value="\"distro_ver\": \"$distro\","
sed -i "s#\"distro_ver\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
product_name=$(sudo dmidecode -t system | grep "Product Name:")
p1=$(echo "$product_name" | awk -F ': *' '{print $2}')
p1=$(echo "$p1" | sed 's/^[[:space:]]*//')
version_info=$(sudo dmidecode -t system | grep "Version:")
p2=$(echo "$version_info" | awk -F ': *' '{print $2}')
p2=$(echo "$p2" | sed 's/^[[:space:]]*//')
hostn="$p1 $p2"
new_value="\"hostname\": \"$hostn\","
sed -i "s#\"hostname\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
cpu_info=$(sudo dmidecode -t processor | grep "Version:")
cpuv=$(echo "$cpu_info" | awk -F ': *' '{print $2}')
cpuv=$(echo "$cpuv" | sed 's/^[[:space:]]*//')
new_value="\"cpu\": \"         $cpuv\","
sed -i "s#\"cpu\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
mem_type=$(sudo dmidecode -t memory | grep "Type:" | grep -v -e "Unknown" -e "Error Correction" | head -n 1)
memtype=$(echo "$mem_type" | awk '{print $2}')
mem_info=$(sudo dmidecode --type 19 | grep "Range Size:")
memsize=$(echo "$mem_info" | awk -F ': *' '{print $2}')
mem_speed=$(sudo dmidecode -t memory | grep "Speed:" | grep "Configured Memory Speed:")
memspeed=$(echo "$mem_speed" | awk -F ': *' '{print $2}')
memspeed=$(echo "$memspeed" | sed 's/[^0-9]*//g')
ramline="$memsize @ $memspeed MHz $memtype"
new_value="\"memory\": \"              $ramline\","
sed -i "s#\"memory\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
boot_device=$(df /boot | grep -Eo '/dev/[^ ]+')
bootprt=$(echo "$boot_device" | awk -F'/dev/' '{print $2}')
new_value="\"startup_disk\": \"    $bootprt\","
sed -i "s#\"startup_disk\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
gpu_info=$(sudo lspci | grep -i --color 'vga\|3d\|2d' | grep -o 'VGA compatible controller:.*')
gpu=$(echo "$gpu_info" | awk -F 'VGA compatible controller:' '{print $2}')
gpu=$(echo "$gpu" | sed 's/^[[:space:]]*//')
new_value="\"graphics\": \"            $gpu\","
sed -i "s#\"graphics\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
seria=$(sudo dmidecode -s system-serial-number)
new_value="\"serial_num\": \"$seria\","
sed -i "s#\"serial_num\":.*#$new_value#" "$USER_HOME/.local/share/about-this-mac/overview-conf.json"
