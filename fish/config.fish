if status is-interactive
    # Commands to run in interactive sessions can go here
    thefuck --alias | source
    # fastfetch
end

if test -n "$XDG_CONFIG_HOME"
    set -g fish_path "$XDG_CONFIG_HOME/fish"
else if test -n "$XDG_DATA_HOME"
    set -g fish_path "$XDG_DATA_HOME/.config/fish"
else
    set -g fish_path "/home/xnzf/.config/fish"
end

set -g node_symbol "$(ec green '󰎙')"

function fish_greeting
    set -f cat "$fish_path/cat.txt"
    set -f cat2 "$fish_path/cat2.txt"
    set -f cats "$fish_path/cats.txt"
    set -f bongocat "$fish_path/bongocat.txt"
    set -f catgun "$fish_path/catgun.txt"
    set -l term_width (tput cols)
    set -f separator '─'
    set -f padding_len (math "floor($term_width / 4)")
    cat $bongocat | _fp_r_anchor_stream
    echo ""
    string repeat (tput cols) $separator
    uwufetch
    string repeat (tput cols) $separator
    echo ""
    check_node_version
    echo ""
    echo "[$(date +%x_%H:%M\(%Z\))]"
    echo ""
    proj recent
    return 0
end

function skyfix
    sudo prlimit --pid $(pgrep -f SkyrimSE.exe) --nofile=8192:524288 && echo "Limits updated for Skyrim."
end

set -g fish_greeting

function blur_terminal_background
    if test $DISPLAY
        for class in kitty konsole
            for ID in (xdotool search --class $class)
                xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $ID
            end
        end
    end
    return 0
end

blur_terminal_background

set -gx EMAIL hotdamnsucka@gmail.com
set -gx GIT_AUTHOR_NAME Oleksandr
set -gx GIT_AUTHOR_EMAIL hotdamnsucka@gmail.com
set -gx GIT_AUTHOR_DATE [(date +%x_%H:%M\(%Z\))]
set -gx GIT_COMMITTER_NAME Oleksandr
set -gx GIT_COMMITTER_EMAIL hotdamnsucka@gmail.com
set -gx GIT_COMMITTER_DATE [(date +%x_%H:%M\(%Z\))]
set -gx GIT_CURL_VERBOSE true

# Go

set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# Vulkan
# set -f vulkan_bin $VULKAN_SDK/bin
# set -Ux VULKAN_BIN $vulkan_bin
# fish_add_path $vulkan_bin
# set -Ux LD_LIBRARY_PATH $VULKAN_SDK/lib
# set -Ux VK_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
# set -Ux VK_ADD_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
# set -Ux PKG_CONFIG_PATH $VULKAN_SDK/lib/pkgconfig/

# steam
fish_add_path /home/xnzf/.millennium/ext/bin

# pip
fish_add_path /home/xnzf/.local/bin

# CTX7
set -x CONTEXT7_API_KEY ctx7sk-cabf4b7b-d1bc-4648-b095-599adc3bde5b


# Added by Antigravity CLI installer
set -gx PATH "/home/xnzf/.local/bin" $PATH
