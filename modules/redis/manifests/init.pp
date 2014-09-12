# == Class: redis
#
# Install and configure a Redis server
#
# === Parameters
#
# All the redis.conf parameters can be passed to the class.
# See below for a complete list of parameters accepted.
#
# Check the README.md file for any further information about parameters for this class.
#
# === Examples
#
#  class { redis:
#    conf_port => '6380',
#    conf_bind => '0.0.0.0',
#  }
#
# === Authors
#
# Felipe Salum <fsalum@gmail.com>
#
# === Copyright
#
# Copyright 2013 Felipe Salum, unless otherwise noted.
#
class redis (
  $conf_activerehashing                   = 'yes',
  $conf_aof_rewrite_incremental_fsync     = 'yes', # 2.6+
  $conf_append                            = {}, # hash of custom variables+values
  $conf_appendfilename                    = undef, # default appendonly.aof
  $conf_appendfsync                       = 'everysec',
  $conf_appendonly                        = 'no',
  $conf_auto_aof_rewrite_min_size         = '64mb',
  $conf_auto_aof_rewrite_percentage       = '100',
  $conf_bind                              = '0.0.0.0',
  $conf_client_output_buffer_limit_normal = '0 0 0', # 2.6+
  $conf_client_output_buffer_limit_pubsub = '32mb 8mb 60', # 2.6+
  $conf_client_output_buffer_limit_slave  = '256mb 64mb 60', # 2.6+
  $conf_daemonize                         = 'yes',
  $conf_databases                         = '16',
  $conf_dbfilename                        = 'dump.rdb',
  $conf_dir                               = '/var/lib/redis/',
  $conf_glueoutputbuf                     = undef,
  $conf_hash_max_zipmap_entries           = '512',
  $conf_hash_max_zipmap_value             = '64',
  $conf_hll_sparse_max_bytes              = undef, # default 3000, 2.8.5?+
  $conf_hz                                = '10', # 2.6+
  $conf_include                           = [], # array of custom include files
  $conf_list_max_ziplist_entries          = '512',
  $conf_list_max_ziplist_value            = '64',
  $conf_logfile                           = undef, #default ""
  $conf_loglevel                          = 'notice',
  $conf_lua_time_limit                    = '5000', # 2.6+
  $conf_masterauth                        = undef,
  $conf_maxclients                        = undef, # default 10000 in 2.6+
  $conf_maxmemory                         = undef,
  $conf_maxmemory_policy                  = undef,
  $conf_maxmemory_samples                 = undef,
  $conf_min_slaves_max_lag                = undef, # default 10, 2.8+
  $conf_min_slaves_to_write               = undef, # 2.8+
  $conf_no_appendfsync_on_rewrite         = 'no',
  $conf_nosave                            = undef,
  $conf_notify_keyspace_events            = undef, # 2.8+
  $conf_pidfile                           = undef,
  $conf_port                              = '6379',
  $conf_rdbchecksum                       = 'yes', # 2.6+
  $conf_rdbcompression                    = 'yes',
  $conf_repl_backlog_size                 = '1mb', # 2,8+
  $conf_repl_backlog_ttl                  = '3600', # 2.8+
  $conf_repl_disable_tcp_nodelay          = 'no', # 2,6+
  $conf_repl_ping_slave_period            = '10', # 2.4+
  $conf_repl_timeout                      = '60', # 2.4+
  $conf_requirepass                       = undef,
  $conf_save                              = {"900" =>"1", "300" => "10", "60" => "10000"},
  $conf_set_max_intset_entries            = '512',
  $conf_slave_priority                    = undef, # 2.6+
  $conf_slave_read_only                   = 'yes', # 2.6+
  $conf_slave_serve_stale_data            = 'yes',
  $conf_slaveof                           = undef,
  $conf_slowlog_log_slower_than           = '10000',
  $conf_slowlog_max_len                   = '128',
  $conf_stop_writes_on_bgsave_error       = 'yes', # 2.6+
  $conf_syslog_enabled                    = undef,
  $conf_syslog_facility                   = undef,
  $conf_syslog_ident                      = undef,
  $conf_tcp_backlog                       = undef, # default is 511, 2.8.5+
  $conf_tcp_keepalive                     = '0', # 2.6+
  $conf_timeout                           = '0',
  $conf_unixsocket                        = '/tmp/redis.sock', # 2.2+
  $conf_unixsocketperm                    = '755', # 2.4+
  $conf_vm_enabled                        = 'no', # deprecated in 2.4+
  $conf_vm_max_memory                     = '0', # deprecated in 2.4+
  $conf_vm_max_threads                    = '4', # deprecated in 2.4+
  $conf_vm_page_size                      = '32', # deprecated in 2.4+
  $conf_vm_pages                          = '134217728', # deprecated in 2.4+
  $conf_vm_swap_file                      = '/tmp/redis.swap', # deprecated in 2.4+
  $conf_zset_max_ziplist_entries          = '128', # 2.4+
  $conf_zset_max_ziplist_value            = '64', # 2.4+
  $package_ensure                         = 'present',
  $service_enable                         = true,
  $service_ensure                         = 'running',
  $service_restart                        = true,
  $system_sysctl                          = false,
) {

  include redis::params

  $conf_redis     = $redis::params::conf
  $conf_logrotate = $redis::params::conf_logrotate
  $package        = $redis::params::package
  $service        = $redis::params::service

  if $conf_pidfile {
    $conf_pidfile_real = $conf_pidfile
  }else{
    $conf_pidfile_real = $::redis::params::pidfile
  }

  if $conf_logfile {
    $conf_logfile_real = $conf_logfile
  }else{
    $conf_logfile_real = $::redis::params::logfile
  }

  package { 'redis':
    ensure => $package_ensure,
    name   => $package,
  }

  service { 'redis':
    ensure     => $service_ensure,
    name       => $service,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => [ Package['redis'],
                    Exec[$conf_dir],
                    File[$conf_redis] ],
  }

  file { $conf_redis:
    path    => $conf_redis,
    content => template('redis/redis.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['redis'],
  }

  file { $conf_logrotate:
    path    => $conf_logrotate,
    content => template('redis/redis.logrotate.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
  }

  exec { $conf_dir:
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    command => "mkdir -p ${conf_dir}",
    user    => root,
    group   => root,
    creates => $conf_dir,
    before  => Service['redis'],
    require => Package['redis'],
  }

  file { $conf_dir:
    ensure  => directory,
    owner   => redis,
    group   => redis,
    mode    => '0755',
    before  => Service['redis'],
    require => Exec[$conf_dir],
  }

  if ( $system_sysctl == true ) {
    # add necessary kernel parameters
    # see the redis admin guide here: http://redis.io/topics/admin
    sysctl { 'vm.overcommit_memory':
      value     => '1',
    }
  }

  if $service_restart == true {
    # https://github.com/fsalum/puppet-redis/pull/28
    Exec[$conf_dir] ~> Service['redis']
    File[$conf_redis] ~> Service['redis']
  }

}
