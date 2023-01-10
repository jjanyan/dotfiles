if status is-interactive
  # control + k to accept suggestion
  # this stops my clearing the screen
  #bind -M insert \cl accept-autosuggestion

  # INFO: make sure to run `fish_vi_key_bindings` !!!
  bind -M insert \cN forward-word
  bind -M insert \cK accept-autosuggestion

  # quiet the fish greeting
  set fish_greeting

  # make sure to use vim for editing things like git/cron
  export EDITOR=vim
  export VISUAL=vim
  # dumb ass pythong issue when running manage.py
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES


  # add aliases
  source ~/.config/fish/alias.fish

  # virtualenv path
  export WORKON_HOME=~/.virtualenvs/

  # autojump
  [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
  set AUTOJUMP_KEEP_SYMLINKS 1

  # autojump alternative
  zoxide init fish | source

  # mysql path
  export PATH="/usr/local/opt/mysql/bin:$PATH"

  # custom bin path
  export PATH="/Users/josh/.bin:$PATH"

  # Created by `pipx` on 2021-07-20 15:44:53
  set PATH $PATH /Users/josh/.local/bin
  fish_add_path /usr/local/opt/curl/bin


  # for go / golang
  export PATH="/Users/josh/go/bin:$PATH"


  # use bat with delta diff tool
  export DELTA_PAGER=bat


  # make pyenv work for non virtualenv / pipenv
  set PYENV_ROOT $HOME/.pyenv
  set -x PATH $PYENV_ROOT/shims $PYENV_ROOT/bin $PATH
  pyenv rehash

  # rust
  export PATH="$HOME/.cargo/bin:$PATH"

  # ripgrep custom config
  export RIPGREP_CONFIG_PATH="/Users/josh/.config/rg/ripgreprc"

  # this was colliding with mcfly. see if i need the ctrl+f functionality or not. if i do, figure out how to make them play nice together
  # set ctrl+f to search filenames
  # nvim ctrl+f => nvim app/models/org.py
  # ok, this allows me to use fzf for files, but not history, that's mcfly. the --history unbinds the history
  fzf_configure_bindings --directory=\cF --history
  # push history to ctrl+H
  # fzf_configure_bindings --history=\cR
  # fzf_configure_bindings --git_status=\cG

  # better history searching
  set -gx MCFLY_KEY_SCHEME vim
  set -gx MCFLY_FUZZY 2
  mcfly init fish | source


  # nvm / node
  # make sure i'm using whatever i've decided as the default
  # nvm use default
end

