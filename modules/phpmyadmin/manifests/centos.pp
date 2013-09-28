class phpmyadmin::centos inherits phpmyadmin::base {
    Package[phpmyadmin]{
        name => 'phpMyAdmin',
        require => Package[php],
    }

    File[phpmyadmin_config]{
        path => '/etc/phpMyAdmin/config.inc.php',
    }
}
