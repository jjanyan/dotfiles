
# aliases
alias c=clear
alias cl=clear
alias jsource='source ~/.config/fish/config.fish'
#alias rm='rm -fv'
alias cd1='cd ..; ls'
alias cd2='cd ../..; ls'
alias cd3='cd ../../..; ls'
alias gls="git log --pretty=format:'%C(dim white)%h %ad%Creset %C(normal)%s%Creset | %C(yellow)%an%Creset' --stat"
alias vihosts="sudo /opt/homebrew/bin/nvim /etc/hosts"
alias fh='history 0 | fzf'
# moved these back to alias so i can do gd, hit up, then modify to ga to continue. expanding out just makes shit slow. f*ck that
alias gd='git diff'
alias ga='git add'
alias j z
alias ji zi
alias killdns='sudo killall -HUP mDNSResponder'
alias zen='git checkout master && git pull && gh poi'
alias ugh='git checkout main && git pull && gh poi'
alias c='cursor'
alias clearmemcache='echo "flush_all" | nc localhost 11211'


# vim
abbr -ag vim nvim
abbr -ag vi nvim

# keep my dotfiles up to date
abbr -ag ca chezmoi add

# git
abbr -ag gs git status
abbr -ag gc git commit
abbr -ag glbranch git log master..
abbr -ag master git checkout master
abbr -ag gash git rev-parse --verify HEAD
abbr -ag ghash git rev-parse HEAD
abbr -ag grh git reset --hard
abbr -ag gundo git reset HEAD~
abbr -ag pl gh pr list
abbr -ag pc gh pr checkout
abbr -ag approve gh pr review --approve
abbr -ag squash 'gh pr merge --squash --delete-branch --subject="[$(git rev-parse --abbrev-ref HEAD)]" --body=""'
abbr -ag request 'gh pr create --title="[$(git rev-parse --abbrev-ref HEAD)]" --fill'
abbr -ag migrate 'npx prisma migrate dev'

# misc
abbr -ag cat bat

# check https://github.com/gazorby/fish-exa for additional exa aliases
