#!/bin/sh
###############################################################################
# Sudo                                                                        #
###############################################################################
echo "Enter admin password if prompted"
sudo -v #-v adds 5 minutes https://www.sudo.ws/man/1.8.13/sudo.man.html

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Xcode                                                                       #
###############################################################################
# Xcode equired for homebrew - https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Installation.md#requirements
# Install xcode if not already installed
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  xcode-select --install
else
  echo "Xcode already installed"
fi

###############################################################################
# Homebrew                                                                    #
###############################################################################
# Install homebrew if not already installed
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
   echo "Homebrew already installed"
fi

###############################################################################
# Homebrew + Cask                                                             #
###############################################################################
brew tap caskroom/cask

###############################################################################
# Common                                                                      #
###############################################################################
brew cask install google-chrome
brew cask install firefox
brew cask install microsoft-office
brew cask install sublime-text
brew cask install expandrive
brew cask install joinme
brew cask install dialpad

###############################################################################
# Design                                                                      #
###############################################################################
brew cask install adobe-creative-cloud #https://github.com/caskroom/homebrew-cask/pull/39442

###############################################################################
# Cleanup                                                                     #
###############################################################################
brew cleanup
brew cask cleanup

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Use the Unique portion of the Apple 12 Digit Serial number 
# https://www.macrumors.com/2010/04/16/apple-tweaks-serial-number-format-with-new-macbook-pro/
FULLSERIAL=$(system_profiler SPHardwareDataType | sed '/^ *Serial Number (system):*/!d;s###;s/ //')
PARTSERIAL=$(echo $FULLSERIAL | cut -c 6-8)
sudo scutil --set ComputerName $PARTSERIAL
sudo scutil --set HostName $PARTSERIAL
sudo scutil --set LocalHostName $PARTSERIAL
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $PARTSERIAL

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Set Desktop as the default `PfDe` location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder: show hidden files by default
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: remove color tags
# defaults write com.apple.finder ShowRecentTags -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use column view in all Finder windows by default
# Four-letter codes for the view modes: `icnv` = icon, `clmv` = column, `Flwv` = coverflow, `Nlsv` = list
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowServers -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Minimize windows into their application’s icon
# defaults write com.apple.dock minimize-to-application -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Disable Dashboard
#defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

###############################################################################
# Complete                                                                    #
###############################################################################
open /Applications/App\ Store.app

echo "Done. Note that some of these changes require a logout/restart to take effect."
say -v Good "I'm all done setting up your computer"
