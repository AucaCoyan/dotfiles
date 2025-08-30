# nixOS setup

nixOS is a complicated beast, but I still firmly believe it's the best OS for my usecase.

You can customize as far as you want with OS configurations, software, themes, and even
stuff like firefox configs, plugins of neovim or extensions of vs code.

This doesn't mean you _need_ to config everything. You certainly can, but it's also
an enormous load of work I'm not ready to take. The main reason for this is because
no matter how specific you can get with your nix declarative approach, you will most
certainly need to config the same in other operative systems, making the declarative
just a special case for just 1 of your OS I use (in this case, Windows, Debian, macOS
and nixOS).

## What is left out as "impure" in this config?

- **any type of passwords**: the best protection against a hack is... keeping it simple.
This includes the user password, wifi and network passwords are not declared in the config.
- **complex configs of cross-platform software**. KDE, VS Code, neovim, except some basics,
they have a different config file that is compatible in other OSes.

## Setup

Start with a basic installation of nixOS, and then:

- copy sections of the `configuration.nix` you want. Or the entire file if you are
corageous.

- when you are ready, create a symbolic links with

`Mocha`

```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha/configuration.nix /etc/nixos/configuration.nix
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/Mocha/flake.nix /etc/nixos/flake.nix
```

`thanos`

```
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/thanos/configuration.nix /etc/nixos/configuration.nix
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/thanos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
# ln --symbolic --force --no-dereference ~/repos/dotfiles/Linux/nixOS/hosts/thanos/flake.nix /etc/nixos/flake.nix
```

/etc/nixos folder can't be symlinked because of [this issue](https://github.com/NixOS/nix/issues/8013)


- run `sudo nixos-rebuild switch` and hope for the best

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

- delete ALL generations with

```
sudo nix-collect-garbage -d
```

