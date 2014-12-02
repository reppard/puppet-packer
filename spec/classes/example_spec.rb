require 'spec_helper'

describe 'packer' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "packer class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('packer::params') }
        it { should contain_class('packer::install').that_comes_before('packer::config') }
        it { should contain_class('packer::config') }
        it { should contain_class('packer::service').that_subscribes_to('packer::config') }

        it { should contain_service('packer') }
        it { should contain_package('packer').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'packer class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('packer') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
