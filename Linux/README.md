# My rumblings about Linux

You have

- an Install script for `Debian` in its folder
- and a simple configuration nix filea in its folder

Copy and steal as much as you like!

## Common symlinks


nixOS:  Command `/home/linuxbrew/.linuxbrew/bin/oh-my-posh` not found
```
sudo mkdir -p /home/linuxbrew/.linuxbrew/bin
sudo ln --symbolic --force --no-dereference /run/current-system/sw/bin/oh-my-posh /home/linuxbrew/.linuxbrew/bin/oh-my-posh
```