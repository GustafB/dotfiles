brew tap caskroom/versions
brew tap caskroom/cask
brew tap caskroom/fonts

# Install packages

apps=(
    firefox
    flux
    google-chrome
    google-chrome-canary
    macdown
    screenflow
    slack
    sourcetree
    spotify
    transmit
    virtualbox
    vlc
    iterm2
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package qlvideo
