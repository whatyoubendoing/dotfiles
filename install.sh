#!/usr/bin/env bash
sudo -v

REPO=whatyoubendoing/dotfiles
DOTFILES="${HOME}/Developer/dotfiles"

mkdir -p "${HOME}/Developer"
mkdir -p "${HOME}/Documents"
mkdir -p "${HOME}/Pictures/Screenshots"

if [ -d "$DOTFILES/.git" ]; then
    cd "$DOTFILES" && git pull
else
    git clone "git@github.com:${REPO}" "$DOTFILES"
fi

FILES=(".zshrc" ".aliases" ".Brewfile" ".functions")
for FILE in "${FILES[@]}"; do
    [ ! -e "${HOME}/$FILE" ] && ln -s "${DOTFILES}/$FILE" "${HOME}/$FILE"
done

which brew > /dev/null 2>&1
if [ $? -ne 0 ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew bundle install --global --formula --cask --tap --mas

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

## Install inshellisense
npm install -g @microsoft/inshellisense

# Enable sudo with Touch ID
echo "auth       sufficient     pam_tid.so" | sudo tee "/etc/pam.d/sudo_local"                                                                        