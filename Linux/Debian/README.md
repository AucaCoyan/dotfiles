# Automate your installation on Debian with a script

Download the `Install-master-script.sh` or run this script:

```bash
wget "https://raw.githubusercontent.com/AucaCoyan/dotfiles/main/Linux/Debian/Install-master-script.sh" --output-document=Install-master-script.sh
```

and run it with

```bash
chmod +x Install-master-script.sh
./Install-master-script.sh
```

If you have

```bash
<user> not in sudoers file
```

then:

```bash
su root
# write your password
```

edit `/etc/sudoers` with `nano`.

`vim` is not installed by default, only `vim-tiny` and it's _very_ awkward

```bash
nano /etc/sudoers
```

and add:

```bash
<username>   ALL=(ALL:ALL) ALL
```

After the installation it's only pending:

- add a nice wallpaper
- change the theme of Gnome Terminal to Catppuccin Mocha
- change login shell to `nushell`
- `gh auth login` and select browser

## Possible problems

nvim `:checkhealth` clipboard not found
In debian you can install `xclip` with:

sudo apt-get install xclip

## If you are in a VirtuaBox

You'll probably need clipboard sync, to copy and paste easily between machines

1. Insert the CD image (`Devices` menu / `Insert Guest additions CD image`)
2. run this

```bash
LINUX_HEADERS=$(uname -r)
sudo apt -y install gcc make bzip2 linux-headers-$LINUX_HEADERS
sudo mount /dev/cdrom /mnt
cd /mnt
sudo ./VBoxLinuxAdditions.run
```

## Debian minimal

Because sometimes I want the absolute minimum (for a VM for example) I did a
barebones script with _just enough_ to compile espanso

```bash
wget "https://raw.githubusercontent.com/AucaCoyan/dotfiles/main/Linux/Debian/Debian-minimal.sh" --output-document=Debian-minimal.sh
```

and run it with

```bash
chmod +x Debian-minimal.sh
./Debian-minimal.sh
```

| Feature                             | Debian-master | Debian-mini-espanso | Debian-OMV |
| ----------------------------------- | ------------- | ------------------- | ---------- |
| nala                                | ✅            | ✅                  | ❌         |
| git & git config                    | ✅            | ✅                  | ❌         |
| curl                                | ✅            | ✅                  | ❌         |
| gh                                  | ✅            | ❌                  | ❌         |
| brew                                | ✅            | ❌                  | ❌         |
| ~/repos                             | ✅            | ✅                  | ❌         |
| ~/other-repos                       | ✅            | ❌                  | ❌         |
| ~/other-repos/nu/nu_scripts         | ✅            | ❌                  | ❌         |
| ~/other-repos/nu/nupm               | ✅            | ❌                  | ❌         |
| nushell & symlink ~/.config/nushell | ✅            | ❌                  | ❌         |
| bat                                 | ✅            | ❌                  | ❌         |
| bat config                          | ✅            | ❌                  | ❌         |
| fd                                  | ✅            | ❌                  | ❌         |
| NerdFont                            | ✅            | ✅                  | ❌         |
| rust                                | ✅            | ✅                  | ❌         |
| fnm                                 | ✅            | ❌                  | ❌         |
| bun                                 | ✅            | ❌                  | ❌         |
| rye                                 | ✅            | ❌                  | ❌         |
| vs code                             | ✅            | ❌                  | ❌         |
| cargo-binstall                      | ✅            | ✅                  | ❌         |
| cargo-update                        | ✅            | ✅                  | ❌         |
| gitmoji-rs                          | ✅            | ❌                  | ❌         |
| bacon                               | ✅            | ❌                  | ❌         |
| tokei                               | ✅            | ❌                  | ❌         |
| gfold                               | ✅            | ❌                  | ❌         |
| qdirstat                            | ✅            | ❌                  | ❌         |
| biome                               | ✅            | ❌                  | ❌         |
| fzf                                 | ✅            | ❌                  | ❌         |
| glab                                | ✅            | ❌                  | ❌         |
| oh-my-posh                          | ✅            | ❌                  | ❌         |
| ripgrep                             | ✅            | ❌                  | ❌         |
| yazi                                | ✅            | ❌                  | ❌         |
| nvim                                | ✅            | ❌                  | ❌         |
