function mkscript
    argparse h/help -- $argv
    or return

    if set -ql _flag_help
        echo "Usage: mkscript [scriptname] [shebang]"
        return 0
    end
  
    set scriptname $argv[1]
    set shebang $argv[2]
    if not set -q shebang
        set shebang "fish"
    end
    if test -z $shebang
        set shebang "fish"
    end
    if not set -q scriptname
        echo "Usage: mkscript [scriptname] [shebang]"
        return
    end
    if test -e $scriptname
        echo "File $scriptname already exists"
        return
    end
    touch $scriptname
    echo "#! /usr/bin/env $shebang" > $scriptname
    chmod +x $scriptname
end
