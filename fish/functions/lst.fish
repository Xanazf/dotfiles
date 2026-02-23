function lst --wraps='exa --icons -1 -l -a --group-directories-first -T' --wraps='exa --icons -1 -l -a --group-directories-first -T --show-symlinks --git-ignore -I "node_modules|dist|git"' --description 'alias lst exa --icons -1 -l -a --group-directories-first -T'
    exa --icons -1 -l -a --group-directories-first -T --show-symlinks --git-ignore -I="node_modules|dist|.git" $argv
end
