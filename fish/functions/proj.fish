function proj
    set -l file "$fp_data_dir/dirs.txt"

    # 1. No arguments: List folders
    if test -z "$argv[1]"
        _fp_print_header "RECENT PROJECTS"
        if not test -f $file; or not test -s $file
            echo "   (No history yet. Visit folders in $fp_track_parent)"
        else
            set -l count 1
            for dir in (cat $file)
                # Replace $HOME with ~ for display
                set -l pretty_path (string replace -r "^$HOME" "~" $dir)
                echo " $count. $pretty_path"
                set count (math $count + 1)
            end
        end
        _fp_print_footer

        # 2. 'recent' subcommand: Show modified files
    else if test "$argv[1]" = recent
        _fp_print_header "PROJECT ACTIVITY"
        if not test -f $file
            echo "   (No projects tracked)"
        else
            # Loop through the top 5 tracked projects only (for speed)
            for dir in (head -n 5 $file)
                if test -d "$dir"
                    set -l proj_name (basename "$dir")

                    # Print Project Name
                    set_color blue -o
                    echo "$proj_name/"
                    set_color normal

                    # Find last 3 modified files
                    # -maxdepth 4: Don't go too deep (speed)
                    # -not -path: Ignore git, node_modules, rust target, python venv
                    # -printf '%T@ %P': Print timestamp and relative path (%P removes root)
                    set -l recent_files (find "$dir" -maxdepth 5 \
                        \( -name ".git" \
                           -o -name "node_modules" \
                           -o -name "target" \
                           -o -name "venv" \
                           -o -name "__pycache__" \
                           -o -name "dist" \
                           -o -name "build" \
                        \) -prune \
                        -o \
                        -type f -printf '%T@ [%Td-%Tm-%Ty %TH:%TM] @ %P\n' | sort -rn | head -n 3 | cut -d' ' -f2-)

                    if test -n "$recent_files"
                        for f in $recent_files
                            echo "  • $f"
                        end
                    else
                        echo "  (No recent changes)"
                    end
                    echo "" # Spacer
                end
            end
        end
        _fp_print_footer

        # 3. Numeric argument: Jump to folder
    else
        if test -f $file
            set -l target (sed -n "$argv[1]p" $file)
            if test -n "$target"
                cd $target
                _fp_print_header JUMPED
                echo "-> $target"
                _fp_print_footer
            else
                echo "Invalid selection."
            end
        end
    end
end
