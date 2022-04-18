![waydroid](https://user-images.githubusercontent.com/65239245/163730035-ca89be56-e56f-4827-a736-0d87d879301e.png)


# Waydroid-installer (wd-installer)

Automate installation process of waydroid on almost any linux distro


It automates the process of installing waydroid - A container base approach to boot a full android system on a regular GNU/LINUX system

# NOTE:
- This installer supports waydroid android version 10

- Always pay attention to major warning signs indicated by the script else waydroid may fail to boot

- Gapps build for fedora tends to crash browser but firefox only has proven to bypass that

- During first launch including after a reboot, it may take up to 2-3 minutes before anything would be visible on your screen 
### Features:
- Installs waydroid on distro with no support for wayland
- Ability to install waydroid on any linux pc
- Choose if you need GAPPS or not


## Desktop environment:
 During development wd-installer was tested on the following desktop enviroment:

CINNAMON
![cinnamon](https://user-images.githubusercontent.com/65239245/163730741-942e1e89-d6cf-4c78-95dc-d03346824127.png)


GNOME
![gnome](https://user-images.githubusercontent.com/65239245/163759181-b291bdc9-1f02-498a-ab98-ac2d34c6dfad.png)



### Usage:
![waydroid2](https://user-images.githubusercontent.com/65239245/163733897-b2ca876a-381b-41b5-a692-d757184fbd43.png)

```
  git clone https://github.com/n1lby73/wd-installer
  cd wd-installer
  chmod +x *
  ./requirements.sh ##or 
  bash requirements.sh
```  
### Single line of command
``` 
git clone https://github.com/n1lby73/wd-installer && cd wd-installer && bash requirements.sh 
```
### Goggle playstore for gapps build
For google playstore and other service to function properly you need to retrieve your android build code using 
```
echo ANDROID_RUNTIME_ROOT=/apex/com.android.runtime sqlite3 /data/data/com.google.android.gsf/databases/gservices.db "select * from main where name = \"android_id\";" | sudo waydroid shell
 ```
Afterward copy the output and paste [here](https://www.google.com/android/uncertified/) and restart waydroid using 
```
sudo systemctl restart waydroid-container
```
# Contributors
@Fuseteam

## To do:
Installer support for:
- [x] Debian distros
- [ ] Arch distros
- [x] Fedora
- [ ] Solus
- [ ] Android 11
- [ ] Offline support for installing waydroid if you have the images


### support
- For Queries: [Telegram group](https://t.me/waydroid)
- Contributions, issues, and feature requests are welcome!
- Give a ★ if you like this project!
