# Git scripts

## git search script

Alias for `git log -S` (the pickaxe search).
It works on all shells, given git looks for scripts called `git-*` in path and
adds them to the cmd

Caveats:

- It doesn't have a way to filter by folder. It looks in the entire repository.
- The script in path needs to be extension-less: `git-search` not `git-search.sh`

Install instructions:

macOS

```bash
ln -s /Users/aucamaillot/repos/dotfiles/.config/git-scripts/git-search.sh /Users/aucamaillot/.local/bin/git-search
chmod +x /Users/aucamaillot/repos/dotfiles/.config/git-scripts/git-search.sh
which git-search       # should resolve to the symlink
```
