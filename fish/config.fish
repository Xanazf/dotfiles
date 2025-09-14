if status is-interactive
    # Commands to run in interactive sessions can go here
    thefuck --alias | source
    # fastfetch
end

set -g fish_path "/home/xnzf/.config/fish"

function ec
    set_color $argv[1]
    echo $argv[2..-1]
    set_color normal
end

function check_node_version
    printf '%s %s%s %s %s%s\n' checking node (set_color green)"󰎙"(set_color normal) version (set_color cyan)''(set_color normal)' '
    nvm use latest -s

    set -f curr_node_version_file "$fish_path/curr_node_version.txt"
    set -f latest_node_version_file "$fish_path/latest_node_version.txt"

    nvm list | grep ▶ | grep -o 'v[[:digit:]]\{1,\}.[[:digit:]]\{1,\}.[[:digit:]]\{1,\}' >$curr_node_version_file
    nvm list-remote | grep latest | grep -o 'v[[:digit:]]\{1,\}.[[:digit:]]\{1,\}.[[:digit:]]\{1,\}' >$latest_node_version_file

    set -f curr_node_version (cat $curr_node_version_file)
    set -f latest_node_version (cat $latest_node_version_file)

    printf '%s: %s%s\n' current (set_color green)"󰎙"(set_color normal) $curr_node_version
    printf '%s: %s%s\n' latest (set_color green)"󰎙"(set_color normal) $latest_node_version

    if test $curr_node_version = $latest_node_version
        printf '%s %s\n' "current version is" (set_color green)latest(set_color normal)
        #
    else
        printf '%s %s, %s\n' 'current version is' (set_color brred)'not latest'(set_color normal) (set_color bryellow)'installing...'(set_color normal)
        nvm install latest -s
        check_node_version
    end
end

function fish_greeting
    set -f cat "$fish_path/cat.txt"
    set -f cat2 "$fish_path/cat2.txt"
    set -f cats "$fish_path/cats.txt"
    set -f bongocat "$fish_path/bongocat.txt"
    set -f catgun "$fish_path/catgun.txt"
    set -f separator '─────────'
    cat $bongocat
    echo $separator$separator
    check_node_version
    echo [(date +%x_%H:%M\(%Z\))]
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
end
# set -x PATH /path/to/tree-sitter $PATH
blur_terminal_background

# Created by `pipx` on 2024-06-30 20:00:14
set PATH $PATH /home/xnzf/.local/bin
#set -

set -Ux EMAIL hotdamnsucka@gmail.com
set -Ux GIT_AUTHOR_NAME Oleksandr
set -Ux GIT_AUTHOR_EMAIL hotdamnsucka@gmail.com
set -Ux GIT_AUTHOR_DATE [(date +%x_%H:%M\(%Z\))]
set -Ux GIT_COMMITTER_NAME Oleksandr
set -Ux GIT_COMMITTER_EMAIL hotdamnsucka@gmail.com
set -Ux GIT_COMMITTER_DATE [(date +%x_%H:%M\(%Z\))]
set -Ux GIT_CURL_VERBOSE true

fish_add_path /home/xnzf/.millennium/ext/bin
