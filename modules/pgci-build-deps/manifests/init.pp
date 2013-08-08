class pgci-build-deps {

  $build_deps = [ 'bison',
                  'clang',
                  'flex',
                  'g++',
                  'gcc',
                  'gettext',
                  'libedit-dev',
                  'libkrb5-dev',
                  'libldap2-dev',
                  'libossp-uuid-dev',
                  'libpam0g-dev',
                  'libperl-dev',
                  'libreadline-dev',
                  'libssl-dev',
                  'libxml2-dev',
                  'libxslt1-dev',
                  'zlib1g-dev',
                  'make',
                  'perl',
                  'python-dev',
                  'python3-dev',
                  'systemtap-sdt-dev',
                  'tcl-dev',

                  'lcov',

                  'dbtoepub',
                  'docbook',
                  'docbook2x',
                  'docbook-dsssl',
                  'docbook-xsl',
                  'fop',
                  'jadetex',
                  'openjade1.3',
                  'opensp',
                  'texinfo',
                  'xsltproc',

                  'curl',
                  'python-docutils', # for pghashlib
                  'time',
                  'wget',
                  ]

  package {
    $build_deps:
      ensure => latest;

    'ccache':
      ensure => installed;
  }


  if $lsbdistcodename == 'squeeze' {
    apt::pin { 'squeeze-backports':
      packages => ['fop', 'libfop-java'],
      priority => 500,
      before => Package['fop'],
    }
  }


  file { ['/etc/texmf', '/etc/texmf/texmf.d']:
    ensure => directory,
  }

  file { '/etc/texmf/texmf.d/96JadeTeX.cnf':
    ensure => present,
    source => 'puppet:///modules/pgci-build-deps/jadetex.cnf',
    owner => root,
    group => root,
    notify => Exec['update-texmf'],
    require => Package['jadetex'],
  }

  exec { 'update-texmf':
    path => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    refreshonly => true,
  }

}
