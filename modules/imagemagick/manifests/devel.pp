class imagemagick::devel {
  package{"ImageMagick-devel.${architecture}":
    ensure => present,
  }
}