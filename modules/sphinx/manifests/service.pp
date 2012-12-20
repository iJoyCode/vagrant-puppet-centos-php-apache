# Class: sphinx::service
#
#
class sphinx::service {
  service { 'sphinxsearch':
		ensure     => running,
		enable     => true,
		hasstatus  => true,
		hasrestart => true,
		require    => Class['sphinx::config'],
	}
}
