function pg
    set -l fixed_strings
    # thanks chatGPT

    if not argparse "f/fixed-strings" -- $argv 2>/dev/null
        echo "Usage: pg [-f | --fixed] <search_string>"
        return 1
    end

    if test -n "$_flag_fixed_strings"
        set fixed_strings "--fixed-strings"
    end

    if test (count $argv) -eq 0
        echo "Usage: pg [-f | --fixed] <search_string>"
        return 1
    end

    rg $fixed_strings --type py -- $argv
end
