# nixOS setup

Move the files into ~/dotfiles/repos/Linux/nixOS/ .... if you haven't yet

create a symbolic link with


```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/thanos /etc/nixos
```
as root

```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha /etc/nixos

# or, just the configuration file
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha/configuration.nix /etc/nixos/configuration.nix
```


rebuild switch with:

```
# to upgrade
sudo nixos-rebuild switch --flake /etc/nixos#default --upgrade --impure
```

`--impure` is because sudo needs to read `/home/` subdirectories

nixos can't be symlinked because of:
https://github.com/NixOS/nix/issues/8013

## use flakes

```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha/flake.nix /etc/nixos/flake.nix
```

## diff the configurations

```
nvd diff /nix/var/nix/profiles/system-11-link /nix/var/nix/profiles/system-16-link
```
