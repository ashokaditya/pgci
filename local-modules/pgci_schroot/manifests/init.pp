define pgci_schroot ($release = $title, $mirror = 'http://httpredir.debian.org/debian') {
  include pgci_schroot::prereqs
  Class['pgci_schroot::prereqs'] -> Pgci_schroot["$title"]

  exec {
    "debootstrap-$release":
      command => "/usr/sbin/debootstrap --include=lsb-release,puppet $release /srv/chroot/pgci-$release $mirror",
      creates => "/srv/chroot/pgci-$release",
      logoutput => true,
      timeout => 0,
      require => Package['debootstrap'],
  }

  file {
    "/etc/schroot/chroot.d/pgci-$release":
      ensure => present,
      content => template('pgci_schroot/schroot.erb');
    "/srv/chroot/pgci-$release/etc/facter":
      ensure => directory,
      require => Exec["debootstrap-$release"];
    "/srv/chroot/pgci-$release/etc/facter/facts.d":
      ensure => directory;
    "/srv/chroot/pgci-$release/etc/facter/facts.d/chroot.txt":
      ensure => present,
      content => "is_chroot=true\n";
  }

  exec {
    "puppet-recursive-$release":
      # Need to set locale so that (sub-)puppet does not complain.
      # Puppet only runs in UTF-8 locales.  Need to set locale in this
      # weird way because (super-)puppet will reset locale environment
      # before running exec command.
      command => "LC_ALL=en_US.UTF-8 /usr/bin/schroot -c pgci-$release -d /srv/pgci -- puppet apply --modulepath=modules/ -e 'include pgci_build_deps'",
      provider => shell,
      logoutput => true,
      timeout => 0,
      require => [
                  Exec["debootstrap-$release"],
                  File["/etc/schroot/chroot.d/pgci-$release",
                       "/srv/chroot/pgci-$release/etc/facter/facts.d/chroot.txt"],
                  ],
  }
}
