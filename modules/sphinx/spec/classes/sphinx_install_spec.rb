require 'spec_helper'

describe 'sphinx::install', :type => :class do
  let(:title) { 'install' }
  let(:facts) { { :operatingsystem => 'Ubuntu ' } }
  
  describe 'class with no params' do
		it 'should throw an error about the missing parameters' do
			expect { should create_class('sphinx::install') }\
				.to raise_error(Puppet::Error, /Must pass unpack_root/)
		end
  end
  
  describe 'class with version 0.9.9 and unpack_root /usr/src' do
    let(:params) { { :version => '0.9.9', :unpack_root => '/usr/src' } }

		it { should create_class('sphinx::install').with_version('0.9.9')\
		                                           .with_unpack_root('/usr/src') }
		it { should contain_class('buildenv::c') }
		it { should contain_class('buildenv::libs::mysql') }
		it { should contain_common__archive('sphinx-0.9.9').with_ensure('present')\
		                                                   .with_checksum(false)\
		                                                   .with_url('http://sphinxsearch.com/files/sphinx-0.9.9.tar.gz')\
		                                                   .with_timeout('600')\
		                                                   .with_target('/usr/src') }
    it { should contain_common__archive('libstemmer').with_ensure('present')\
                                                     .with_checksum(false)\
                                                     .with_url('http://snowball.tartarus.org/dist/libstemmer_c.tgz')\
                                                     .with_timeout('600')\
                                                     .with_target('/usr/src/sphinx-0.9.9') }
    it { should contain_exec('configure-sphinx').with_command('/usr/src/sphinx-0.9.9/configure --with-libstemmer')\
                                                .with_cwd('/usr/src/sphinx-0.9.9')\
                                                .with_creates('/usr/src/sphinx-0.9.9/Makefile')\
                                                .with_refreshonly(true) }
    it { should contain_exec('make-sphinx').with_command('/usr/bin/make')\
                                           .with_cwd('/usr/src/sphinx-0.9.9')\
                                           .with_creates('/usr/src/sphinx-0.9.9/src/searchd')\
                                           .with_refreshonly(true) }
    it { should contain_exec('make-install-sphinx').with_command('/usr/bin/make install')\
                                               .with_cwd('/usr/src/sphinx-0.9.9')\
                                               .with_creates('/usr/local/bin/searchd')\
                                               .with_refreshonly(true) }
  end

  describe 'class with too many parameters' do
    let(:params) { { :extra => 'extra' } }

    it 'should throw an error about the extra parameter' do
			expect { should create_class('sphinx::install') }\
				.to raise_error(Puppet::Error, /Invalid parameter extra/)
		end
  end
end
