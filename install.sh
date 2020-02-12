CWD=$(dirname $(readlink -f $0))

sudo apt install curl -y

echo "
#### Adding sources for yarn
"
# add yarn source
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# add docker key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add snhw key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D320D0C30B02E64C5B2BB2743766223989993A70

# Add postgres key
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# add repostories
echo "
## Adding PPAs kgilmer/speed-ricer, snwh/ppa, docker/linux and lyzardking/ubuntu-make
"
sudo add-apt-repository -y ppa:kgilmer/speed-ricer
sudo add-apt-repository -y "deb http://ppa.launchpad.net/snwh/ppa/ubuntu disco main" # TODO: move to eoan when possible
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu disco stable" # TODO: move to eoan when possible
sudo add-apt-repository -y ppa:lyzardking/ubuntu-make
sudo touch /etc/apt/sources.list.d/pgdg.list
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

echo "
## Running `apt-get update -y`
"
sudo apt-get update -y

# install packages
echo "
## Installing packages
"
sudo apt-get install -y\
    i3-gaps-wm polybar rofi i3lock nordic playerctl\
    compton xbacklight ffmpeg vlc nautilus firefox snapd\
    zsh pavucontrol feh pulseaudio git paper-icon-theme\
    yarn python3 python3-pip redshift telegram-desktop\
    fonts-source-code-pro-ttf docker-ce ubuntu-make vim\
    postgresql-11 pgadmin4

sudo snap install spotify
pip3 install pywal

echo "
## Installing firefox developer edition with ubuntu-make
"
umake nodejs
umake web firefox-dev
umake ide visual-studio-code

echo "
## Installing docker-compose
"
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# setup i3
echo "
## Setup i3
"
cp -r wallpapers $HOME/.wallpapers
mkdir $HOME/.config/i3
sh $CWD/i3/create_config

# setup polybar
echo "
## Setup polybar
"
./polybar/setup.sh

# setup i3lock
# echo "
# ## Setup i3lock
# "

# setup rofi menu
echo "
## Setup rofi
"
cp $CWD/i3/.Xresources $HOME/.config/i3

# setup oh-my-zsh
echo "
## Install and setup oh-my-zsh
"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
chsh -s /bin/zsh
export SHELL=/bin/zsh

echo "
## Add paths with applications to ~/.zshrc
"
echo 'export PATH=$HOME/devpot/bin:$HOME/.local/bin:$HOME/.local/share:$PATH' >> ~/.zshrc

# setup screenlayouts
echo "
## Setup screenlayouts
"
cp -r screenlayout $HOME/.screenlayout

# setup devpot
echo "
## Setup devpot
"
sudo groupadd docker
sudo usermod -aG docker $USER

if [ ! -e "$HOME/devpot" ]
then
    git clone https://github.com/Arbarwings/devpot.git $HOME/devpot
fi
sudo chmod +x $HOME/devpot/bin/devpot

cd $HOME/devpot
cp .env.dist .env
sudo $HOME/devpot/bin/devpot create-certificate
sudo su -c "docker-compose build && docker-compose up -d && docker-compose ps"
cd $HOME

# wrap up installation
logout() {
    sudo pkill -KILL $USER
}

echo "
Packages were installed. Please install the following apps manually:
- Boostnote -> https://boostnote.io/
- Virtualbox -> https://download.virtualbox.org/virtualbox/
- Filezilla -> https://filezilla-project.org/
- 
"

while true; do
    read -p "Do you wish to log out to start i3? (Y/n)" yn
    case $yn in
        [Yy]* ) logout; break;;
        * ) echo "Manual logout selected."; exit;;
    esac
done