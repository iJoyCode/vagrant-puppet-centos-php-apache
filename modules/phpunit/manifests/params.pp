class phpunit::params {
  # Common

  case $::osfamily {
    'Debian': {
      $package = 'php5-cli'
    }
    'RedHat': {
      $package = 'php-cli'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
