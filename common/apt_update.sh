#!/bin/bash
sudo apt update
dcop "$1" setLabel "apt upgrade..."
sudo dpkg --configure -a
if [ ! $2 = "perf" ]; then
sudo apt upgrade -y
else
sudo apt upgrade -y --fix-missing
sudo apt install -y --fix-broken
sudo apt -y autoremove
fi

