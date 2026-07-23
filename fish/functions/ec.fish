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
