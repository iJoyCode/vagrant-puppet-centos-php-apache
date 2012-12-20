require 'spec_helper'

describe 'sphinx::service', :type => :class do
  let(:title) { 'service' }
  let(:facts) { { :operatingsystem => 'Ubuntu ' } }
  
  describe 'class with no params' do
		it { should create_class('sphinx::service') }
		it { should contain_service('sphinxsearch').with_ensure('running')\
		                                           .with_enable(true)\
		                                           .with_hasstatus(true)\
		                                           .with_hasrestart(true) }
  end

  describe 'class with too many parameters' do
    let(:params) { { :extra => 'extra' } }

    it 'should throw an error about the extra parameter' do
			expect { should create_class('sphinx::service') }\
				.to raise_error(Puppet::Error, /Invalid parameter extra/)
		end
  end
end
