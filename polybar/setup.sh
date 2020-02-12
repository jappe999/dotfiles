CWD=$(dirname $(readlink -f $0))

# copy configuration
mkdir $HOME/.config/polybar
cp -r $CWD $HOME/.config