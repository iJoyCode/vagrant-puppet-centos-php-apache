# == Class: redis
#
# This class installs redis
#
# == Parameters:
#
# $parameter:: This global variable is used to set
#
# == Actions:
#   - Install and configure Redis
#
# == Sample Usage:
#
#   class { 'redis': }
#
#   class { 'redis':
#     manage_repo => true;
#   }
#
class redis (
  $activerehashing             = $::redis::params::activerehashing,
  $appendfsync                 = $::redis::params::appendfsync,
  $appendonly                  = $::redis::params::appendonly,
  $auto_aof_rewrite_min_size   = $::redis::params::auto_aof_rewrite_min_size,
  $auto_aof_rewrite_percentage = $::redis::params::auto_aof_rewrite_percentage,
  $bind                        = $::redis::params::bind,
  $config_dir                  = $::redis::params::config_dir,
  $config_dir_mode             = $::redis::params::config_dir_mode,
  $config_file                 = $::redis::params::config_file,
  $config_file_mode            = $::redis::params::config_file_mode,
  $config_group                = $::redis::params::config_group,
  $config_owner                = $::redis::params::config_owner,
  $daemonize                   = $::redis::params::daemonize,
  $databases                   = $::redis::params::databases,
  $dbfilename                  = $::redis::params::dbfilename,
  $hash_max_ziplist_entries    = $::redis::params::hash_max_ziplist_entries,
  $hash_max_ziplist_value      = $::redis::params::hash_max_ziplist_value,
  $list_max_ziplist_entries    = $::redis::params::list_max_ziplist_entries,
  $list_max_ziplist_value      = $::redis::params::list_max_ziplist_value,
  $log_dir                     = $::redis::params::log_dir,
  $log_file                    = $::redis::params::log_file,
  $log_level                   = $::redis::params::log_level,
  $manage_repo                 = $::redis::params::manage_repo,
  $masterauth                  = $::redis::params::masterauth,
  $maxclients                  = $::redis::params::maxclients,
  $maxmemory                   = $::redis::params::maxmemory,
  $maxmemory_policy            = $::redis::params::maxmemory_policy,
  $maxmemory_samples           = $::redis::params::maxmemory_samples,
  $no_appendfsync_on_rewrite   = $::redis::params::no_appendfsync_on_rewrite,
  $package_ensure              = $::redis::params::package_ensure,
  $package_name                = $::redis::params::package_name,
  $pid_file                    = $::redis::params::pid_file,
  $port                        = $::redis::params::port,
  $ppa_repo                    = $::redis::params::ppa_repo,
  $rdbcompression              = $::redis::params::rdbcompression,
  $repl_ping_slave_period      = $::redis::params::repl_ping_slave_period,
  $repl_timeout                = $::redis::params::repl_timeout,
  $requirepass                 = $::redis::params::requirepass,
  $service_enable              = $::redis::params::service_enable,
  $service_ensure              = $::redis::params::service_ensure,
  $service_group               = $::redis::params::service_group,
  $service_hasrestart          = $::redis::params::service_hasrestart,
  $service_hasstatus           = $::redis::params::service_hasstatus,
  $service_name                = $::redis::params::service_name,
  $service_user                = $::redis::params::service_user,
  $set_max_intset_entries      = $::redis::params::set_max_intset_entries,
  $slave_read_only             = $::redis::params::slave_read_only,
  $slave_serve_stale_data      = $::redis::params::slave_serve_stale_data,
  $slaveof                     = $::redis::params::slaveof,
  $slowlog_log_slower_than     = $::redis::params::slowlog_log_slower_than,
  $slowlog_max_len             = $::redis::params::slowlog_max_len,
  $timeout                     = $::redis::params::timeout,
  $ulimit                      = $::redis::params::ulimit,
  $workdir                     = $::redis::params::workdir,
  $zset_max_ziplist_entries    = $::redis::params::zset_max_ziplist_entries,
  $zset_max_ziplist_value      = $::redis::params::zset_max_ziplist_value,
) inherits redis::params {

  include preinstall
  include install
  include config
  include service

  Class['preinstall'] ->
  Class['install'] ->
  Class['config'] ~>
  Class['service']

  # Sanity check
  if $::redis::slaveof {
    if $::redis::bind =~ /^127.0.0./ {
      fail "Replication is not possible when binding to ${::redis::bind}."
    }
  }
}

