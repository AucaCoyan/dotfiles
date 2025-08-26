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

Delete unused packages of non-existing generations with
```
nix-store --gc
```

You can clean the repositories with

```
nh clean user
# try also with
nh clean all --keep 5
```

And to clean older generations you need sudo permissions:

```
sudo nix-collect-garbage --delete-old
```

## Generations

- List the numbers with

```
ls /nix/var/nix/profiles/system-* -l
```

- Diff between the generations

```
nvd history
```

- Or compare two specific generations

```
nvd diff /nix/var/nix/profiles/system-11-link /nix/var/nix/profiles/system-16-link
```

- delete a generation with 

```
nix-env --delete-generations 10 11 14
```