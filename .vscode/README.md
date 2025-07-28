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
ln ~/repos/dotfiles/.vscode/settings.json  ~/repos/dotfiles/.vscode/extensions.json ~/repos/dotfiles/.vscode/keybindings.json ~/repos/dotfiles/.vscode/tasks.json '/Users/aucamaillot/Library/Application Support/Code/User/'
```
