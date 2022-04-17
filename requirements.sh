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
#check if window system is wayland

wayland=$(echo $XDG_SESSION_TYPE)
if [[ "$wayland" != "wayland" ]]; then
    echo " "
	echo -e "\e[1;31mError\e[0m: unsupported display server: "$wayland
    echo  " "
    echo -e "\e[1;36mEnabling wayland session\e[0m"

    #check if desktop enviroment is gnome
    de
fi

#starting installation script
bash install_script.sh