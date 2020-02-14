CWD=$(dirname $(readlink -f $0))

# copy configuration
mkdir -p $HOME/.config/polybar
./create_config
# cp -r $CWD $HOME/.config