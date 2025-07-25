# nixOS setup

## Setup

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


nixos can't be symlinked because of:
https://github.com/NixOS/nix/issues/8013

### if you use flakes

```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha/flake.nix /etc/nixos/flake.nix
```

## Update

```
sudo nixos-rebuild switch --flake /etc/nixos#default --upgrade --impure
```

`--impure` is because sudo needs to read `/home/` subdirectories

Update the flakes with

```
nix flake update
```

with `nh`

```
nh os switch . --hostname default --update
```

## Cleanup

You can clean the repositories with

```
nh clean user
```

## Diff the generations

See the history of changes

```
nvd history
```

Or compare two specific gens

```
nvd diff /nix/var/nix/profiles/system-11-link /nix/var/nix/profiles/system-16-link
```

