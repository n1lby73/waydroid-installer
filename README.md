![waydroid](https://user-images.githubusercontent.com/65239245/163730035-ca89be56-e56f-4827-a736-0d87d879301e.png)


# Waydroid-installer (wd-installer)

Automate installation process of waydroid on almost any linux distro


It automates the process of installing waydroid - A container base approach to boot a full android system on a regular GNU/LINUX system

# NOTE:
- This installer supports waydroid android version 10

- Always pay attention to major warning signs indicated by the script else waydroid may fail to boot or not operate properly

- Install firefox on waydroid if you are running fedora 

- During first launch including after a reboot, it may take up to 2-3 minutes before anything would be visible on your screen 

### Features:
- Installs waydroid on distro with no support for wayland
- Ability to install waydroid on any linux pc
- Choose if you need GAPPS or not
- Makes waydroid launch easier on weston enabled pc with the help of a desktop icon
- Downgrade and upgrade kernels and distro version where neccessary

<!-- ### Compatibility
To check if waydroid is compatible with your device, kindly run:
```

```
If the above command outputs
```

```
Then neither waydroid nor this installer is compatible with your device -->

## Desktop environment:
 During development wd-installer was tested on the following desktop enviroment:

CINNAMON
![cinnamon](https://user-images.githubusercontent.com/65239245/163730741-942e1e89-d6cf-4c78-95dc-d03346824127.png)


GNOME
![gnome](https://user-images.githubusercontent.com/65239245/163759181-b291bdc9-1f02-498a-ab98-ac2d34c6dfad.png)



### Usage:
![waydroid2](https://user-images.githubusercontent.com/65239245/163733897-b2ca876a-381b-41b5-a692-d757184fbd43.png)

```
  git clone https://github.com/n1lby73/waydroidd-installer
  cd waydroid-installer
  chmod +x *
  ./requirements.sh
```  
### Single line of command
``` 
git clone https://github.com/n1lby73/waydroid-installer && cd wd-installer && bash requirements.sh 
```
### Google playstore for gapps build
For google playstore and other service to function properly you need to retrieve your android build code using 
```
echo ANDROID_RUNTIME_ROOT=/apex/com.android.runtime sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";" | sudo waydroid shell
 ```
Afterward copy the output and paste [here](https://www.google.com/android/uncertified/) and restart waydroid using 
```
sudo systemctl restart waydroid-container
```

# Troubleshooting:
Things might not go as plan due to we forgetting to add one or two thing and thus you would be presented with an error message. Well this is a quick fix to known errors

### Stuck at boot screen on weston compositor
Run the below command if you are either
- Stucked at boot screen
- waited longer than 5-10 minutes and nothing shows on weston compositor
close weston compositor, open a terminal and paste this there:
```
sudo systemctl restart waydroid-container
```
### Python3-gbinder error
If you see a message saying python3-gbinder not installed or as an unmet dependency on any debian distro then do this:
```
curl -s https://gist.githubusercontent.com/cniw/98e204d7dbc73a3fa1bf61629b2a2fc1/raw | bash
```

After that you are good to go
# Contributors
@Fuseteam

## To do:
Installer support for:
- [x] Debian distros
- [x] Arch distros
- [x] Fedora
- [x] Desktop launcher for weston session
- [ ] Solus
- [ ] Android 11
- [x] Offline support for installing waydroid if you have the images
- [x] Added aurora store support for vanilla install

### Uninstall

Sometimes things don't go as planned and you need to remove it all and start over. To do that, follow the steps below:

```
sudo bash uninstall.sh 
```
### support
- For Queries: 
  - [Telegram group](https://t.me/waydroid)
  - [Reddit community](https://www.reddit.com/r/waydroid/)
- [Contributions](https://github.com/n1lby73/waydroid-installer/pulls) , [issues](https://github.com/n1lby73/waydroid-installer/issues) , and [feature requests](https://github.com/n1lby73/waydroid-installer/discussions) are welcome!
- Give a ★ if you like this project!

### LICENSE
[GNU V3](LICENSE)
