function task
    set -l file "$fp_data_dir/todo.txt"
    if not test -f $file
        touch $file
    end

    switch $argv[1]
        case add
            # Check if description provided
            if test -z "$argv[2]"
                echo "Usage: task add 'Task Description'"
                return 1
            end
            echo "$argv[2..-1]" >>$file
            echo "✓ Task added."

        case done
            # Check if line number provided
            if test -z "$argv[2]"
                echo "Usage: task done [line_number]"
                return 1
            end

            # Delete line (compatible with generic sed)
            set -l temp (mktemp)
            # Use fish builtin logic to exclude the specific line
            set -l count 1
            while read -l line
                if test $count -ne $argv[2]
                    echo $line >>$temp
                end
                set count (math $count + 1)
            end <$file
            mv $temp $file
            echo "✓ Task marked done."

        case '*'
            _fp_print_header TASKS
            if not test -s $file
                echo "   (No active tasks)"
            else
                nl -w 2 -s '. [ ] ' $file
            end
            _fp_print_footer
    end
end
