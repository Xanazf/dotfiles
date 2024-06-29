uwufetch -i ~/.config/uwufetch/arch.png
if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    echo online...
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
set -x PATH /path/to/tree-sitter $PATH
blur_terminal_background
