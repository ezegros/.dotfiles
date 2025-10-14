# Source conf.d/*.fish files
source $HOME/.config/fish/conf.d/path.fish
source $HOME/.config/fish/conf.d/colors.fish
source $HOME/.config/fish/conf.d/abbreviations.fish
source $HOME/.config/fish/conf.d/export.fish
source $HOME/.config/fish/conf.d/gpg.fish
source $HOME/.config/fish/conf.d/zoxide.fish
source $HOME/.config/fish/conf.d/orbstack.fish

# pnpm
set -gx PNPM_HOME "/Users/ezekielgrosfeld/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
