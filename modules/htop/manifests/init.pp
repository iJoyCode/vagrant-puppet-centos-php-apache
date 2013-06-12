# == Class: htop
#
# Installs htop
#
# === Examples
#
#  class { 'htop': }
#
# === Authors
#
# Rich Leland <richard_leland@discovery.com>
#
# === Copyright
#
# Copyright 2013 Discovery Communications, Inc.
#
class htop {
  package {'htop':
    ensure => installed,
  }
}
