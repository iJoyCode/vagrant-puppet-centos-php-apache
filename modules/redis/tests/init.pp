node default {

  case $::osfamily {
    'RedHat': {
      package { 'epel-release':
        ensure   => present,
        source   => 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm',
        provider => rpm,
        before   => Class['redis'],
      }
    }
    'Debian': {
      # redis is on repository
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }

  class { 'redis':
    conf_activerehashing                   => 'yes',
    conf_aof_rewrite_incremental_fsync     => 'yes', # 2.6+
    conf_appendfilename                    => 'appendonly.aof',
    conf_appendfsync                       => 'everysec',
    conf_appendonly                        => 'no',
    conf_auto_aof_rewrite_min_size         => '64mb',
    conf_auto_aof_rewrite_percentage       => '100',
    conf_bind                              => '0.0.0.0',
    conf_client_output_buffer_limit_normal => '0 0 0', # 2.6+
    conf_client_output_buffer_limit_pubsub => '32mb 8mb 60', # 2.6+
    conf_client_output_buffer_limit_slave  => '256mb 64mb 60', # 2.6+
    conf_daemonize                         => 'yes',
    conf_databases                         => '16',
    conf_dbfilename                        => 'dump.rdb',
    conf_dir                               => '/var/lib/redis/',
    conf_glueoutputbuf                     => undef,
    conf_hash_max_zipmap_entries           => '512',
    conf_hash_max_zipmap_value             => '64',
    conf_hll_sparse_max_bytes              => undef, # default 3000 in 2.8+
    conf_hz                                => '10', # 2.6+
    conf_include                           => undef,
    conf_list_max_ziplist_entries          => '512',
    conf_list_max_ziplist_value            => '64',
    conf_logfile                           => '',
    conf_loglevel                          => 'notice',
    conf_lua_time_limit                    => '5000', # 2.6+
    conf_masterauth                        => undef,
    conf_maxclients                        => '128', # default 10000 in 2.6+
    conf_maxmemory                         => undef,
    conf_maxmemory_policy                  => undef,
    conf_maxmemory_samples                 => undef,
    conf_min_slaves_max_lag                => '10', # default 10, 2.8+
    conf_min_slaves_to_write               => undef, # 2.8+
    conf_no_appendfsync_on_rewrite         => 'no',
    conf_nosave                            => undef,
    conf_notify_keyspace_events            => undef, # 2.8+
    conf_pidfile                           => undef,
    conf_port                              => '6379',
    conf_rdbchecksum                       => 'yes', # 2.6+
    conf_rdbcompression                    => 'yes',
    conf_repl_backlog_size                 => '1mb', # 2,8+
    conf_repl_backlog_ttl                  => '3600', # 2.8+
    conf_repl_disable_tcp_nodelay          => 'no', # 2,6+
    conf_repl_ping_slave_period            => '10', # 2.4+
    conf_repl_timeout                      => '60', # 2.4+
    conf_requirepass                       => undef,
    conf_save                              => {"900" =>"1", "300" => "10", "60" => "10000"},
    conf_set_max_intset_entries            => '512',
    conf_slave_priority                    => undef, # 2.6+
    conf_slave_read_only                   => 'yes', # 2.6+
    conf_slave_serve_stale_data            => 'yes',
    conf_slaveof                           => undef,
    conf_slowlog_log_slower_than           => '10000',
    conf_slowlog_max_len                   => '128',
    conf_stop_writes_on_bgsave_error       => 'yes', # 2.6+
    conf_syslog_enabled                    => undef,
    conf_syslog_facility                   => undef,
    conf_syslog_ident                      => undef,
    conf_tcp_backlog                       => undef, # 2.8.5+
    conf_tcp_keepalive                     => '0', # 2.6+
    conf_timeout                           => '0',
    conf_vm_enabled                        => 'no', # deprecated in 2.4+
    conf_vm_max_memory                     => '0', # deprecated in 2.4+
    conf_vm_max_threads                    => '4', # deprecated in 2.4+
    conf_vm_page_size                      => '32', # deprecated in 2.4+
    conf_vm_pages                          => '134217728', # deprecated in 2.4+
    conf_vm_swap_file                      => '/tmp/redis.swap', # deprecated in 2.4+
    conf_zset_max_ziplist_entries          => '128', # 2.4+
    conf_zset_max_ziplist_value            => '64', # 2.4+
    package_ensure                         => 'present',
    service_enable                         => true,
    service_ensure                         => 'running',
    service_restart                        => true,
    system_sysctl                          => true,
  }

}
