function ls --wraps='exa --icons' --wraps='exa --icons -1 -l -a --group-directories-first' --description 'alias ls exa --icons -1 -l -a --group-directories-first'
  exa --icons -1 -l -a --group-directories-first $argv
        
end
