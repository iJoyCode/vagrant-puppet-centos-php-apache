define phpmyadmin::vhost(
  $ensure = 'present',
  $domainalias = 'absent',
  $ssl_mode = 'force',
  $run_mode = 'normal',
  $run_uid = 'absent',
  $run_gid = 'absent',
  $monitor_url = 'absent',
  $auth_method = 'http',
  $logmode = 'default'
){
  $documentroot = $operatingsystem ? {
    gentoo => '/var/www/localhost/htdocs/phpmyadmin',
    default => '/usr/share/phpMyAdmin'
  }

  if ($run_mode == 'fcgid'){
    if (($run_uid == 'absent') or ($run_gid == 'absent')) { fail("Need to configure \$run_uid and \$run_gid if you want to run Phpmyadmin::Vhost[${name}] as fcgid.") }

    user::managed{$name:
      ensure => $ensure,
      uid => $run_uid,
      gid => $run_gid,
      managehome => false,
      homedir => $documentroot,
      shell => $operatingsystem ? {
        debian => '/usr/sbin/nologin',
        ubuntu => '/usr/sbin/nologin',
        default => '/sbin/nologin'
      },
      before => Apache::Vhost::Php::Standard[$name],
    }
  }

  include ::phpmyadmin::vhost::absent_webconfig

  apache::vhost::php::standard{$name:
    ensure => $ensure,
    domainalias => $domainalias,
    manage_docroot => false,
    path => $documentroot,
    logpath => $operatingsystem ? {
      gentoo => '/var/log/apache2/',
      default => '/var/log/httpd'
    },
    php_settings => {
      'session.save_path' =>  "/var/www/session.save_path/${name}/",
      'upload_tmp_dir'    =>  "/var/www/upload_tmp_dir/${name}/",
      'open_basedir'      =>  "${documentroot}/:/etc/phpMyAdmin/:/var/www/upload_tmp_dir/${name}/:/var/www/session.save_path/${name}/",
    },
    logmode => $logmode,
    run_mode => $run_mode,
    run_uid => $name,
    run_gid => $name,
    manage_webdir => false,
    path_is_webdir => true,
    ssl_mode => $ssl_mode,
    template_partial => 'apache/vhosts/php/partial.erb',
    require => Package['phpMyAdmin'],
    mod_security => false,
  }
  
  if $run_mode == 'fcgid' {
    Apache::Vhost::Php::Standard[$name]{
      additional_options => "RewriteEngine On
RewriteRule .* - [E=REMOTE_USER:%{HTTP:Authorization},L]",  
    }
  }

  if $use_nagios {
    $real_monitor_url = $monitor_url ? {
      'absent' => $name,
      default => $monitor_url,
    }
    nagios::service::http{"${real_monitor_url}":
      ensure => $ensure,
      check_code => $auth_method ? {
        'http' => '401',
        default => 'OK'
      },
      ssl_mode => $ssl_mode,
    }
  }
}
