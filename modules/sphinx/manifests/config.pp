# Class: sphinx::config
#
#
class sphinx::config (
  $os_suffix,
  $configdir,
  $configfile,
  $configfile_content,
  $configfile_source,
  $libdir,
  $logdir,
  $pidfile,
  $dbdir
) {

  if $configfile_content {
    $real_configfile_content = $configfile_content
  } else {
    $real_configfile_source = $configfile_source
  }

  file { '/etc/init.d/sphinxsearch':
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		content => template("sphinx/init.${os_suffix}.erb"),
		notify  => Class['sphinx::service'],
		require => Class['sphinx::install'],
	}
	
	file { $configdir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		require => Class['sphinx::install'],
	}
	
	file { $configfile:
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => $real_configfile_content,
		source  => $real_configfile_source,
		require => File[$configdir],
	}
	
	file { $libdir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		require => Class['sphinx::install'],
	}
	
	file { $logdir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		require => Class['sphinx::install'],
	}
	
	file { $dbdir:
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		require => File[$sphinx::params::libdir],
	}
}
