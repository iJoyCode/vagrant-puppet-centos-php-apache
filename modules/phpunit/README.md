# Puppet module: phpunit

Puppet module for installing the PHPUnit unit testing framework's PHAR package.

Made by [Andrew Kandels](http://andrewkandels.com/)

GitHub: https://github.com/andrew-kandels/puppet-phpunit

Released under the terms of the BSD-2 license.

## Simple Usage

```
    class { 'phpunit': }
```

## Advanced Usage (complete options list)

```
    class { 'phpunit':
        phar_uri     => 'https://phar.phpunit.de/phpunit.phar',
        install_path => '/usr/local/bin/phpunit',
    }
```

## Uninstalling PHPUnit

```
    class { 'phpunit':
        ensure => absent,
    }
```
