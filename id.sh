# Use the Unique portion of the Apple 12 Digit Serial number 
# https://www.macrumors.com/2010/04/16/apple-tweaks-serial-number-format-with-new-macbook-pro/
FULLSERIAL=$(system_profiler SPHardwareDataType | sed '/^ *Serial Number (system):*/!d;s###;s/ //')
PARTSERIAL=$(echo $FULLSERIAL | cut -c 6-8)
sudo scutil --set ComputerName $PARTSERIAL
sudo scutil --set HostName $PARTSERIAL
sudo scutil --set LocalHostName $PARTSERIAL
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $PARTSERIAL