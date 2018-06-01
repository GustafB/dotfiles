if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

brew tap caskroom/versions
brew tap caskroom/cask
brew tap caskroom/fonts

# Install packages

apps=(
  dash2
  dropbox
  firefox
  flux
  google-chrome
  google-chrome-canary
  macdown
  screenflow
  slack
  sourcetree
  spotify
  sublime-text
  transmit
  virtualbox
  vlc
  zeplin
  iterm2
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package qlvideo
