# --- Configuration ---
# Store data in a local share folder
set -g fp_data_dir "$HOME/.local/share/fish_product"
mkdir -p $fp_data_dir

# Define the parent directory you want to track sub-folders for
set -g fp_track_parent "$HOME/.code"

# --- ASCII Helper ---
function _fp_print_header
    set title " $argv[1] "
    set -l term_width (tput cols)
    set -l title_len (string length $title)
    set -l padding_len (math "floor(($term_width - ($title_len)) / 2)")

    set_color cyan
    string repeat -n $padding_len "="
    set_color -o white
    echo -n "$title"
    echo ""
    set_color normal
    set_color cyan
    string repeat -n $padding_len "="
    echo ""
    set_color normal
end
function _fp_center_stream
    # Get terminal width once
    set -l term_width (tput cols)

    # Use awk to handle the math and printing line-by-line
    # This is significantly faster and won't hang on large outputs
    awk -v cols=$term_width '
    {
        # Store every line in an array
        lines[NR] = $0

        # Create a "clean" version of the line to measure length
        # 1. Remove ANSI color codes (\x1b...)
        clean = $0
        gsub(/\x1b\[[0-9;]*m/, "", clean)

        # 2. Replace tabs with 4 spaces for accurate visual width
        gsub(/\t/, "    ", clean)

        # Check if this line is the widest so far
        len = length(clean)
        if (len > max) max = len
    }
    END {
        # Calculate padding based on the widest line found
        pad_len = int((cols - max) / 2)
        if (pad_len < 0) pad_len = 0

        # Create the padding string
        padding = sprintf("%" pad_len "s", "")

        # Print all lines with the calculated padding
        for (i = 1; i <= NR; i++) {
            print padding lines[i]
        }
    }'
end

function _fp_r_anchor_stream
    # Get terminal width
    set -l term_width (tput cols)

    awk -v cols=$term_width '
    {
        # 1. Clean ANSI codes to measure true length
        clean = $0
        gsub(/\x1b\[[0-9;]*m/, "", clean)
        gsub(/\t/, "    ", clean)

        # 2. Calculate padding needed to push this specific line to the right
        len = length(clean)
        pad = cols - len

        # Safety: If line is longer than screen, clamp padding to 0
        if (pad < 0) pad = 0

        # 3. Print spaces (padding) + original line
        # printf "%*s" allows dynamic padding width
        printf "%" pad "s%s\n", "", $0
    }'
end

function _fp_print_footer
    set_color cyan
    string repeat (tput cols) -
    set_color normal
end

function _fp_track_directories --on-variable PWD
    # Only track if we are inside the specific parent directory
    if string match -q "$fp_track_parent*" $PWD
        set -l file "$fp_data_dir/dirs.txt"
        if not test -f $file
            touch $file
        end

        # 1. Read existing list
        set -l dir_list (cat $file)

        # 2. Filter logic: Remove overlaps
        # We create a new list excluding any path that is a PARENT of current $PWD
        # OR a CHILD of current $PWD. This keeps the history clean.
        set -l clean_list
        for item in $dir_list
            # Skip if item is exact match (handled later)
            if test "$item" = "$PWD"
                continue
            end

            # 1. If item is a CHILD of current PWD (we moved up), remove item
            #    (e.g. PWD=Projects, Item=Projects/App -> Remove App)
            if string match -q "$PWD/*" "$item"
                continue
            end

            # 2. If item is a PARENT of current PWD (we moved down), remove item
            #    (e.g. PWD=Projects/App, Item=Projects -> Remove Projects)
            if string match -q "$item/*" "$PWD"
                continue
            end

            set -a clean_list $item
        end

        set dir_list $clean_list

        # 3. Add current directory to top
        set -p dir_list "$PWD"

        # 4. Save top 15
        string join \n $dir_list[1..15] >$file
    end
end
