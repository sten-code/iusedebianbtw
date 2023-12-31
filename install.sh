#!/bin/bash

install_discord()
{
  # Download discord with redirects enabled
  curl -Lo discord.deb "https://discord.com/api/download?platform=linux&format=deb"
  sudo apt install -y ./discord.deb
  rm discord.deb
}

install_steam()
{
  # Install some required 32-bit packages
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install -y libc6:i386 libgl1-mesa-dri:i386 libgl1:i386

  # Download and install steam
  curl -Lo steam.deb "https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
  sudo apt install -y ./steam.deb
  rm steam.deb
}

install_whatsapp()
{
  curl -Lo whatsapp.deb "https://github.com/eneshecan/whatsapp-for-linux/releases/download/v1.6.4/whatsapp-for-linux_1.6.4_amd64.deb"
  sudo apt install -y ./whatsapp.deb
  rm whatsapp.deb
}

install_premake5() 
{
  curl -Lo premake5.tar.gz "https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz"

  # Only extract premake5 from the tarball, which is directly extracted to the /bin folder
  sudo tar -xf premake5.tar.gz -C /bin/ ./premake5

  rm premake5.tar.gz
}

install_vscode()
{
  # Download and install the latest deb file
  curl -Lo vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" 
  sudo apt install -y ./vscode.deb
  rm vscode.deb
}

install_vmware()
{
  # Install the linux-headers for the correct linux kernel version
  sudo apt install -y linux-headers-$(uname -r)

  # Download the installer using the bundle
  curl -o vmware.bundle "https://download3.vmware.com/software/WKST-1750-LX/VMware-Workstation-Full-17.5.0-22583795.x86_64.bundle"
  chmod +x vmware.bundle
  sudo ./vmware.bundle
  rm vmware.bundle

  # Install vmware through the installer
  sudo vmware-modconfig --console --install-all
}

install_ytop()
{
  sudo apt install -y cargo
  cargo install ytop
}

install_zsh()
{
  # Installing zsh and some plugins
  sudo apt install -y zsh zsh-autosuggestions zsh-syntax-highlighting
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/assets/zsh.sh)"

  # Overwriting the default .zshrc file to include the new packages and the correct theme
  curl -Lo ~/.zshrc "https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/assets/.zshrc"

  # Change the default shell to zsh
  chsh -s $(which zsh)

  # As zsh is it's own shell, it comes with it's own profile file 
  # which needs to contain the startx command to startup chadwm
  if grep -q "startx " /etc/zsh/zprofile; then
    echo "test -f ~/.config/chadwm/scripts/run.sh && startx ~/.config/chadwm/scripts/run.sh" | sudo tee -a /etc/zsh/zprofile
  fi
}

install_firefox()
{
  # Installing the base package for firefox
  curl -Lo firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
  sudo tar xjf firefox.tar.bz2 -C /opt/
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
  rm firefox.tar.bz2 

  # Adding the shortcut for rofi
  sudo curl "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -o /usr/local/share/applications/firefox.desktop
}

install_jetbrainsmononerdfont()
{
  # Create .fonts if it doesn't already exist
  mkdir -p ~/.fonts

  # Download and extract it into the .fonts folder, making sure to enable overwrite while unzipping
  curl -Lo ~/.fonts/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  cd ~/.fonts
  unzip -o JetBrainsMono.zip
  cd -
}

install_neovim()
{
  # The packages that are required for compiling neovim (unzip is also required but its already in the install command before everything runs)
  sudo apt install -y make gcc cmake gettext

  # Select a specific version to be downloaded
  version="0.9.4"

  # Download and extract neovim
  curl -Lo neovim.tar.gz "https://github.com/neovim/neovim/archive/refs/tags/v$version.tar.gz"
  tar -xf neovim.tar.gz
  rm neovim.tar.gz

  # Compile neovim
  cd neovim-$version
  sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
  cd -
  
  # Cleanup
  sudo rm -rf neovim-$version
}

install_nvchad()
{
  git clone "https://github.com/NvChad/NvChad" ~/.config/nvim --depth 1
}

install_st()
{
  # The packages that are required for compiling st
  sudo apt install -y make gcc build-essential libxft-dev libharfbuzz-dev libgd-dev
  rm -rf ~/.config/st # Ensure a clean install
  git clone "https://github.com/sten-code/st" ~/.config/st
  cd ~/.config/st
  sudo make install
  cd -
}

install_chadwm()
{
  # The packages that are required for compiling and using chadwm
  sudo apt install -y make gcc picom rofi feh acpi libimlib2-dev libxinerama-dev xinit psmisc maim xclip x11-xserver-utils xbacklight

  rm -rf ~/.config/chadwm # Ensure a clean installation
  git clone "https://github.com/sten-code/chadwm" --depth 1 ~/.config/chadwm
  cd ~/.config/chadwm/chadwm
  sudo make install
  cd -
 
  # If the startx command is already found in the .profile file then don't add it
  if grep -q "startx ~/.config/chadwm/scripts/run.sh" ~/.profile; then
    echo "startx ~/.config/chadwm/scripts/run.sh" >> ~/.profile
  fi

  # Add a nice wallpaper
  mkdir -p ~/.wallpapers
  curl -Lo ~/.wallpapers/wallpaper.png "https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/assets/wallpaper.png"
}

checkbox_options="Discord
Dolphin
Steam
Whatsapp
premake5
vlc
ytop
wpagui
Visual Studio Code
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
curl "https://raw.githubusercontent.com/sten-code/iusedebianbtw/main/assets/checkbox.sh" -o checkbox.sh
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
Visual Studio Code
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

echo "Selected Packages:"
echo "--------------------------------------------------"
for index in "${index_array[@]}"; do
  echo "${item_array[$index]}"
done
echo "--------------------------------------------------"
echo "Are you sure you want to install these packages? [Y/n]"
read -r opt
case $opt in
  y*|Y*|"") ;;
  n*|N*) exit ;;
  *) echo "Invalid choice."; exit ;;
esac

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
    "Visual Studio Code")       install_vscode;;
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

