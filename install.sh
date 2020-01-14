# Add PPAs
sudo add-apt-repository ppa:ubuntu-mozilla-daily/firefox-aurora
sudo add-apt-repository ppa:kgilmer/speed-ricer
sudo apt-get update -y

# Install packages
sudo apt-get install\
    i3 i3-gaps polybar rofi i3lock nordic playerctl\
    xeventbind compton light ffmpeg vlc nautilus firefox\
    zsh pavucontrol feh pulseaudio git\
    node yarn python3 python3-pip
pip3 install wal


# Setup i3

# Setup polybar
# - Copy configuration

# Setup i3-lock

# Setup rofi menu

# Setup oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup devpot
# - Install and configure