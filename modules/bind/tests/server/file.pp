include bind::server
bind::server::file { 'example.com':
    source => 'puppet:///modules/bind/named.empty',
}
