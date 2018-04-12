echo "Administrator password required to enable FileVault"
sudo fdesetup enable
echo "Administrator password required to set lost and found notice"
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "If found, please contact Vanguard Communications: 303-382-2999, newrequest@vanguardcommunications.net"
echo "Your Login Window Text can be edited in System Preferences > Security & Privacy > General > Set Lock Message."

# Log installation events for 10 years
sudo perl -p -i -e 's/format=bsd/format=bsd mode=0640 rotate=utc compress file_max=5M ttl=3650/g' "/etc/asl/com.apple.install"

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1