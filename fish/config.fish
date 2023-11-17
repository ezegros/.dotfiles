if status is-interactive
    # Commands to run in interactive sessions can go here
    source $HOME/.config/fish/abbreviations.fish
end

# NOTE: allow expanding commands using C-e
bind -M insert \cE forward-char

# NOTE: disables "Welcome to Fish" greeting
set fish_greeting

set -gx DEFAULT_USER $USER
set -gx EDITOR 'nvim'
set -gx HSANDBOX_EDITOR 'nvim'
set -gx GIT_EDITOR 'nvim'
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

fish_add_path "$HOME/bin"
fish_add_path "/usr/local/bin"
fish_add_path "$HOME/go/bin"
fish_add_path "/opt/homebrew/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/development/flutter/bin"

set -gx HOMEBREW_PREFIX "/opt/homebrew" # lookup using (brew --prefix)
