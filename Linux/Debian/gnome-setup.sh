# gnome setup

# setup dark theme in Debian
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

# Install catppuccin themes in Gnome Terminal
curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v0.2.0/install.py | python3 -
## Set Ctrl Tab to change tabs
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Tab'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary><Shift>Tab'
