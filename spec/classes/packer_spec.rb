require 'spec_helper'

describe 'packer' do
  context 'supported operating systems' do
#    ['Debian', 'RedHat', 'Darwin', 'Windows'].each do |osfamily|
    ['Debian', 'RedHat', 'Darwin'].each do |osfamily|

      let(:facts) {{ :path => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin'] }}
      let(:params) {{ :version => 'foobar' }}

      if %w[Debian RedHat].include? osfamily then
        kernel = 'linux'
      else
        kernel = osfamily
      end

      describe "packer class without any parameters on #{osfamily}" do
        let(:facts) {{
          :path => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin'],
          :osfamily => osfamily,
          :kernel => kernel,
          :architecture => 'amd64'
        }}

        it { should compile }
        it { should contain_class('packer') }
        it { should contain_class('packer::params') }
      end

      context 'set class parameters' do
        let(:facts) {{
          :path => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin'],
          :osfamily => osfamily,
          :kernel => kernel,
          :architecture => 'i386'
        }}

        describe "version => 'foobar', base_url => 'http://www.google.com', staging_dir => '/baz'" do
          let(:params) {{ 
            :version => 'foobar', 
            :base_url => 'http://www.google.com',
            :staging_dir => '/baz'
          }}

          it { should contain_staging__file(
            "packer_#{params[:version]}_#{facts[:kernel]}_386.zip".downcase
          ) }

          it { should contain_staging__extract(
            "packer_#{params[:version]}_#{facts[:kernel]}_386.zip".downcase
          )}
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
