# Class: sphinx
#
# This module manages sphinx
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class sphinx (
  $os_suffix          = $sphinx::params::os_suffix,
  $unpack_root        = $sphinx::params::unpack_root,
	$configdir          = $sphinx::params::configdir,
	$configfile         = $sphinx::params::configfile,
	$configfile_source  = $sphinx::params::configfile_source,
 	$configfile_content = $sphinx::params::configfile_content,
	$libdir             = $sphinx::params::libdir,
	$logdir             = $sphinx::params::logdir,
	$pidfile            = $sphinx::params::pidfile,
	$dbdir              = $sphinx::params::dbdir,
	$version            = $sphinx::params::version
) inherits sphinx::params {

  # Validate params. Fail early and fail hard
  if !$configfile_source and !$configfile_content {
    fail "Both configfile_source and configfile_content cannot be empty in module 'sphinx'"
  }
  
  if ($configfile_source and $configfile_content) {
    fail "Both configfile_source and configfile_content cannot be present in module 'sphinx'"
  }
  
  class { 'sphinx::install':
    version     => $version,
    unpack_root => $unpack_root,
  }
  
  class { 'sphinx::config':
    os_suffix          => $os_suffix,
    configdir          => $configdir,
    configfile         => $configfile,
    configfile_content => $configfile_content,
    configfile_source  => $configfile_source,
    libdir             => $libdir,
    logdir             => $logdir,
    pidfile            => $pidfile,
    dbdir              => $dbdir,
  }
  
  class { 'sphinx::service': }
  
  Class['sphinx::install'] -> Class['sphinx::config'] -> Class['sphinx::service']
}
