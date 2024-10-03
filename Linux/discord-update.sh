#!/bin/bash

# thanks to Gromate!
# https://github.com/Gromate/discord-updater/blob/main/discord-update.sh

url="https://discord.com/api/download/stable?platform=linux&format=deb"
wget --trust-server-names -P /tmp "${url}" &&
ls /tmp &&
sudo apt install /tmp/discord*.deb
