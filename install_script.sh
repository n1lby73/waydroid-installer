#!/usr/bin/bash

#check for error function
check(){
    if [[ $? -eq 0 ]]; then

        continue &> /dev/null

    else

        echo "Script has failed due to some unknown error"
        exit
    fi
}

# aurora function
aurora(){

    read -p $'\e[32m[\e[35m*\e[32m] \e[1;32mDo you want aurora store installed (y/n[yes/no] - default:- y):\e[0m' aurora

    if [[ $aurora == "y" || $aurora == "Y" ]]; then
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up aurora store\e[0m"
        wget https://tinyurl.com/aurora-store -O aurora.apk
        check

        # waydroid session start
        # check

        waydroid app install aurora.apk
        check
    
    elif [[ $aurora == "n" || $aurora == "N" ]]; then
        continue &> /dev/null
    
    elif [[ $aurora == "" ]]; then 
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up aurora store\e[0m"
        wget https://tinyurl.com/aurora-store -O aurora.apk
        check

        # waydroid session start
        # check

        waydroid app install aurora.apk
        check

    else
        echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!....."
        sleep 1
        aurora
    fi

    check

}

#weston function
weston(){
    wayland=$(echo $XDG_SESSION_TYPE)
    DE=$(echo $XDG_CURRENT_DESKTOP)
    if [[ "$wayland" != "wayland" && "$DE" != *"GNOME" ]]; then
        sudo cp weston.service ~/.config/systemd/user &> /dev/null

        if [[ $? -ne 0 ]];then
            sudo mkdir ~/.config/systemd &> /dev/null
            sudo mkdir ~/.config/systemd/user &> /dev/null
            sudo cp weston.service ~/.config/systemd/user
        fi

        sudo mkdir /usr/share/wd-launcher
        sudo cp waydroid.png /usr/share/wd-launcher/waydroid.png
        sudo cp wd-launcher.service ~/.config/systemd/user
        sudo cp 'waydroid launcher.desktop' /usr/share/applications

        echo  -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstallation finished\nLaunching waydroid...\e[0m"
        echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning\e[0m: always launch waydroid with \e[1;41mwaydroid launcher desktop icon\e[0m or using \e[1;41msystemctl --user start wd-launcher.service\e[0m from terminal"
        systemctl --user start wd-launcher.service
        sleep 10
        exit

    elif [[ "$wayland" != "wayland" && "$DE" == *"GNOME" ]]; then
        echo  -e "\e[32m[\e[35m+\e[32m] \e[1;36mYour current DE is gnome\e[0m"
        echo  -e "\e[32m[\e[35m+\e[32m] \e[1;36mYou can switch to  wayland from the login screen after reboot\e[0m"
        read -p $'\e[32m[\e[35m*\e[32m] \e[1;32mDo you wish to continue installing weston service(y/n[yes/no] - default:- n): \e[0m' weston

        if [[ $weston == "y" || $weston == "Y" ]]; then
            sudo cp weston.service ~/.config/systemd/user &> /dev/null

            if [[ $? -ne 0 ]];then
                sudo mkdir ~/.config/systemd &> /dev/null
                sudo mkdir ~/.config/systemd/user &> /dev/null
                sudo cp weston.service ~/.config/systemd/user
            fi

            sudo mkdir /usr/share/wd-launcher
            sudo cp waydroid.png /usr/share/wd-launcher/waydroid.png
            sudo cp wd-launcher.service ~/.config/systemd/user
            sudo cp 'waydroid launcher.desktop' /usr/share/applications

            echo  -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstallation finished\nLaunching waydroid...\e[0m"
            echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning\e[0m: always launch waydroid with \e[1;41mwaydroid launcher desktop icon\e[0m or using \e[1;41msystemctl --user start wd-launcher.service\e[0m from terminal"
            systemctl --user start wd-launcher.service
            sleep 10
            exit
        
        elif [[ $weston == "n" || $weston == "N" ]]; then

            continue &. /dev/null
        
        elif [[ $weston == "" ]]; then

            continue &> /dev/null
        
        else 

            echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!....."
            sleep 1
            weston
        fi

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

#function for offline installer
    #function to check for directory and files
offline(){
    read -p $'\e[32m[\e[35m*\e[32m] \e[1;36mEnter path to build directory: \e[0m' dir
    if [[ -d $dir ]]; then
        #check if system.img and vendor.img files are in directory
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mchecking for the following files:\e[0m\n1. system.img\n2. vendor.img"
        if [[ -f $dir/system.img && -f $dir/vendor.img ]]; then
            echo " "
            echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
            #create a tempoary directory
            count to know how many files are there 
            count=$(ls -A $dir | wc -l)
            if [[ $count -eq 2 ]]; then 
                sudo waydroid init -i $dir
            else
                sudo mkdir temp 
                cp $dir/system.img temp
                cp $dir/vendor.img temp
                sudo waydroid init -i temp
                sudo rm -rf temp
                sudo systemctl start waydroid-container
            fi
        else
            echo " "
            echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mError:- \e[1;32mOne or both files not found, input correct path to directory\e[0m"
            sleep 2
            offline
        fi
    else
        echo " "
        echo -e "\e[32m[\e[35m-\e[32m] \e[1;32mDirectory not found, input correct path to directory\e[0m"
        sleep 2
        offline
    fi
}

#Function for fedora gapps prompt
gapps_fedora(){
     read -p $'\e[32m[\e[35m*\e[32m] \e[1;32mDo you want gapps installed (y/n - default:- n): \e[0m' gapps
    
    if [[ $gapps == "n" || $gapps == "N" ]]; then
        
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
        sudo waydroid init -c https://ota.waydro.id/system  -v https://ota.waydro.id/vendor && sudo systemctl enable --now waydroid-container
        
        check

        #install aurora store
        aurora
        check
        sleep 1



    elif [[ $gapps == "y" || $gapps == "Y" ]]; then
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
        sudo waydroid init -c https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_x86_64/lineage-17.1-20220723-GAPPS-waydroid_x86_64-system.zip/download -v https://ota.waydro.id/vendor && sudo systemctl enable --now waydroid-container
   
    elif [[ $gapps == "" ]]; then

        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid with default value\e[0m"
        sudo waydroid init -c https://ota.waydro.id/system  -v https://ota.waydro.id/vendor && sudo systemctl enable --now waydroid-container
        
        check

        #install aurora  store
        aurora
        check

    else
        echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!....."
        sleep 1
        gapps_fedora
    
    fi
     
}

#Function for debian gapps prompt
gapps_debian(){
    read -p $'\e[32m[\e[35m*\e[32m] \e[1;32mDo you want gapps installed (y/n/o[yes/no/offline] - default:- n): \e[0m' gapps

        if [[ $gapps == "n" || $gapps == "N" ]]; then
            echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
            sudo apt-get install waydroid -y
            sudo waydroid init
            sudo systemctl start waydroid-container

        elif [[ $gapps == "y" || $gapps == "Y" ]]; then
            echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
            sudo apt-get install waydroid -y
            sudo waydroid init -s GAPPS
            sudo systemctl start waydroid-container

        elif [[ $gapps == "o" || $gapps == "O" ]]; then
            offline
        
        elif [[ $gapps == "" ]]; then 
            echo -e "\e[1;32mUsing default value\e[0m"
            sudo apt-get install waydroid -y
            sudo waydroid init
            sudo systemctl start waydroid-container
        
        
        else
            echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!, restarting now....."
            sleep 1
            gapps_debian

        fi
}

#Function for arch gapps prompt
gapps_arch(){
    read -p $'\e[32m[\e[35m+\e[32m] \e[1;32mDo you want gapps installed (y/n/o[yes/no/offline] - default:- n):\e[0m' gapps

        if [[ $gapps == "n" || $gapps == "N" ]]; then
            echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
            sudo yay -S waydroid && waydroid init

        elif [[ $gapps == "y" || $gapps == "Y" ]]; then
            echo -e "\e[32m[\e[35m+\e[32m] \e[1;36msetting up waydroid\e[0m"
            sudo yay -S waydroid && waydroid init -s GAPPS

        elif [[ $gapps == "" ]]; then
            echo -e"\e[1;32mInstalling default\e[0m"
            sudo yay -S waydroid && waydroid init

        elif [[ $gapps == "o" || $gapps == "O" ]]; then
            offline    
        
        else
            echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!, restarting now....."
            sleep 1
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

    read -p $'\e[32m[\e[35m+\e[32m] which distro are you running: ' os
    printf "${STOP}"

    if [[ $os == 1 || $os == 01 ]];then

        # check distro
        echo " "
        supported_distros=" focal bullseye hirsute jammy ubuntu-devel bookworm bullseye sid "
        fallback_distro="focal"
        distro=$(lsb_release -sc)

        if [[ "$supported_distros" != *" $distro "* ]]; then
	        echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mWarning\e[0m-: unsupported distribution: "$distro
	        echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mWarning\e[0m-: using fallback distribution: "$fallback_distro
	        distro=$fallback_distro
        fi
    

        #prerequisite
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstalling dependencies....\e[0m"

        sudo apt-get update && sudo apt-get upgrade && sudo apt-get install curl python3 python3-gbinder python-pip lxc ca-certificates -y
        if [[ $? -ne 0 ]]; then
        echo " "
        echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning:-\e[0m Dependencies not satisfied\nkindly run '\e[1;41msudo apt-get install curl python3 python3-gbinder python-pip lxc ca-certificates -y && sudo apt-get update && bash requirements.sh\e[0m' manually"
        exit 1
        fi

        echo " "

        #add keyring and waydroid repo
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstalling repo.....\e[0m"

        sudo wget https://repo.waydro.id/waydroid.gpg -O /usr/share/keyrings/waydroid.gpg

        check 
        
        sudo sh -c "echo 'deb [signed-by=/usr/share/keyrings/waydroid.gpg] https://repo.waydro.id/ $distro main' > /etc/apt/sources.list.d/waydroid.list"
        
        check 
        
        sudo apt-get -q update

        check

        #install waydroid
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstalling waydroid....\e[0m"
        sleep 0.5

        #check which image to install
        gapps_debian
        
        check
        
        #check vm
        check_vm
        
        check 

        #check and start weston
        weston 

        check 

        echo ""
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstallation finished\nLaunching waydroid....\e[0m"
                
        wayland_warning=$(echo $XDG_SESSION_TYPE)
        if [[ "$wayland_warning" != "wayland" ]]; then
            echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning:-\e[0mSwitch to wayland display server before launching waydroid"
        else
            waydroid show-full-ui
            exit
        fi

    elif [[ $os == 2 || $os == 02 ]]; then
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstalling dependencies....\e[0m"
        #going to make use of yay
        #pacman -Syy wget && wget https://aur.archlinux.org/cgit/aur.git/snapshot/waydroid.tar.gz && tar -xf waydroid.tar.gz -C 
        sudo pacman -Syu --needed base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
        
        check 

        rm -rf yay-bin

        check 

        echo " "
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstalling waydroid\e[0m"
        sleep 0.5
        
        #check which image to install
        gapps_arch

        check

        #check vm
        check_vm
        
        check

        #check and start weston
        weston 


        systemctl start waydroid-container 

        exit

    elif [[ $os == 3 || $os == 03 ]];then 
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mAdding copr repository\e[0m"
        sudo yum update -y

        check

        sudo dnf copr enable aleasto/waydroid -y

        #check for error
        check

        #check fedora version
        version=$(source /etc/os-release && echo $VERSION_ID)
        if [[ "$version" -ne 35 ]]; then
            continue &> /dev/null
        else
            sudo dnf update -y
        fi

        #check for error
        check 

        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstalling waydroid\e[0m"
        sudo dnf install waydroid -y

        #check for error
        check 

        # echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mSetting up waydroid\e[0m"
        sleep 0.5
        
        #choose which image to install
        gapps_fedora

        #check for error
        check

        #check vm
        check_vm
        
        #check and start weston
        weston 
        echo ""
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mInstallation finished\nLaunching waydroid....\e[0m"
        sudo waydroid init
        waydroid show-full-ui
        exit
    else
        echo -e "\e[1;36m[!] invalid option !!!, restarting in 5 seconds....."
        sleep 5
        menu
    fi
}
menu
