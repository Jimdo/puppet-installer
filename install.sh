#!/bin/bash
#/ Install a specific or the latest version of Puppet
#/ Usage: install.sh [-v <Puppet version>]

set -e
set -o pipefail

version=

while test "$#" -ne 0; do
    case "$1" in
    -h|--h|--he|--hel|--help)
        grep '^#/' <"$0" | cut -c4-; exit 0 ;;
    -v|--v|--ve|--ver|--vers|--versi|--versio|--version)
        version=$2; shift 2 ;;
    --)
        shift; break ;;
    -|[!-]*)
        break ;;
    -*)
        echo >&2 "error: invalid option '$1'"; exit 1 ;;
    esac
done

current=$(apt-cache policy puppet | awk '/Installed:/ {print $2}' 2>/dev/null)
if test "$current" = "$version"; then
    echo "Puppet version $version already installed."
    exit 0
fi

echo "==> Removing any Puppet gem installations ..."
gem uninstall -a -x puppet facter 2>/dev/null || true

echo "==> Installing Puppet release package ..."
distro=$(lsb_release -cs)
pkg="puppetlabs-release-$distro.deb"
wget -q "https://apt.puppetlabs.com/$pkg"
dpkg -i "$pkg"

if test -n "$version"; then
    echo "==> Pinning version to $version ..."
    cat >/etc/apt/preferences.d/puppet <<EOF
Package: puppet puppet-common
Pin: version $version
Pin-Priority: 1001
EOF
fi

echo "==> Installing Puppet version $version ..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install --yes --force-yes puppet
