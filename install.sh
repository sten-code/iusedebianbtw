#!/bin/bash

function install_discord()
{
  # Download discord with redirects enabled (-L)
  curl -Lo discord.deb "https://discord.com/api/download?platform=linux&format=deb"
  sudo apt install -y ./discord.deb
  rm discord.deb
}

function install_steam()
{
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install -y libc6:i386 libgl1-mesa-dri:i386 libgl1:i386
  curl -o steam.deb "https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
  sudo apt install -y ./steam.deb
  rm steam.deb
}

function install_whatsapp()
{
  curl -o whatsapp.deb "https://github.com/eneshecan/whatsapp-for-linux/releases/download/v1.6.4/whatsapp-for-linux_1.6.4_amd64.deb"
  sudo apt install -y ./whatsapp.deb
  rm whatsapp.deb
}

function install_premake5() {
  mkdir premake5
  cd premake5
  curl -o premake5.tar.gz "https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz"
  tar -xf premake5.tar.gz
  sudo mv premake5 /bin/premake5
  cd -
  rm -rf premake5
}

function install_vscode()
{
  wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
  sudo apt install -y ./vscode.deb
  rm vscode.deb
}

function install_vmware()
{
  sudo apt install -y linux-headers-$(uname -r)
  curl -o vmware.bundle "https://download3.vmware.com/software/WKST-1750-LX/VMware-Workstation-Full-17.5.0-22583795.x86_64.bundle"
  chmod +x vmware.bundle
  sudo ./vmware.bundle
  rm vmware.bundle
  sudo vmware-modconfig --console --install-all
}

function install_ytop()
{
  sudo apt install -y cargo
  cargo install ytop
}

function install_zsh()
{
  sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/zsh.sh)"
  curl -o ~/.zshrc https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/.zshrc
  chsh -s $(which zsh)

  if grep -q "startx " /etc/zsh/zprofile; then
    echo "test -f ~/.config/chadwm/scripts/run.sh && startx ~/.config/chadwm/scripts/run.sh" | sudo tee -a /etc/zsh/zprofile
  fi
}

function install_firefox()
{
  curl -o firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
  tar xjf firefox.tar.bz2 -C /opt/
  ln -s /opt/firefox/firefox /usr/local/bin/firefox
  curl "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications
  rm firefox.tar.bz2 
}

function install_jetbrainsmononerdfont()
{
  mkdir -p ~/.fonts
  curl -o ~/.fonts/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  cd ~/.fonts
  unzip JetBrainsMono.zip -o
  cd -
}

function install_neovim()
{
  sudo apt install -y make gcc cmake gettext
  version="0.9.4"
  curl -o neovim.tar.gz "https://github.com/neovim/neovim/archive/refs/tags/v$version.tar.gz"
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
  git clone "https://github.com/NvChad/NvChad" ~/.config/nvim --depth 1
}

function install_st()
{
  sudo apt install -y make gcc build-essential libxft-dev libharfbuzz-dev libgd-dev
  git clone "https://github.com/sten-code/st" ~/.config/st
  cd ~/.config/st
  sudo make install
  cd -
}

function install_chadwm()
{
  sudo apt install -y make gcc picom rofi feh acpi libimlib2-dev libxinerama-dev xinit psmisc maim xclip x11-xserver-utils xbacklight
  git clone "https://github.com/sten-code/chadwm" --depth 1 ~/.config/chadwm
  cd ~/.config/chadwm/chadwm
  sudo make install
  cd -
  
  if grep -q "startx " ~/.profile; then
    echo "startx ~/.config/chadwm/scripts/run.sh" >> ~/.profile
  fi

  mkdir -p ~/.wallpapers
  curl "https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/wallpaper.png" -o ~/.wallpapers/wallpaper.png
}

checkbox_options="Discord
Dolphin
Steam
Whatsapp
premake5
vlc
ytop
wpagui
VMWare Workstation Pro
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

sudo apt install curl wget unzip tar git
curl https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/checkbox.sh -o checkbox.sh
source checkbox.sh --multiple --index --options="$checkbox_options"
rm checkbox.sh
clear

options="Discord
Dolphin
Steam
Whatsapp
premake5
vlc
ytop
wpagui
VMWare Workstation Pro
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
    "Nautilus")                 sudo apt install -y nautilus;;
    "Steam")                    install_steam;;
    "Whatsapp")                 install_whatsapp;;
    "premake5")                 install_premake5;;
    "vlc")                      sudo apt install -y vlc;;
    "ytop")                     install_ytop;;
    "wpagui")                   sudo apt install -y wpagui;;
    "vscode")                   install_vscode;;
    "VMWare Workstation Pro")   install_vmware;;
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

