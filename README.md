# Puppet Installer

`install.sh` installs a specific or the latest version of Puppet on Debian-based
systems. It was inspired by [Omnibus Installer].

The script's primary use case is to install Puppet inside a Vagrant machine
just before provisioning.

For example:

```ruby
Vagrant::Config.run do |config|
  config.vm.box = "some-debian-box"
  # ...

  puppet_version = "3.7.0-1puppetlabs1"
  config.vm.provision :shell, :inline => "curl -Ls https://raw.githubusercontent.com/Jimdo/puppet-installer/master/install.sh | bash -s -- -v #{puppet_version}"

  config.vm.provision :puppet do |puppet|
    # ...
  end
end
```

To install the latest version, simply omit the `-v` option.

[Omnibus Installer]: https://docs.getchef.com/install_omnibus.html
