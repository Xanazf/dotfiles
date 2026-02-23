function jot
    set -l file "$fp_data_dir/notes.txt"
    if not test -f $file
        touch $file
    end

    if test (count $argv) -eq 0
        _fp_print_header "QUICK NOTES"
        cat $file
        _fp_print_footer
    else if test "$argv[1]" = edit
        # Open in system editor (vim, nano, code, etc)
        $EDITOR $file
    else
        # Add note with ASCII timestamp styling
        set -l stamp (date "+%Y-%m-%d %H:%M")

        # Format: [Timestamp] | Note content
        # We append directly to file
        echo " ┌─[$stamp]" >>$file
        echo " └─> $argv" >>$file
        echo "" >>$file # Empty line for spacing

        echo "✓ Note saved."
    end
end
