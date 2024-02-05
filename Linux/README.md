# Automate your installation on Debian with a script

run this script

```bash
wget "https://raw.githubusercontent.com/AucaCoyan/dotfiles/main/Linux/Install-master-script.sh" --output-document=Install-master-script.sh
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

`vim` is not installed by default, only `vi` and it's _very_ awkward

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
