# modules/phpmyadmin/manifests/init.pp - manage phpmyadmin stuff
# Copyright (C) 2007 admin@immerda.ch
#

class phpmyadmin {
    case $operatingsystem {
        gentoo: { include phpmyadmin::gentoo }
        centos: { include phpmyadmin::centos }
        default: { include phpmyadmin::base }
    }
}
