# Class: phpunit
#
# Puppet module for installing the PHPUnit unit testing framework's PHAR package. 
#
# Parameters:
#   [*phar_uri*]
#     Path in which to download the PHPUnit PHAR package from.
#     Default: https://phar.phpunit.de/phpunit.phar
#
#   [*ensure*]
#     Whether PHPUnit should be installed.
#     Default: present
#
#   [*install_path*]
#     Where to install the PHAR package on the local filesystem.
#     Default: /usr/local/bin/phpunit
#
#   [*timeout*]
#     How long to wait for the wget download of the PHAR package.
#     Default: 30
#
# Actions:
#   Installs the PHAR package to the local filesystem and makes it executable.
#
# Requires:
#   Nothing
#
# Sample Usage:
#   class { 'phpunit':
#       phar_uri     => 'https://phar.phpunit.de/phpunit.phar',
#       install_path => '/usr/local/bin',
#       ensure       => present,
#       timeout      => 30,
#   }
#
# [Remember: No empty lines between comments and class definition]
class phpunit(
  $phar_uri = 'https://phar.phpunit.de/phpunit.phar',
  $install_path = '/usr/local/bin/phpunit',
  $timeout = 30,
  $ensure = 'present',
) inherits phpunit::params {

  case $ensure {
    /(present)/: {
      include wget

      wget::fetch { 'phpunit-phar-wget':
        source      => $phar_uri,
        destination => $install_path,
        timeout     => $timeout,
        verbose     => false,
        require     => Package[$package],
      }

      file { 'phpunit-phar':
        ensure  => $ensure,
        mode    => 'a+x',
        path    => $install_path,
        require => Wget::Fetch['phpunit-phar-wget'],
      }
    }
    /(absent)/: {
      file { 'phpunit-phar':
        ensure => $package_ensure,
      }
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }
}
