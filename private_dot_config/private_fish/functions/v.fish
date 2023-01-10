function v
    if count $argv > /dev/null
        set result (fzf --query={$argv[1]})
        if test -n "$result"
            nvim $result
        end
    else
        set result (fzf)
        if test -n "$result"
            nvim $result
        end
    end
end
