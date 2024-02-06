#!/bin/bash

base_bg="/opt/trinity/share/apps/tdm/themes/windows/_base_bkg.jpg"

# Trouver tous les répertoires correspondants
user_directories=(/opt/trinity/share/apps/ksplash/Themes/Redmond10_*/)

# Parcourir chaque répertoire
for user_dir in "${user_directories[@]}"; do
    user_dir="${user_dir%/}"  # Supprimer le slash à la fin du nom du répertoire
    userpic="/opt/trinity/share/apps/ksplash/Themes/$(basename "$user_dir")/userpic.png"
    output_bg="/opt/trinity/share/apps/ksplash/Themes/$(basename "$user_dir")/Background.png"

    # Appliquer la commande convert pour chaque répertoire
    sudo convert "$base_bg" "$userpic" -geometry +$(convert "$base_bg" -ping -format "%[fx:(w-220)/2]" info:)+$(convert "$base_bg" -ping -format "%[fx:h*0.2]" info:) -composite "$output_bg"
done

