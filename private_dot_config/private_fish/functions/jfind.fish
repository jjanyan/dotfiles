# this is now just muscle memory, fd is the bomb
function jfind
  fd {$argv[1]}
  #find . -path .git -prune -o -follow -iname \*{$argv[1]}\*
end
