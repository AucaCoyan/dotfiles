# nixOS setup

Move the files into ~/dotfiles/repos/Linux/nixOS/ .... if you haven't yet

create a symbolic link with


```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/thanos /etc/nixos
```
as root

```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha /etc/nixos
```


rebuild switch with:

```
sudo nixos-rebuild switch --flake /etc/nixos#default
```


nixos can't be symlinked because of:
https://github.com/NixOS/nix/issues/8013

