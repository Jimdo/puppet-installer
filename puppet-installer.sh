#!/bin/sh
# Helper script to install a specific version of Puppet
# Usage: puppet-installer.sh <Puppet version>

set -e

VERSION=$1
DISTRO=$(lsb_release -cs)
PACKAGE="puppetlabs-release-$DISTRO.deb"

CURRENT=$(apt-cache policy puppet | awk '/Installed:/ {print $2}' 2>/dev/null)
if test "$CURRENT" = "$VERSION"; then
    echo "Puppet version $VERSION already installed."
    exit 0
fi

echo "Removing any Puppet gem installations ..."
sudo gem uninstall -a -x puppet facter 2>/dev/null || true

echo "Installing Puppet version $VERSION ..."
wget -q "https://apt.puppetlabs.com/$PACKAGE"
sudo dpkg -i "$PACKAGE"
sudo apt-get update
sudo apt-get install -y "puppet=$VERSION"
