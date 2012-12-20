class phpmyadmin::base {

    package { phpmyadmin:
        ensure => present,
        require => Package[php],
    }

    file{ phpmyadmin_config:
            path => "/var/www/localhost/htdocs/phpmyadmin/config.inc.php",
            source => [
                "puppet:///modules/site-phpmyadmin/${fqdn}/config.inc.php",
                "puppet:///modules/site-phpmyadmin/config.inc.php",
                "puppet:///modules/phpmyadmin/config.inc.php"
            ],
            ensure => file,
            owner => root,
            group => 0,
            mode => 0444,
            require => Package[phpmyadmin],
    }
}

