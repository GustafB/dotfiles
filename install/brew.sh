ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap Goles/battery
brew update
brew upgrade

# Install packages

apps=(
  bash-completion2
  battery
  coreutils
  diff-so-fancy
  gifsicle
  git
  git-extras
  gnu-sed --with-default-names
  grep --with-default-names
  httpie
  psgrep
  python
  shellcheck
  ssh-copy-id
  tree
  unar
  wget
  wifi-password
  mongodb
  postgresql
  mysql
  zsh
  tinyproxy-libproxy
)

brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
