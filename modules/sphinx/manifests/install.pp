# Class: sphinx::install
#
#
class sphinx::install (
  $version,
  $unpack_root
) {

  include buildenv::c
	include buildenv::libs::mysql
	
	common::archive { "sphinx-${version}":
		ensure   => present,
		checksum => false,
		url      => "http://sphinxsearch.com/files/sphinx-${version}.tar.gz",
		timeout  => 600,
		target   => $unpack_root,
	}
	
	common::archive { 'libstemmer':
		ensure   => present,
		checksum => false,
		url      => "http://snowball.tartarus.org/dist/libstemmer_c.tgz",
		timeout  => 600,
		target   => "${unpack_root}/sphinx-${version}",
		notify   => Exec['configure-sphinx'],
		require	 => Common::Archive["sphinx-${version}"],
	}
	
	exec { 'configure-sphinx':
		command     => "${unpack_root}/sphinx-${version}/configure --with-libstemmer",
		cwd         => "${unpack_root}/sphinx-${version}",
		creates     => "${unpack_root}/sphinx-${version}/Makefile",
		refreshonly => true,
		notify		  => Exec['make-sphinx'],
		require     => [ Common::Archive['libstemmer'], Class['buildenv::c'], Class['buildenv::libs::mysql'] ],
	}

	exec { 'make-sphinx':
		command     => '/usr/bin/make',
		cwd         => "${unpack_root}/sphinx-${version}",
		creates     => "${unpack_root}/sphinx-${version}/src/searchd",
		refreshonly => true,
		notify		  => Exec['make-install-sphinx'],
		require     => Exec['configure-sphinx'],
	}

	exec { 'make-install-sphinx':
		command     => '/usr/bin/make install',
		cwd         => "/usr/src/sphinx-${version}",
		creates     => '/usr/local/bin/searchd',
		refreshonly => true,
		require     => Exec['make-sphinx'],
	}
}
