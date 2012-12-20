puppet-memcached
================

A puppet module to install and configure memcached on a node.

It defaults to the usual memcached configuration settings but they can all be changed
by passing the parameters to the class:

class { "memcached":
   memcached_port => '11211',
   maxconn        => '2048',
   cachesize      => '20000',
}
