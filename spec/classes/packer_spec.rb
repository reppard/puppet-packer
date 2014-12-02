require 'spec_helper'

describe 'packer' do
  context 'supported operating systems' do
    ['Debian', 'RedHat', 'Darwin'].each do |osfamily|
#    ['Debian', 'RedHat', 'Darwin', 'Windows'].each do |osfamily|
      ['amd64', 'i386' ].each do |arch|

        let(:facts) {{ :path => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin'] }}
        let(:params) {{ :version => 'foobar' }}

        if %w[Debian RedHat].include? osfamily then
          kernel = 'linux'
          architecture = arch
        else
          kernel = osfamily
          if 'Windows' == kernel then
            architecture = 'x64'
          elsif 'Darwin' == kernel then
            architecture = 'x86_64'
          end
        end

        describe "packer class without any parameters on #{osfamily}" do
          let(:facts) {{
            :path => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
            :osfamily => osfamily,
            :kernel => kernel,
            :architecture => architecture
          }}

          it { should compile }
          it { should contain_class('packer::params') }

          # test for staging file and staging extract
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'packer class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { should_not compile }
    end
  end
end
