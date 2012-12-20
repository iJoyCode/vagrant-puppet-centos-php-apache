class phpmyadmin::vhost::absent_webconfig {
  include ::phpmyadmin
  file{'/etc/httpd/conf.d/phpMyAdmin.conf':
    ensure => absent,
    require => Package['phpmyadmin'],
    notify => Service['apache'],
  }
}
