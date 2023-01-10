function frg
  # find-rip-grep
  # 2 args
  # 1. string to match filenames against
  # 2. string to match against file contents
  fd {$argv[1]} -X rg {$argv[2]}
end
