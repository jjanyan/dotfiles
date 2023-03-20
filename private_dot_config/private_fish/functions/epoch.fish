function epoch
  set unix_number $argv[1]
  set unix_length (string length $unix_number)
  #echo $unix_length
  if test $unix_length -ge 12
    set unix_number (math -s 0 $unix_number / 1000)
  end
  #echo $unix_number
  date -r $unix_number
end
