#! /bin/bash

#######################################
# Bash script to install apps on a new system (Ubuntu)
# Written by @AamnahAkram from http://aamnah.com
#######################################

set -eu -o pipefail # fail on error and report it, debug all lines

echo "###### Linux installation script ######"

## Update packages and Upgrade system
sudo apt-get update -y

## Git ##
echo '###Installing Git..'
sudo apt-get install git -y

# Git Configuration
echo '###Congigure Git..'
git config --global user.name "Auca Maillot"
git config --global user.email "aucacoyan@gmail.com"
echo 'Git has been configured!'
# git config --list

## Brew ##
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

