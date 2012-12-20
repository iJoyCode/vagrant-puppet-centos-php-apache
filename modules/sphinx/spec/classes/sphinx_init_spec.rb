require 'spec_helper'

describe 'sphinx', :type => :class do
  let(:title) { 'init' }
  let(:facts) { { :operatingsystem => 'Ubuntu ' } }
  
  describe 'class with no params' do
		it 'should throw an error about having to specify either configfile_source or configfile_content' do
			expect { should create_class('sphinx') }\
				.to raise_error(Puppet::Error, /Both configfile_source and configfile_content/)
		end
  end
  
  describe 'class with both configfile_source and configfile_content' do
    let(:params) { { :configfile_source => 'puppet:///sphinx/mysphinx.conf', :configfile_content => 'sphinx/spec_content.conf.erb' } }
		it 'should throw an error about not being able to specify both configfile_source and configfile_content' do
			expect { should create_class('sphinx') }\
				.to raise_error(Puppet::Error, /Both configfile_source and configfile_content/)
		end
  end
  
  describe 'class with configfile_source puppet:///sphinx/mysphinx.conf' do
    let(:facts) { { :operatingsystem => 'Ubuntu ', :sphinx_configfile_source => 'puppet:///sphinx/mysphinx.conf' } }

		it { should create_class('sphinx').with_os_suffix('debian')\
		                                  .with_unpack_root('/usr/src')\
		                                  .with_configdir('/usr/local/etc')\
		                                  .with_configfile('/usr/local/etc/sphinx.conf')\
		                                  .with_configfile_source('puppet:///sphinx/mysphinx.conf')\
		                                  .with_configfile_content(false)\
		                                  .with_libdir('/var/lib/sphinx')\
		                                  .with_logdir('/var/log/sphinx')\
		                                  .with_pidfile('/var/run/searchd.pid')\
		                                  .with_dbdir('/var/lib/sphinx/db')\
		                                  .with_version('0.9.9') }
		it { should create_class('sphinx::install').with_version('0.9.9')\
		                                           .with_unpack_root('/usr/src') }
    it { should create_class('sphinx::config').with_os_suffix('debian')\
        		                                  .with_configdir('/usr/local/etc')\
        		                                  .with_configfile('/usr/local/etc/sphinx.conf')\
        		                                  .with_configfile_source('puppet:///sphinx/mysphinx.conf')\
        		                                  .with_configfile_content(false)\
        		                                  .with_libdir('/var/lib/sphinx')\
        		                                  .with_logdir('/var/log/sphinx')\
        		                                  .with_pidfile('/var/run/searchd.pid')\
        		                                  .with_dbdir('/var/lib/sphinx/db') }
		it { should create_class('sphinx::service') }
  end
  
  describe 'class with configfile_content sphinx/spec_content.conf.erb' do
    let(:facts) { { :operatingsystem => 'Ubuntu ', :sphinx_configfile_content => 'sphinx/spec_content.conf.erb' } }

		it { should create_class('sphinx').with_os_suffix('debian')\
		                                  .with_unpack_root('/usr/src')\
		                                  .with_configdir('/usr/local/etc')\
		                                  .with_configfile('/usr/local/etc/sphinx.conf')\
		                                  .with_configfile_source(false)\
		                                  .with_configfile_content('This is a placeholder for tests')\
		                                  .with_libdir('/var/lib/sphinx')\
		                                  .with_logdir('/var/log/sphinx')\
		                                  .with_pidfile('/var/run/searchd.pid')\
		                                  .with_dbdir('/var/lib/sphinx/db')\
		                                  .with_version('0.9.9') }
		it { should create_class('sphinx::install').with_version('0.9.9')\
		                                           .with_unpack_root('/usr/src') }
    it { should create_class('sphinx::config').with_os_suffix('debian')\
        		                                  .with_configdir('/usr/local/etc')\
        		                                  .with_configfile('/usr/local/etc/sphinx.conf')\
        		                                  .with_configfile_source(false)\
        		                                  .with_configfile_content('This is a placeholder for tests')\
        		                                  .with_libdir('/var/lib/sphinx')\
        		                                  .with_logdir('/var/log/sphinx')\
        		                                  .with_pidfile('/var/run/searchd.pid')\
        		                                  .with_dbdir('/var/lib/sphinx/db') }
		it { should create_class('sphinx::service') }
  end
  
  describe 'class with configfile_content sphinx/spec_content.conf.erb, configdir /etc/sphinx, version 1.0' do
    let(:params) { { :version => '1.0' } }
    let(:facts) { { :operatingsystem => 'Ubuntu ', :sphinx_configdir => '/etc/sphinx', :sphinx_configfile_content => 'sphinx/spec_content.conf.erb' } }

		it { should create_class('sphinx').with_os_suffix('debian')\
		                                  .with_unpack_root('/usr/src')\
		                                  .with_configdir('/etc/sphinx')\
		                                  .with_configfile('/etc/sphinx/sphinx.conf')\
		                                  .with_configfile_source(false)\
		                                  .with_configfile_content('This is a placeholder for tests')\
		                                  .with_libdir('/var/lib/sphinx')\
		                                  .with_logdir('/var/log/sphinx')\
		                                  .with_pidfile('/var/run/searchd.pid')\
		                                  .with_dbdir('/var/lib/sphinx/db')\
		                                  .with_version('1.0') }
		it { should create_class('sphinx::install').with_version('1.0')\
		                                           .with_unpack_root('/usr/src') }
    it { should create_class('sphinx::config').with_os_suffix('debian')\
        		                                  .with_configdir('/etc/sphinx')\
        		                                  .with_configfile('/etc/sphinx/sphinx.conf')\
        		                                  .with_configfile_source(false)\
        		                                  .with_configfile_content('This is a placeholder for tests')\
        		                                  .with_libdir('/var/lib/sphinx')\
        		                                  .with_logdir('/var/log/sphinx')\
        		                                  .with_pidfile('/var/run/searchd.pid')\
        		                                  .with_dbdir('/var/lib/sphinx/db') }
		it { should create_class('sphinx::service') }
  end

  describe 'class with too many parameters' do
    let(:params) { { :extra => 'extra' } }

    it 'should throw an error about the extra parameter' do
			expect { should create_class('sphinx') }\
				.to raise_error(Puppet::Error, /Invalid parameter extra/)
		end
  end
end
