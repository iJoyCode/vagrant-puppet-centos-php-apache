# Class: bind::server
#
# Install and enable an ISC BIND server.
#
# Parameters:
#  $chroot:
#   Enable chroot for the server. Default: true
#  $bindpkgprefix:
#   Package prefix name. Default: 'bind'
#
# Sample Usage :
#  include bind::server
#
#  class { 'bind::server':
#      chroot        => false,
#      bindpkgprefix => 'bind97',
#  }
#
class bind::server (
    $chroot = true,
    # For RHEL5 you might want to use 'bind97'
    $bindpkgprefix = 'bind'
) {

    # Main package and service it provides
    $bindserverpkgname = $chroot ? {
        true  => "${bindpkgprefix}-chroot",
        false => "${bindpkgprefix}",
    }
    package { $bindserverpkgname: ensure => installed }
    service { 'named':
        require   => Package[$bindserverpkgname],
        hasstatus => true,
        enable    => true,
        ensure    => running,
        restart   => '/sbin/service named reload',
    }

    # We want a nice log file which the package doesn't provide a location for
    $bindlogdir = $chroot ? {
        true  => '/var/named/chroot/var/log/named',
        false => '/var/log/named',
    }
    file { $bindlogdir:
        require => Package[$bindserverpkgname],
        ensure  => directory,
        owner   => 'root',
        group   => 'named',
        mode    => '0770',
        seltype => 'named_log_t',
    }

}

