# Taken from the "Sample Usage :"
include bind::server
bind::server::conf { '/etc/named.conf':
    acls => {
        'rfc1918' => [ '10/8', '172.16/12', '192.168/16' ],
    },
    masters => {
        'mymasters' => [ '192.0.2.1', '198.51.100.1' ],
    },
    zones => {
        'example.com' => [
            'type master',
            'file "example.com"',
        ],
        'example.org' => [
            'type slave',
            'file "slaves/example.org"',
            'masters { mymasters; }',
        ],
    },
    includes => [
        '/etc/myzones.conf',
    ],
}

