# VS Code Configuration

In windows:

```nushell
cd ~/scoop/persist/vscode/data/user-data/
mv User\ User.backup\
new-junction ./User ~/repos/dotfiles/.vscode
```

In linux:

```nushell
cd ~/.config/Code
mv User/ User.backup/
new-junction ./User ~/repos/dotfiles/.vscode
```
