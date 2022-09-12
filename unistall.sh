#!/usr/bin/bash

if [[ $EUID -ne 0 ]]; then

    echo "run script with superuser priveledge"

fi 

#check for error function
check(){
    if [[ $? -eq 0 ]]; then

        continue &> /dev/null

    else

        echo "Script has failed due to some unknown error"
        exit
    fi
}

echo " stopping waydroid session"
waydroid session stop
check
sudo waydroid container stop
check

echo "Detecting your distro"

#check if distro is fedora
fedora=$(source /etc/os-release && echo $ID)
version=$(source /etc/os-release && echo $VERSION_ID)

#check if distro is arch based
arch=$(source /etc/os-release && echo $ID)
kernel=$(uname -r | cut -c -6)

if [[ "$fedora" == "fedora" ]]; then

    #remove waydroid if distro is fedora based
    echo "Your distro is fedora"
    sleep 0.5
    echo "Uninstalling waydroid"

    sudo dnf uninstall waydroid
    check

elif [[ "$arch" == "arch" ]]; then

    #remove waydroid if it pacman
    echo "Your distro is arch"
    sleep 0.5
    echo "Uninstalling Waydroid"

    pacman -R waydroid
    check
    pacman -R $(pacman -Qdtq)
    check

else

    echo "Your running a debian dstro"

    apt remove waydroid
    check

fi

#remove additional files

echo "removing additional waydroid files"

rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
check

sleep 1

echo "uninstall successfully"