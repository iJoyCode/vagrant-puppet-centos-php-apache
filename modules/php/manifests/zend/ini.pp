# Define: php::module::ini
#
# Configuration for optional PHP modules which are separately packaged.
# See also php::module for package installation.
#
# Sample Usage :
#  php::zend_module::ini { 'pecl-xdebug':
#      settings => {
#          'xdebug.remote_enable'      => 'on',
#          'xdebug.remote_handler' => 'dbgp',
#          'xdebug.remote_port'     => '9000',
#          'xdebug.remote_port'     => '9000',
#          'xdebug.remote_connect_back'     => 'on',
#      },
#      module_path => '/usr/lib64/php/modules/xdebug.so'
#  }
#  php::module::ini { 'xmlwriter': ensure => absent }
#
define php::zend::ini (
    $pkgname  = false,
    $settings = {},
    $module_path = undef,
    $ensure   = undef
) {

    # Strip 'pecl-*' prefix is present, since .ini files don't have it
    $modname = regsubst($title , '^pecl-', '', G)

    # Package name
    $rpmpkgname = $pkgname ? {
        false   => "php-${title}",
        default => "php-${pkgname}",
    }

    # INI configuration file
    file { "/etc/php.d/${modname}.ini":
        ensure  => $ensure,
        require => Package[$rpmpkgname],
        content => template('php/zend.ini.erb'),
    }
}

