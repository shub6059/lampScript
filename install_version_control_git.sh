#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ubuntu 20.04 +
# Script will auto terminate on errors
# run like - bash install_version_control_git.sh

export DEBIAN_FRONTEND=noninteractive

# Install latest git
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install git

# My Git Configs
git config --global --add merge.ff true
git config --global push.followTags true
git config --global core.autocrlf false
git config --global push.default simple
git config --global color.ui auto
git config --global branch.autosetuprebase always
git config --global core.compression 9
git config --global credential.helper 'cache --timeout 28800'
git config --global core.filemode false
git config --global push.default current
git config --global core.editor "nano"
git config --global core.excludesfile "$HOME/.gitignore"
touch ~/.gitignore

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.logout 'credential-cache exit'

# Clean up
sudo apt-get clean

# Check for git version
git --version
