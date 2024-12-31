# This is an example configuration file for lobster. This configuration includes all of the defaults, which you can change to you likings. The script will behave the exact same if you remove all of the values present here.

# lobster_editor=${VISUAL:-${EDITOR:-nvim}}
player=vlc
download_dir="$HOME/Movies"
provider="Vidcloud" # Vidcloud, UpCloud
history=false
subs_language="english"
histfile="$HOME/.local/share/lobster/lobster_history.txt"
use_external_menu=0
image_preview=true
debug=0
quiet_output=0
preview_window_size=50%
use_ueberzugpp=true
ueberzug_x=$(($(tput cols) - 40))
ueberzug_y=$(($(tput lines) / 10))
ueberzug_max_width=30
ueberzug_max_height=30

download_video() {
	ffmpeg -loglevel error -stats -i "$1" -c copy "$3/$2".mp4
}
