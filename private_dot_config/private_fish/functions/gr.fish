# git-root - cd to the root of the current git repository
function gr
    cd ./(git rev-parse --show-cdup)
end
