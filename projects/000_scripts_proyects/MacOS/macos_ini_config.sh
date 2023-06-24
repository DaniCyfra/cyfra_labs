#!/bin/bash

# Instala Python
brew install python

# Instala OpenSSH
brew install openssh

# Configura SSH
sudo systemsetup -setremotelogin on
sudo launchctl stop com.openssh.sshd
sudo launchctl start com.openssh.sshd

# Configura el cortafuegos
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/sbin/sshd
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /usr/sbin/sshd
