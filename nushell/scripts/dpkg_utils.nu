# available packages (`sudo apt upgrade` list)
export const PKG_AVAILABLE_PATH = '/var/lib/dpkg/available'
# sample
# $ bat $PKG_AVAILABLE_PATH
#
# Package: whiptail
# Source: newt (0.52.23-1)
# Version: 0.52.23-1+b1
# Installed-Size: 57
# Maintainer: Alastair McKinstry <mckinstry@debian.org>
# Architecture: amd64
# Depends: libc6 (>= 2.34), libnewt0.52 (>= 0.52.23), libpopt0 (>= 1.14), libslang2 (>= 2.2.4)
# Description: Displays user-friendly dialog boxes from shell scripts
# Description-md5: 845a08009ef9f0ef4ecc0aedd3a36ffa
# Multi-Arch: foreign
# Homepage: https://pagure.io/newt
# Tag: implemented-in::c, interface::TODO, interface::text-mode, role::program,
#  scope::utility, use::viewing
# Section: utils
# Priority: important
# Filename: pool/main/n/newt/whiptail_0.52.23-1+b1_amd64.deb
# Size: 24228
# MD5sum: beb813196711eb33ab02e83258f39915
# SHA256: 61f7b57a599d1655d4866f5119c5274505cdd619c71b1c1c2b79b603b32f55ca

# history
export const PKG_HISTORY_PATH =  '/var/log/apt/history.log'
# doesn't have all entries, just a couple of days
