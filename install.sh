#!/bin/sh
#/ Install a specific version of Puppet
#/ Usage: install.sh -v <Puppet version>

set -e

VERSION=

while test "$#" -ne 0; do
    case "$1" in
    -h|--h|--he|--hel|--help)
        grep '^#/' <"$0" | cut -c4-; exit 0 ;;
    -v|--v|--ve|--ver|--vers|--versi|--versio|--version)
        VERSION=$2; shift 2 ;;
    --)
        shift; break ;;
    -|[!-]*)
        break ;;
    -*)
        echo >&2 "error: invalid option '$1'"; exit 1 ;;
    esac
done

# TODO: make version optional
test -n "$VERSION" || { echo >&2 "error: version required"; exit 1; }

DISTRO=$(lsb_release -cs)
PACKAGE="puppetlabs-release-$DISTRO.deb"

CURRENT=$(apt-cache policy puppet | awk '/Installed:/ {print $2}' 2>/dev/null)
if test "$CURRENT" = "$VERSION"; then
    echo "Puppet version $VERSION already installed."
    exit 0
fi

echo "Removing any Puppet gem installations ..."
gem uninstall -a -x puppet facter 2>/dev/null || true

echo "Installing Puppet version $VERSION ..."
wget -q "https://apt.puppetlabs.com/$PACKAGE"
dpkg -i "$PACKAGE"
apt-get update
apt-get install -y "puppet=$VERSION"
