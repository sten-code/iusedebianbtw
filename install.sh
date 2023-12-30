#!/bin/bash

function install_discord()
{
  sudo apt install -y curl
  curl -L "https://discord.com/api/download?platform=linux&format=deb" -o discord.deb
  sudo apt install ./discord.deb
  rm discord.deb
}

function install_zsh()
{
  sudo apt install -y wget zsh zsh-autosuggestions zsh-syntax-highlighting
  sh -c "$(wget https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/zsh.sh -O -)"
  rm ~/.zshrc
  wget https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/.zshrc -O ~/.zshrc
}

function install_firefox()
{
  sudo apt install -y curl tar
  curl -o firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
  tar xjf firefox.tar.bz2 -C /opt/
  ln -s /opt/firefox/firefox /usr/local/bin/firefox
  curl "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications
  rm firefox.tar.bz2 
}

function install_jetbrainsmononerdfont()
{
  sudo apt install -y wget unzip
  mkdir -p ~/.fonts
  wget "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -O ~/.fonts/JetBrainsMono.zip
  cd ~/.fonts
  unzip JetBrainsMono.zip -o
  cd -
}

function install_neovim()
{
  sudo apt install -y curl tar make gcc cmake gettext unzip
  version="0.9.4"
  wget "https://github.com/neovim/neovim/archive/refs/tags/v$version.tar.gz" -O neovim.tar.gz
  tar -xf neovim.tar.gz
  rm neovim.tar.gz
  cd neovim-$version
  sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
  cd -
  sudo rm -rf neovim-$version
}

function install_nvchad()
{
  sudo apt install -y git
  git clone "https://github.com/NvChad/NvChad" ~/.config/nvim --depth 1
}

function install_st()
{
  sudo apt install -y git make gcc build-essential libxft-dev libharfbuzz-dev libgd-dev
  git clone "https://github.com/sten-code/st" ~/.config/st
  cd ~/.config/st
  sudo make install
  cd -
}

function install_chadwm()
{
  sudo apt install -y git make gcc picom rofi feh acpi libimlib2-dev libxinerama-dev xinit psmisc maim xclip x11-xserver-utils
  git clone "https://github.com/sten-code/chadwm" --depth 1 ~/.config/chadwm
  cd ~/.config/chadwm/chadwm
  sudo make install
  cd -
  
  echo "startx ~/.config/chadwm/scripts/run.sh" >> ~/.profile
  
  mkdir -p ~/.wallpapers
  curl "https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/wallpaper.png" -o ~/.wallpapers/wallpaper.png
}

checkbox_options="Discord
Dolphin
+GitHub
+Pavu Control
+Pulse Audio
+zsh
+Firefox
+JetBrains Mono Nerd Font
+Neovim
+NvChad
+Suckless Terminal
+chadwm"

sudo apt install curl
curl https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/checkbox.sh -o checkbox.sh
source checkbox.sh --multiple --index --options="$checkbox_options"
rm checkbox.sh
clear

options="Discord
Dolphin
GitHub
Pavu Control
Pulse Audio
zsh
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
    "Dolphin")                  sudo apt install -y dolphin;;
    "GitHub")                   sudo apt install -y gh;;
    "Pavu Control")             sudo apt install -y pavucontrol;;
    "Pulse Audio")              sudo apt install -y pulseaudio;;
    "zsh")                      install_zsh;;
    "Firefox")                  install_firefox;;
    "JetBrains Mono Nerd Font") install_jetbrainsmononerdfont;;
    "Neovim")                   install_neovim;;
    "NvChad")                   install_nvchad;;
    "Suckless Terminal")        install_st;;
    "chadwm")                   install_chadwm;;
    *) echo "No installation found for ${item_array[$index]}";;
  esac
  echo "Installed ${item_array[$index]}"
done

