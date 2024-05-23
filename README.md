<div align="center">

# my dotfiles

My config files

![GitHub repo size](https://img.shields.io/github/repo-size/AucaCoyan/dotfiles)
![Lines of code](https://img.shields.io/tokei/lines/github/AucaCoyan/dotfiles)

[![Linux](https://svgshare.com/i/Zhy.svg)](https://svgshare.com/i/Zhy.svg)
[![Windows](https://badgen.net/badge/icon/windows?icon=windows&label)](https://badgen.net/badge/icon/windows?icon=windows&label)

![GitHub last commit](https://img.shields.io/github/last-commit/AucaCoyan/dotfiles)
![GitHub](https://img.shields.io/github/license/AucaCoyan/dotfiles)

[Files](#features) •
[Walkthrough](#walkthrough) •
[Contributing](#contributing)

</div>

# Why is this on version control?

It takes a bunch of time to config everything (and I change it pretty often), so
I versioned the config files to `git clone` and get up and running easily.
In addition, I developed a series of scritps to install in a barebones OS
(Windows and Debian Linux) so I can break everything that the worse case scenario
is to run a script and have a new machine in less than half an hour.

Copy and paste any content as much as you like!

# General rundown

`Windows` and `Linux` are for exclusive scripts (installation and some apps). I
generally want to develop as much as I can in the `.config` and `nushell`
folders. Those can be symlinked into every OS and usually are crossplatform apps.

# Cross platform packages

In windows almost everything is managed by `scoop`, but I still have some CLI
apps that are isolated in its own managers:

- For npm packages, list all the globals with:

  `npm list -g --depth=0`

- cargo has its own packages, so list them with:

  `cargo install --list`

- For python packages, I use [`pipx`](https://github.com/pypa/pipx) (black, mypy, flake8, all-repos & pipenv)
  you can get the current `pipx` packages with

  `pipx list`

  _Tip: If you don't find `pipx` on PowerShell, try to add manually to PATH_. [Source](https://stackoverflow.com/questions/69686581/the-term-pipx-is-not-recognized-as-the-name-of-a-cmdlet)

  Probably it will be that this is not in PATH.

  ```
  C:\Users\aucac\AppData\Roaming\Python\Python311\Scripts
  ```

# Enviromnent apps

I like to have everything in its own little isolated box. So the boys don't play
hard on each other. I use [`pyenv`](https://github.com/pyenv/pyenv) and
[`pyenv-win`](https://github.com/pyenv-win/pyenv-win) to manage Python.
[`fnm`](https://github.com/Schniz/fnm) to manage NodeJS.

# Walkthrough

Follow [this](https://www.atlassian.com/git/tutorials/dotfiles) tutorial to start
backing up your dotfiles and to install them on a new system
