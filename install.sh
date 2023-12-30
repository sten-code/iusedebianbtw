#!/bin/bash

function install_discord()
{
  apt install -y curl
  curl -L "https://discord.com/api/download?platform=linux&format=deb" -o discord.deb
  apt install ./discord.deb
  rm discord.deb
}

function install_firefox()
{
  apt install -y wget tar
  wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
  tar xjf firefox.tar.bz2 -C /opt/
  ln -s /opt/firefox/firefox /usr/local/bin/firefox
  wget "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications
  rm firefox.tar.bz2 
}

function install_jetbrainsmononerdfont()
{
  apt install -y wget unzip
  mkdir ~/.fonts
  wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -o ~/.fonts/JetBrainsMono.zip
  unzip ~/.fonts/JetBrainsMono.zip
}

function install_neovim()
{
  apt install -y wget tar make gcc cmake gettext unzip
  version="0.9.4"
  wget "https://github.com/neovim/neovim/archive/refs/tags/v$version.tar.gz" -o neovim.tar.gz
  tar -xf neovim.tar.gz
  cd neovim-$version
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  make install
  cd -
  rm -rf neovim-$version
}

function install_nvchad()
{
  apt install -y git
  git clone "https://github.com/NvChad/NvChad" ~/.config/nvim --depth 1
}

function install_st()
{
  apt install -y git make gcc build-essential libxft-dev libharfbuzz-dev libgd-dev
  git clone "https://github.com/sten-code/st" ~/.config/st
  cd ~/.config/st
  make install
  cd -
}

function install_chadwm()
{
  apt install -y git make gcc picom rofi feh acpi libimlib2-dev libxinerama-dev
  git clone "https://github.com/sten-code/chadwm" --depth 1 ~/.config/chadwm
  cd ~/.config/chadwm/chadwm
  make install
  cd -
  
  echo "startx ~/.config/chadwm/scripts/run.sh" >> ~/.profile
  
  mkdir ~/.wallpapers
  wget "https://raw.githubusercontent.com/sten-code/iusedebianbtw/master/wallpaper.png" -o ~/.wallpapers/wallpaper.png
}

checkbox_options="Discord
Dolphin
+GitHub
+Pavu Control
+Pulse Audio
+Firefox
+JetBrains Mono Nerd Font
+Neovim
+NvChad
+Suckless Terminal
+chadwm"

apt install curl
curl https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/checkbox.sh -o checkbox.sh
source checkbox.sh --multiple --index --options="$checkbox_options"
rm checkbox.sh
clear

options="Discord
Dolphin
GitHub
Pavu Control
Pulse Audio
Firefox
JetBrains Mono Nerd Font
Neovim
NvChad
Suckless Terminal
chadwm"

IFS=$' ' read -ra index_array <<< $(echo "$checkbox_output")
mapfile -t item_array <<< "$options"

for index in "${index_array[@]}"; do
  echo "Installing ${item_array[$index]}"
  case "${item_array[$index]}" in
    "Discord")                  install_discord;;
    "Dolphin")                  apt install -y dolphin;;
    "GitHub")                   apt install -y gh;;
    "Pavu Control")             apt install -y pavucontrol;;
    "Pulse Audio")              apt install -y pulseaudio;;
    "Firefox")                  install_firefox;;
    "JetBrains Mono Nerd Font") install_jetbrainsmononerdfont;;
    "Neovim")                   install_neovim;;
    "NvChad")                   install_nvchad;;
    "Suckless Terminal")        install_st;;
    "chadwm")                   install_chadwm;;
    *) echo "No installation found for ${item_array[$index]}";;
  esac
done

