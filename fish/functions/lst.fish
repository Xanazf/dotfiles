function lst --wraps='exa --icons -1 -l -a --group-directories-first -t' --wraps='exa --icons -1 -l -a --group-directories-first -T' --description 'alias lst exa --icons -1 -l -a --group-directories-first -T'
  exa --icons -1 -l -a --group-directories-first -T $argv
        
end
