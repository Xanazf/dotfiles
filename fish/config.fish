if status is-interactive
    # Commands to run in interactive sessions can go here
    thefuck --alias | source
    # fastfetch
end

if test -n $XDG_CONFIG_HOME
    set -g fish_path "$XDG_CONFIG_HOME/fish"
else if test -n $XDG_DATA_HOME
    set -g fish_path "$XDG_DATA_HOME/.config/fish"
else
    set -g fish_path "/home/xnzf/.config/fish"
end

function ec
    if test "$argv[1]" -a "$argv[2]"
        set -f coloring "$(set_color $argv[1])"
        set -f text_passed "$argv[2..-1]"
        set -f norm "$(set_color normal)"

        echo -n "$coloring$text_passed$norm"
    else
        echo -ne "\n"
        #
    end
    return 0
end

set -g node_symbol "$(ec green '󰎙')"

function lock_node_version
    set -f node_version_lockfile "$fish_path/node_version.lock"
    if not test -e $node_version_lockfile
        echo "node version lockfile $(ec brred 'doesn\'t exist'), creating..."
        touch $node_version_lockfile
    end

    set -f node_locked (cat $node_version_lockfile)
    if test -n $node_locked
        echo "lockfile is empty"
        #
    end

    if test -n "$argv[1]"
        set -Ux nvm_default_version "$argv[1]"
        set -Ux nvm_default_packages "corepack typescript tsx"
        echo -n "$argv[1]" >$node_version_lockfile
        nvm use "$argv[1]" -s
        printf '%s%s %s\n' node $node_symbol "version $(ec bryellow locked) at $argv[1]"
    else
        echo "no version provided, exiting..."
    end
    return 0
end

function check_node_version
    printf '%s %s%s %s %s\n' checking node $node_symbol version $(ec cyan ' ')

    set -f latest_node_version_file "$fish_path/latest_node_version.txt"
    set -f node_version_lockfile "$fish_path/node_version.lock"

    nvm list-remote latest | grep -o 'v[[:digit:]]\{1,\}.[[:digit:]]\{1,\}.[[:digit:]]\{1,\}' >$latest_node_version_file

    set -f curr_node_version (node -v)
    set -f latest_node_version (cat $latest_node_version_file)
    set -f node_locked (cat $node_version_lockfile)

    printf '%s: %s%s\n' current $node_symbol $curr_node_version
    printf '%s: %s%s\n' latest $node_symbol $latest_node_version

    if test $curr_node_version = $latest_node_version
        printf '%s %s\n' "current version is" (ec green "latest")
        #
    else if test $node_locked -a $node_locked = $curr_node_version
        printf '%s %s %s\n' "current version is" (ec bryellow "locked") "at $nvm_default_version"
        #
    else
        printf '%s %s, %s\n' "current version is" (ec brred "not latest") (ec bryellow "installing...")
        nvm install latest -s
        nvm use latest -s
        check_node_version
    end
    return 0
end

function fish_greeting
    set -f cat "$fish_path/cat.txt"
    set -f cat2 "$fish_path/cat2.txt"
    set -f cats "$fish_path/cats.txt"
    set -f bongocat "$fish_path/bongocat.txt"
    set -f catgun "$fish_path/catgun.txt"
    set -f separator '─────────'
    cat $bongocat
    echo $separator$separator$separator$separator$separator$separator
    uwufetch
    echo $separator$separator$separator$separator$separator$separator
    check_node_version
    echo "[$(date +%x_%H:%M\(%Z\))]"
    return 0
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

set -Ux EMAIL hotdamnsucka@gmail.com
set -Ux GIT_AUTHOR_NAME Oleksandr
set -Ux GIT_AUTHOR_EMAIL hotdamnsucka@gmail.com
set -Ux GIT_AUTHOR_DATE [(date +%x_%H:%M\(%Z\))]
set -Ux GIT_COMMITTER_NAME Oleksandr
set -Ux GIT_COMMITTER_EMAIL hotdamnsucka@gmail.com
set -Ux GIT_COMMITTER_DATE [(date +%x_%H:%M\(%Z\))]
set -Ux GIT_CURL_VERBOSE true

# Go

set -Ux GOPATH $HOME/go
fish_add_path $GOPATH/bin

# Vulkan
set -f vulkan_bin $VULKAN_SDK/bin
set -Ux VULKAN_BIN $vulkan_bin
fish_add_path $vulkan_bin

set -Ux LD_LIBRARY_PATH $VULKAN_SDK/lib
set -Ux VK_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
set -Ux VK_ADD_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
set -Ux PKG_CONFIG_PATH $VULKAN_SDK/lib/pkgconfig/

# steam
fish_add_path /home/xnzf/.millennium/ext/bin

# pip
fish_add_path /home/xnzf/.local/bin
