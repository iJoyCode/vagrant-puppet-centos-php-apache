include pear

pear::package { "PEAR": }
pear::package { "Console_Table": }

pear::package { "uploadprogress":
  repository => "pecl.php.net",
  require => Pear::Package['PEAR']
}