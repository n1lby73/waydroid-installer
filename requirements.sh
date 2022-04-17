#!/usr/bin/bash

#function for desktop environment
de(){
    echo " "
    DE=$(echo $XDG_CURRENT_DESKTOP)
    if [[ "$DE" == *"GNOME" || "$DE" == "ubuntu:GNOME" ]]; then

        sudo sed -i 's/WaylandEnable=false/#WaylandEnable=fale/g' /etc/gdm3/custom.conf 

        if [[ $? -eq 0 ]]; then
            continue &> /dev/null
        else
            sudo sed -i 's/WaylandEnable=false/#WaylandEnable=fale/g' /etc/gdm/custom.conf
        fi

	    echo  " "
        echo -e "\e[1;31mWarning:-\e[0mSwitch to wayland display server on the login screen after the installation process is finished"
        sleep 5
    else
        #install weston
        sudo apt-get install weston -y > /dev/null
	fi
}

#function to check if window system is wayland

displayserver(){
    wayland=$(echo $XDG_SESSION_TYPE)
    if [[ "$wayland" != "wayland" ]]; then
        echo " "
	    echo -e "\e[1;31mError\e[0m: unsupported display server: "$wayland
        echo  " "
        echo -e "\e[1;36mEnabling wayland session\e[0m"

        #check if desktop enviroment is gnome
        de
fi
}

#update fedora function
update(){
    read -p $"\e[1;32mDo you want to update to fedora 35 (y/n - default:- y):\e[0m" update
    if [[ $update == "n" || $update == "N" ]]; then
        echo "Error:- Waydroid installer has failed cause of unsupported fedora version\nUpdate to at least fedora 35 and re-run installer"
        exit
    elif [[ $update == "Y" || $update == "y" ]]; then
        sudo dnf system-upgrade --releasever=35
    elif [[ $update == "" ]]; then
        echo "using default value"
        sudo dnf system-upgrade --releasever=35
    else
        update
    fi
}

#check if distro is fedora
fedora=$(source /etc/os-release && echo $ID)
version=$(source /etc/os-release && echo $VERSION_ID)
if [[ "$fedora" != "fedora" ]]; then
    continue &> /dev/null
else
    if [[ "$version" -lt 35 ]]; then
        echo "Your fedora version is not supported"
        update
    else
        continue &> /dev/null
    fi
fi
displayserver
#starting installation script
bash install_script.sh
