gh api /repos/abraunegg/onedrive/releases/latest
| from json
| get tarball_url
| curl -L $in
| save "onedrive.tar.gz"

tar xpvf onedrive.tar.gz
