#!/usr/bin/bash

#weston function
weston(){
    wayland=$(echo $XDG_SESSION_TYPE)
    DE=$(echo $XDG_CURRENT_DESKTOP)
    if [[ "$wayland" != "wayland" && "$DE" != *"GNOME" ]]; then
    sudo cp weston.service ~/.config/systemd/user
    if [[ $? -ne 0 ]];then
        sudo mkdir ~/.config/systemd &> /dev/null
        sudo mkdir ~/.config/systemd/user &> /dev/null
        sudo cp weston.service ~/.config/systemd/user
    fi
    echo  -e "\e[1;36mInstallation finished\nLaunching waydroid...\e[0m"
    echo -e "\e[1;31mMajor warning\e[0m: always run '\e[1;41msystemctl --user start weston\e[0m' before starting waydroid"
    systemctl --user start weston
    sudo systemctl restart waydroid-container.service
    waydroid show-full-ui
    exit
    else
        continue &> /dev/null
    fi
}

#banner function
banner(){
    banner=$(cat /etc/issue)
    WHITE="\e[97m"
    STOP="\e[0m"
    CYAN="\e[1;46m"
    if [[ "$banner" == "Arch Linux \r (\l)" ]]; then
        pacman -Qi figlet > /dev/null
        if [[ $? -eq 0 ]]; then
            continue &> /dev/null
        else
            pacman -S figlet > /dev/null

        fi

        printf "${WHITE}"
        clear
        printf "${CYAN}"
        figlet -f /usr/share/figlet/fonts/smslant.flf WD-INSTALLER
        printf "${STOP}"
    else

        sudo apt-get install figlet -y > /dev/null

        printf "${WHITE}"
        clear
        printf "${CYAN}"
        figlet -f /usr/share/figlet/smslant.flf WD-INSTALLER
        printf "${STOP}"

    fi

    echo -e "\e[1;36m   	.:.:. \e[0m\e[1;35m creator || n1lby73 \e[1;36m.:.:."
    echo " "
    echo -e ".:.\e[1;35m telegram: n1lby73 | github: github.com/n1lby73 \e[1;36m.:."
    echo -e "    .:.\e[1;35minstagram: n1lby73 | twitter: n1l_by73\e[1;36m.:."
}

#Function to check detect vm
check_vm(){
    vm=$(hostnamectl | grep "Virtualization")
    if [[ -n "$vm" ]]; then
        echo "Modifying base prop to run inside virtual machine" 
        sed -i "s/ro.hardware.gralloc=gbm/#ro.hardware.gralloc=gbm\nro.hardware.gralloc=default/" /var/lib/waydroid/waydroid_base.prop && \
	    sed -i "s/ro.hardware.egl=mesa/#ro.hardware.egl=mesa\nro.hardware.egl=swiftshader/" /var/lib/waydroid/waydroid_base.prop && \
        sudo systemctl restart waydroid-container
    fi
}

#Function for fedora gapps prompt
gapps_fedora(){
     read -p $'\e[1;32mDo you want gapps installed (y/n - default:- n):\e[0m' gapps
    
    if [[ $gapps == "n" || $gapps == "N" ]]; then
        echo -e "\e[1;36msetting up waydroid\e[0m"
        sudo waydroid init -c https://raw.githubusercontent.com/aleasto/waydroid-ota/main/system -v https://raw.githubusercontent.com/aleasto/waydroid-ota/main/vendor && sudo systemctl enable --now waydroid-container
    
    elif [[ $gapps == "y" || $gapps == "Y" ]]; then
        echo -e "\e[1;36msetting up waydroid\e[0m"
        sudo waydroid init -c https://waydroid.bardia.tech/OTA/system -v https://waydroid.bardia.tech/OTA/vendor && sudo systemctl enable --now waydroid-container
    
    elif [[ $gapps == "" ]]; then
        echo -e "\e[1;36msetting up waydroid with default value\e[0m"
        sudo waydroid init -c https://raw.githubusercontent.com/aleasto/waydroid-ota/main/system -v https://raw.githubusercontent.com/aleasto/waydroid-ota/main/vendor && sudo systemctl enable --now waydroid-container
    
    else
        gapps_fedora
    
    fi
     
}

#Function for debian gapps prompt
gapps_debian(){
    read -p $'\e[1;32mDo you want gapps installed (y/n - default:- n):\e[0m' gapps

        if [[ $gapps == "n" || $gapps == "N" ]]; then
            sudo apt-get install waydroid -y
            sudo waydroid init
            sudo systemctl start waydroid-container

        elif [[ $gapps == "y" || $gapps == "Y" ]]; then
            sudo apt-get install waydroid -y
            sudo waydroid init -s GAPPS
            sudo systemctl start waydroid-container

        elif [[ $gapps == "" ]]; then 
            echo -e "\e[1;32mUsing default value\e[0m"
            sudo apt-get install waydroid -y
            sudo waydroid init
            sudo systemctl start waydroid-container
        
        else
            gapps_debian

        fi
}

#Function for arch gapps prompt
gapps_arch(){
    read -p $"\e[1;32mDo you want gapps installed (y/n - default:- n):\e[0m" gapps

        if [[ $gapps == "n" || $gapps == "N" ]]; then
            sudo yay -S waydroid && waydroid init

        elif [[ $gapps == "y" || $gapps == "Y" ]]; then
            sudo yay -S waydroid && waydroid init -s GAPPS

        elif [[ $gapps == "" ]]; then
            echo -e"\e[1;32mInstalling default\e[0m"
            sudo yay -S waydroid && waydroid init
        
        else
            gapps_arch

        fi
}

#menu function
menu(){
    banner
    YELLOW="\e[1;33m"
    STOP="\e[0m"
    printf "${YELLOW}"
    echo " "
    echo "[01] Debian"
    echo " "
    echo "[02] Arch"
    echo " "
    echo "[03] Fedora"
    echo " "

    read -p $"which distro are you running: " os
    printf "${STOP}"

    if [[ $os == 1 || $os == 1 ]];then

        # check distro
        echo " "
        supported_distros=" focal bullseye hirsute "
        fallback_distro="focal"
        distro=$(lsb_release -sc)

        if [[ "$supported_distros" != *" $distro "* ]]; then
	        echo -e "\e[1;31mWarning\e[0m-: unsupported distribution: "$distro
	        echo -e "\e[1;31mWarning\e[0m-: using fallback distribution: "$fallback_distro
	        distro=$fallback_distro
        fi
    

        #prerequisite
        echo -e "\e[1;36mInstalling dependencies....\e[0m"

        sudo apt-get update && sudo apt-get upgrade && sudo apt-get install curl python3 lxc ca-certificates -y

        echo " "

        #add keyring and waydroid repo
        echo -e "\e[1;36mInstalling repo.....\e[0m"

        sudo wget https://repo.waydro.id/waydroid.gpg -O /usr/share/keyrings/waydroid.gpg
        sudo sh -c "echo 'deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ $distro main' > /etc/apt/sources.list.d/waydroid.list"
        sudo apt-get -q update

        #install waydroid
        echo -e "\e[1;36mInstalling waydroid....\e[0m"
        sleep 0.5

        #check which image to install
        gapps_debian

        #check vm
        check_vm

        #check and start weston
        weston 
        echo ""
        echo -e "\e[1;36mInstallation finished\nLaunching waydroid....\e[0m"
        
        wayland_warning=$(echo $XDG_SESSION_TYPE)
        if [[ "$wayland_warning" != "wayland" ]]; then
            echo -e "\e[1;31mMajor warning:-\e[0mSwitch to wayland display server before launching waydroid"
        else
            waydroid show-full-ui
        fi

    elif [[ $os == 2 || $os == 02 ]]; then
        echo -e "\e[1;36mInstalling dependencies....\e[0m"
        #going to make use of yay
        #pacman -Syy wget && wget https://aur.archlinux.org/cgit/aur.git/snapshot/waydroid.tar.gz && tar -xf waydroid.tar.gz -C 
        sudo pacman -Syu --needed base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
        echo " "
        echo -e "\e[1;36mInstalling waydroid\e[0m"
        sleep 0.5
        
        #check which image to install
        gapps_arch

        #check vm
        check_vm

        systemctl start waydroid-container 

    elif [[ $os == 3 || $os == 03 ]];then 
        echo -e "\e[1;36mAdding copr repository\e[0m"
        sudo yum update -y
        sudo dnf copr enable aleasto/waydroid -y

        #check fedora version
        version=$(source /etc/os-release && echo $VERSION_ID)
        if [[ "$version" -ne 35 ]]; then
            continue &> /dev/null
        else
            sudo dnf update -y
        fi

        echo -e "\e[1;36mInstalling waydroid\e[0m"
        sudo dnf install waydroid -y

        
        echo -e "\e[1;36mSetting up waydroid\e[0m"
        sleep 0.5
        
        #choose which image to install
        gapps_fedora

        #check vm
        check_vm
        
        #check and start weston
        weston 
        echo ""
        echo -e "\e[1;36mInstallation finished\nLaunching waydroid....\e[0m"
        waydroid show-full-ui
        
    else
        menu
    fi
}
menu
