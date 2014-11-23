require 'spec_helper'
hiera_file = 'spec/fixtures/hiera/hiera.yaml'

describe 'hubot', :type => :class  do
    let (:facts) {{
        :operatingsystem => 'Debian'
    }}

    context 'with default values' do
        it { should compile }
        it { should contain_class('stdlib') }
        it { should contain_class('stdlib::stages') }
        it { should contain_class('hubot') }
        it { should contain_class('hubot::params') }
        it { should contain_class('hubot::config') }
        it { should contain_class('hubot::service') }
        it { should contain_class('hubot::package') }
    end

end
