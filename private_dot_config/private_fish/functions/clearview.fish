function clearview
    argparse h/help -- $argv
    or return

    if set -ql _flag_help
        echo "Usage: clearview [filename]"
        return 0
    end
  
    set filename $argv[1]
    if not set -q filename
        echo "Usage: mkscript [filename]"
        return
    end
    rm ~/.local/state/nvim/view/*$filename*
end
