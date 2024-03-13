#!/bin/bash
echo  "-- Installing zram..."
sudo apt install -y zram-tools
echo -e "ALGO=lz4\nPERCENT=50\nPRIORITY=100" | sudo tee -a /etc/default/zramswap
echo "vm.swappiness=180" | sudo tee -a /etc/sysctl.d/21-swappiness.conf
echo "vm.page-cluster = 0" | sudo tee -a /etc/sysctl.d/21-swappiness.conf
systemctl reload zramswap.service

echo "-- Installing swap file for hibernation"
echo
if (grep "GRUB_CMDLINE_LINUX_DEFAULT" "/etc/default/grub")|grep -q "resume_offset="; then
echo "**  resume function seems to be already activated, aborting."
else 
if grep -q "/swap" "/etc/fstab"; then
echo "**  /swap already exist, aborting."
else
phymem=$(LANG=C free|awk '/^Mem:/{print $2}')
square_root=$(echo "$phymem" | awk '{print sqrt($1)}')
sqint=$( printf "%.0f" $square_root )
sqintd=$(expr $sqint \* 5)
filesz=$(expr $phymem + $sqintd)
needed=$(expr $filesz + 1048576)
echo " > Total physical memory: $phymem"
echo " > File size needed: $filesz"
dskfree=$(df -k / | tail -1 | awk '{print $4}')
echo " > disk space available: $dskfree"
if [ "$dskfree" -lt "$needed" ]; then
  echo "** sorry not enough disk space free (we must keep at least 1Gb free on the disk :p)"
else
 echo
 echo "Proceed ?"
optionz=("Install swap file" "Skip swap file install")
select optz in "${optionz[@]}"
do
    case $optz in
        "Install swap file")
            echo "--- Installing swap file..."
            fileszm=$(expr $filesz / 1024)
            sudo fallocate -l "$fileszm"m /swap
            sudo mkswap /swap
            sudo chmod 600 /swap
            echo "/swap                                     none           swap    sw,pri=0 0 0" | sudo tee -a /etc/fstab
            sudo swapon /swap
            UU=$(findmnt / -o UUID -n)
            OFS=$(sudo filefrag -v /swap|awk 'NR==4{gsub(/\./,"");print $4;}')
            sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&UUID='$UU' resume_offset='$OFS' /' /etc/default/grub
            sudo \cp /etc/initramfs-tools/conf.d/resume "backups/resume_$(date +"%Y-%m-%d_%I-%M%p").bkp"
            echo "RESUME=UUID=$UU" | sudo tee -a /etc/initramfs-tools/conf.d/resume
            sudo update-grub
            sudo sed -i 's/echo/#ech~o/g' /boot/grub/grub.cfg
            sudo update-initramfs -k all -u
            echo "  ---- Activate hibernation & set to hibernate if sleep > 1h30..."
            if ! grep -q "HibernateDelaySec=" "/etc/systemd/sleep.conf"; then
            echo "HibernateDelaySec=5400" | sudo tee -a /etc/systemd/sleep.conf
            fi
            sudo sed -i '/HibernateDelaySec=/c\HibernateDelaySec=5400' /etc/systemd/sleep.conf
            sudo \cp /lib/systemd/system/systemd-suspend.service /etc/systemd/system/systemd-suspend.service
            sudo sed -i '/ExecStart=/c\ExecStart=/lib/systemd/systemd-sleep suspend-then-hibernate' /etc/systemd/system/systemd-suspend.service
            echo "  ----- Set lid close action to suspend then hibernate..."
            #lidswitch action
            sudo sed -i '/HandleLidSwitch=/c\HandleLidSwitch=suspend-then-hibernate' /etc/systemd/logind.conf
            break
            ;;
    esac
done
fi
fi
fi


