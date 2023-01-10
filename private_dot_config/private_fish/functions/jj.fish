function jj
    j {$argv[1]};
    if test -e Pipfile
        pipenv shell
    end
end
