Redis Module for Puppet
=======================
[![Build Status](https://secure.travis-ci.org/fsalum/puppet-redis.png)](http://travis-ci.org/fsalum/puppet-redis)

This module installs and manages a Redis server. All redis.conf options are
accepted in the parameterized class.

Important
---------

If you are upgrading this module from 0.x to 1.0+, please test it carefully 
outside production as it is not fully backwards compatible.

Some class parameters were added, removed or had their default values changed.

The redis.conf template has been completely rewritten to support Redis 2.2+ to 2.8+.

Operating System
----------------

Tested on CentOS 6.5, Ubuntu Saucy/Trusty/Precise, Debian 7.4  
redis.conf options compatible with Redis 2.2, 2.4, 2.6, 2.8  

Quick Start
-----------

Use the default parameters:

    class { 'redis': }

To change the port and listening network interface:

    class { 'redis':
      conf_port => '6379',
      conf_bind => '0.0.0.0',
    }

Parameters
----------

Check the [init.pp](https://github.com/fsalum/puppet-redis/blob/master/manifests/init.pp) file for a complete list of parameters accepted.

* custom sysctl

To enable and set important Linux kernel sysctl parameters as described in the [Redis Admin Guide](http://redis.io/topics/admin) - use the following configuration option:

    class { 'redis':
      system_sysctl => true
    }

By default, this sysctl parameter will not be enabled. Furthermore, you will need the sysctl module defined in the [Modulefile](https://github.com/fsalum/puppet-redis/blob/master/Modulefile) file.

* service restart

If you need to execute a controlled restart of redis after changes due master/slave relationships to avoid that both are restarted at the same time use the parameter below.

    class { 'redis':
      service_restart => false
    }

By default service restart is true.

Copyright and License
---------------------

Copyright (C) 2012 Felipe Salum

Felipe Salum can be contacted at: fsalum@gmail.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
