function done --argument message
    set -q message[1]; or set message "done";
    osascript -e 'set t to (time string of (current date))
    display notification "Done - " & t with title "'(echo $message)'" sound name "Glass"'
end
