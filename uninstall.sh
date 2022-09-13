#!/usr/bin/bash

if [[ $EUID -ne 0 ]]; then

    echo "run script with superuser priveledge"
    exit
fi 

#check for error function
check(){
    if [[ $? -eq 0 ]]; then

        continue &> /dev/null

    else

        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mSCript has failed due to some unknwn error\e[0m"
        exit
    fi
}

#uninstall function

uninstall(){

    check

    echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mStopping waydroid session\e[0m"
    waydroid session stop
    check
    sudo waydroid container stop
    check

    echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mDetecting your distro\e[0m"

    #check if distro is fedora
    fedora=$(source /etc/os-release && echo $ID)
    version=$(source /etc/os-release && echo $VERSION_ID)

    #check if distro is arch based
    arch=$(source /etc/os-release && echo $ID)
    kernel=$(uname -r | cut -c -6)

    if [[ "$fedora" == "fedora" ]]; then

        #remove waydroid if distro is fedora based
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mYour distro is fedora\e[0m"
        sleep 0.5
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mUninstalling waydroid\e[0m"

        sudo dnf remove waydroid
        check

    elif [[ "$arch" == "arch" ]]; then

        #remove waydroid if it pacman
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mYour distro is arch\e[0m"
        sleep 0.5
        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mUninstalling waydroid\e[0m"

        pacman -R waydroid
        check
        pacman -R $(pacman -Qdtq)
        check

    else

        echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mYou're running a debian distro\e[0m"

        apt remove waydroid
        check

    fi

    #remove additional files

    echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mRemoving additional waydroid files\e[0m"

    rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid
    check

    sleep 1

    echo -e "\e[32m[\e[35m+\e[32m] \e[1;36mUninstall successfully\e[0m"

}

#confirm if user wants to uninstall
 
read -p $'\e[32m[\e[35m*\e[32m] \e[1;32mDo you want uninstall waydroid(y/n[yes/no] - default:- n): \e[0m' del


if [[ $del == "n" || $del == "N" ]]; then

    echo " " 
    echo "Exiting uninstaller"
    sleep 1
    exit

elif [[ $del == "y" || $del == "Y" ]]; then

    echo " "
    uninstall

elif [[ $del == "" ]]; then

    echo " " 
    echo "Exiting uninstaller"
    sleep 1
    exit

else

    bash uninstall.sh

fi
