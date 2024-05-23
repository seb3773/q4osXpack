#!/bin/sh
echo "  \e[35m░▒▓█\033[0m add repository..."
wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list
