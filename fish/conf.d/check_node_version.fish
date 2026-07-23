function check_node_version
    _fp_print_header "CHECKING Node$node_symbol $(ec cyan ' ')"

    set -f latest_node_version_file "$fish_path/latest_node_version.txt"
    # set -f node_version_lockfile "$fish_path/node_version.lock"

    nvm list-remote latest | grep -o 'v[[:digit:]]\{1,\}.[[:digit:]]\{1,\}.[[:digit:]]\{1,\}' >$latest_node_version_file

    set -f curr_node_version (nvm current)
    set -f latest_node_version (cat $latest_node_version_file)
    # set -f node_locked (cat $node_version_lockfile)

    printf '%s: %s%s\n' $(ec red "current") $node_symbol $curr_node_version
    printf '%s: %s%s\n' $(ec white "latest") $node_symbol $latest_node_version

    if test $curr_node_version = $latest_node_version
        printf '%s %s\n' "current version is" (ec green "latest")
        #
        # else if test $node_locked -a $node_locked = $curr_node_version
        #     printf '%s %s %s\n' "current version is" (ec bryellow "locked") "at $nvm_default_version"
        #     echo ""
        #     #
    else
        printf '%s %s, %s\n' "current version is" (ec brred "not latest") (ec bryellow "installing...")
        nvm install latest -s
        nvm use latest -s
        set -Ue nvm_default_version
        set -U nvm_default_version $(string match -r '\d+\.\d+\.\d+' $nvm_current_version)
        sleep 1
        npm i --silent -g $(cat "$XDG_DATA_HOME/.default-npm-packages")
        corepack enable
        corepack install -g yarn
        echo ""
        set curr_node_version (node -v)
        printf '%s: %s%s\n' $(ec green "current") $node_symbol $curr_node_version
        printf '%s: %s%s\n' $(ec green "latest") $node_symbol $latest_node_version
    end
    return 0
end
