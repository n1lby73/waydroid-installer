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
        echo -e "\e[32m[\e[35m!!\e[32m] \e[1;31mWarning:-\e[0mSwitch to wayland display server on the login screen after the installation process is finished"
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
	    echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mError\e[0m: unsupported display server: "$wayland
        echo  " "
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mEnabling wayland session\e[0m"

        #check if desktop enviroment is gnome
        de
fi
}

#update fedora function
fedora_update(){
    read -p $'\e[1;32mDo you want to update to fedora 35 (y/n - default:- y):\e[0m' update
    if [[ $update == "n" || $update == "N" ]]; then
        echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mError\e[om:- Waydroid installer has failed cause of unsupported fedora version\nUpdate to at least fedora 35 and re-run installer"
        exit
    elif [[ $update == "Y" || $update == "y" ]]; then
        echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning\e[0m:- it is recomended that your battery is above 50% before you continue"
        echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mPress enter to continue or ctrl+c to exit....\e[0m"
        read ts2
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDownloading packages\e[0m"
        sudo dnf --refresh upgrade -y && sudo dnf system-upgrade download --releasever=35 -y
        if [[ $? -ne 0 ]]; then
            echo " "
            echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning:-\e[0m Download not sucessfull\nkindly download packages manually using this \e[1;41msudo dnf --refresh upgrade -y && sudo dnf system-upgrade download --releasever=35 -y\e[0m"
            echo "or restart the installer.....exiting"
            exit 1
        fi        
        echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mRebooting in 5 secs\e[0m"
        sleep 5
        sudo dnf system-upgrade reboot

    elif [[ $update == "" ]]; then
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mUsing default value\e[0m"
        echo " "
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDownloading packages\e[0m"
        sudo dnf --refresh upgrade -y && sudo dnf system-upgrade download --releasever=35 -y
        if [[ $? -ne 0 ]]; then
            echo " "
            echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning:-\e[0m Download not sucessfull\nkindly download packages manually using this \e[1;41msudo dnf --refresh upgrade -y && sudo dnf system-upgrade download --releasever=35 -y\e[0m"
            echo "or restart the installer.....exiting"
            exit 1
        fi
        echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mRebooting in 5 secs\e[0m"
        sleep 5
        sudo dnf system-upgrade reboot

    else
        echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!, restarting now....."
        sleep 1
        fedora_update
    fi
}

#downgrade kernel function
kernel_downgrade(){
    read -p $'\e[32m[\e[35m*\e[32m] \e[1;32mDo you want to downgrade to kernel "5.16.13" (y/n/o[yes/no/offline] - default:- y):\e[0m' downgrade
    if [[ $downgrade == "n" || $downgrade == "N" ]]; then
        echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning\e[0m: you are about to '\e[1;41minstall waydroid\e[0m' on an '\e[1;41mexperimental kernel\e[0m'"
        echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mPress enter to continue or ctrl+c to exit....\e[0m"
        read ts2
        echo " "
        echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;36mExpect bugs !!!\e[0m"
        sleep 5
        continue &> /dev/null

    elif [[ $downgrade == "y" || $downgrade == "Y" ]]; then
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mChecking for dependencies\e[0m"
        sudo pacman -Syyu wget
        echo " "
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDownloading packages\e[0m"
        wget https://archive.archlinux.org/packages/l/linux-zen/linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst https://archive.archlinux.org/packages/l/linux-zen-headers/linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst

        echo " "
        if [[ $? -ne 0 ]]; then
            echo " "
            echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning:-\e[0m Download not sucessful\nkindly download packages manually using this link\n1. https://archive.archlinux.org/packages/l/linux-zen/linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst\n2. https://archive.archlinux.org/packages/l/linux-zen-headers/linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst"
            echo "or restart the installer"
            exit 1
        fi
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDowngrading your Arch kernel now...\e[0m"
        sudo pacman -U linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst
        echo " "
        echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mRebooting in 5 secs to apply changes\nRe-run installer after boot\e[0m"
        sleep 5
        reboot now
    elif [[ $downgrade == "" ]]; then
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mUsing default value\e[0m"
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mChecking for dependencies\e[0m"
        sudo pacman -Syyu wget
        echo " "
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDownloading packages\e[0m"
        wget https://archive.archlinux.org/packages/l/linux-zen/linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst https://archive.archlinux.org/packages/l/linux-zen-headers/linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst

        echo " "
        if [[ $? -ne 0 ]]; then
            echo " "
            echo -e "\e[32m[\e[35m!!!\e[32m] \e[1;31mMajor warning:-\e[0m Download not sucessful\nkindly download packages manually using this link\n1. https://archive.archlinux.org/packages/l/linux-zen/linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst\n2. https://archive.archlinux.org/packages/l/linux-zen-headers/linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst"
            echo "or restart the installer"
            exit 1
        fi
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDowngrading your Arch kernel now...\e[0m"
        sudo pacman -U linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst
        echo " "
        echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mRebooting in 5 secs to apply changes\nRe-run installer after boot\e[0m"
        sleep 5
        reboot now
    elif [[ $downgrade == "O" || $downgrade == "o" ]]; then
        #function to check for directory and files
        dir_checker(){
            read -p $'\e[32m[\e[35m*\e[32m] \e[1;36mEnter path to kernel directory: \e[0m' dir
            if [[ -d $dir ]]; then
                #check if linux-zen and linux-zen-headers files are in directory
                echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mchecking for the following files:\e[0m\n1. linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst\n2. linux-zen-headers/linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst" 
                sleep 2
                if [[ -f $dir/linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst && -f $dir/linux-zen-headers/linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst ]]; then
                    echo -e "\e[32m[\e[35m+\e[32m] \e[1;32mDowngrading your Arch kernel now...\e[0m"
                    sudo pacman -U linux-zen-5.16.13.zen1-1-x86_64.pkg.tar.zst linux-zen-headers-5.16.13.zen1-1-x86_64.pkg.tar.zst
                    echo -e "\e[32m[\e[35m*\e[32m] \e[1;32mRebooting in 5 secs to apply changes\nRe-run installer after boot\e[0m"
                    sleep 5
                    reboot now
                else
                    echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mError:- \e[1;32mOne or both files not found, input correct path to directory\e[0m"
                    echo " "
                    sleep 2
                    dir_checker
                fi
            else
                echo -e "\e[32m[\e[35m-\e[32m] \e[1;32mDirectory not found, input correct/full path to directory\e[0m"
                sleep 2
                dir_checker
            fi
        }
        dir_checker
            
    else
        echo -e "\e[32m[\e[35m-\e[32m] \e[1;36minvalid option !!!, restarting now....."
        sleep 1
        kernel_downgrade
    fi
}

#check if distro is fedora
fedora=$(source /etc/os-release && echo $ID)
version=$(source /etc/os-release && echo $VERSION_ID)
if [[ "$fedora" != "fedora" ]]; then
    continue &> /dev/null
else
    #check fedora version
    if [[ "$version" -lt 35 ]]; then
        echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mWarning:- your fedora version is not supported: \e[0m"$version
        fedora_update
    else
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mCleaning up old packages...\e[0m"
        sleep 5
        sudo dnf system-upgrade clean
        sudo dnf clean packages
        sudo yum install figlet -y
        continue &> /dev/null
    fi
fi

#check if distro is arch based
arch=$(source /etc/os-release && echo $ID)
kernel=$(uname -r | cut -c -6)
if [[ "$arch" != "arch" ]]; then
    continue &> /dev/null
else
    #check arch kernel installed
    if [[ "$kernel" > 5.16.3 ]]; then
        sudo pacman -Syyu figlet
        echo " "
        echo -e "\e[32m[\e[35m!\e[32m] \e[1;31mWarning:-\e[0m your kernel is not yet supported: "$kernel
        kernel_downgrade
    else
        continue &> /dev/null
    fi
fi


displayserver
#starting installation script
bash install_script.sh
