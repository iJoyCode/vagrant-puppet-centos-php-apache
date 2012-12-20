require 'spec_helper'

describe 'sphinx::config', :type => :class do
  let(:title) { 'config' }
  let(:facts) { { :operatingsystem => 'Ubuntu ' } }
  
  describe 'class with no params' do
		it 'should throw an error about the missing parameters' do
			expect { should create_class('sphinx::config') }\
				.to raise_error(Puppet::Error, /Must pass/)
		end
  end
  
  describe 'class with configfile_content' do
    let(:params) { { :os_suffix => 'debian', :configdir => '/etc/sphinx', :configfile => '/etc/sphinx/sphinx.conf',
                     :configfile_content => 'This is a placeholder for tests', :configfile_source => false, :libdir => '/var/lib/sphinx',
                     :logdir => '/var/log/sphinx', :pidfile => '/var/run/searchd.pid', :dbdir => '/var/lib/sphinx/db' } }

		it { should create_class('sphinx::config').with_os_suffix('debian')\
		                                          .with_configdir('/etc/sphinx')\
		                                          .with_configfile('/etc/sphinx/sphinx.conf')\
		                                          .with_configfile_source(false)\
                                              .with_configfile_content('This is a placeholder for tests')\
                                              .with_libdir('/var/lib/sphinx')\
                                              .with_logdir('/var/log/sphinx')\
                                              .with_pidfile('/var/run/searchd.pid')\
                                              .with_dbdir('/var/lib/sphinx/db') }
    it { should contain_file('/etc/init.d/sphinxsearch').with_ensure('present')\
                                                        .with_owner('root')\
                                                        .with_group('root')\
                                                        .with_mode('0755') }
    it { should contain_file('/etc/sphinx').with_ensure('directory')\
                                           .with_owner('root')\
                                           .with_group('root')\
                                           .with_mode('0755') }
    it { should contain_file('/etc/sphinx/sphinx.conf').with_ensure('present')\
                                                       .with_owner('root')\
                                                       .with_group('root')\
                                                       .with_mode('0644')\
                                                       .without_source\
                                                       .with_content('This is a placeholder for tests') }                   
    it { should contain_file('/var/lib/sphinx').with_ensure('directory')\
                                               .with_owner('root')\
                                               .with_group('root')\
                                               .with_mode('0755') }                                      
    it { should contain_file('/var/log/sphinx').with_ensure('directory')\
                                               .with_owner('root')\
                                               .with_group('root')\
                                               .with_mode('0755') }                         
    it { should contain_file('/var/lib/sphinx/db').with_ensure('directory')\
                                                  .with_owner('root')\
                                                  .with_group('root')\
                                                  .with_mode('0755') }
  end

  describe 'class with configfile_source' do
    let(:params) { { :os_suffix => 'debian', :configdir => '/etc/sphinx', :configfile => '/etc/sphinx/sphinx.conf',
                     :configfile_content => false , :configfile_source => 'puppet:///sphinx/mysphinx.conf', :libdir => '/var/lib/sphinx',
                     :logdir => '/var/log/sphinx', :pidfile => '/var/run/searchd.pid', :dbdir => '/var/lib/sphinx/db' } }

		it { should create_class('sphinx::config').with_os_suffix('debian')\
		                                          .with_configdir('/etc/sphinx')\
		                                          .with_configfile('/etc/sphinx/sphinx.conf')\
		                                          .with_configfile_source('puppet:///sphinx/mysphinx.conf')\
                                              .with_configfile_content(false)\
                                              .with_libdir('/var/lib/sphinx')\
                                              .with_logdir('/var/log/sphinx')\
                                              .with_pidfile('/var/run/searchd.pid')\
                                              .with_dbdir('/var/lib/sphinx/db') }
    it { should contain_file('/etc/init.d/sphinxsearch').with_ensure('present')\
                                                        .with_owner('root')\
                                                        .with_group('root')\
                                                        .with_mode('0755') }
    it { should contain_file('/etc/sphinx').with_ensure('directory')\
                                           .with_owner('root')\
                                           .with_group('root')\
                                           .with_mode('0755') }
    it { should contain_file('/etc/sphinx/sphinx.conf').with_ensure('present')\
                                                       .with_owner('root')\
                                                       .with_group('root')\
                                                       .with_mode('0644')\
                                                       .with_source('puppet:///sphinx/mysphinx.conf')\
                                                       .without_content }
    it { should contain_file('/var/lib/sphinx').with_ensure('directory')\
                                               .with_owner('root')\
                                               .with_group('root')\
                                               .with_mode('0755') }
    it { should contain_file('/var/log/sphinx').with_ensure('directory')\
                                               .with_owner('root')\
                                               .with_group('root')\
                                               .with_mode('0755') }
    it { should contain_file('/var/lib/sphinx/db').with_ensure('directory')\
                                                  .with_owner('root')\
                                                  .with_group('root')\
                                                  .with_mode('0755') }
  end

  describe 'class with too many parameters' do
    let(:params) { { :extra => 'extra' } }

    it 'should throw an error about the extra parameter' do
			expect { should create_class('sphinx::config') }\
				.to raise_error(Puppet::Error, /Invalid parameter extra/)
		end
  end
end
