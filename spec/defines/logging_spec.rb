require 'spec_helper'

describe 'strongswan::logging', :type => :define do
  let :pre_condition do
    'include strongswan'
  end

  context 'logging settings on a Redhat system: logger => filelog' do
    let(:facts) {
      {
        :id             => 'root',
        :is_pe          => false,
        :osfamily       => 'Redhat',
        :concat_basedir => '/dne',
        :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
      }
    }
    let(:title) { 'strongswan-log' }
    let :params do
      {
        :key => '/var/log/strongswan.log',
        :logger     => 'filelog',
        :identifier => false,
        :options    => {
          'time_format' => '%b %e %T',
          'ike_name'    => 'yes',
          'append'      => 'no',
          'default'     => '2',
          'flush_line'  => 'yes',
        }
      } 
  end

  it { should contain_class('strongswan::params') }

  it {
    should contain_concat__fragment('charon_logging-strongswan-log') 

  }
  it {
    should contain_concat__fragment('charon_logging-strongswan-log') \
      .with_content(/^\s*\/var\/log\/strongswan.log\s*/)
  }
  it {
    should contain_concat__fragment('charon_logging-strongswan-log') \
      .with_content(/^\s*time_format = %b %e %T\s*/)
    }
  it {
    should contain_concat__fragment('charon_logging-strongswan-log') \
      .with_content(/^\s*ike_name = yes\s*/)
    }
end

  context 'logging settings on a Redhat system: logger => syslog, ' do
    let(:facts) {
      {
        :id             => 'root',
        :is_pe          => false,
        :osfamily       => 'Redhat',
        :concat_basedir => '/dne',
        :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
      }
    }
    let(:title) { 'strongswan-log' }
    let :params do
      {
        :key        => 'deamon',
        :logger     => 'syslog',
        :identifier => 'charon-custom',
        :options    => { }
      } 
    end

    it { should contain_class('strongswan::params') }

    it {
      should contain_concat__fragment('charon_logging-strongswan-log') \
        .with_content(/^\s*syslog/)
    }
    it {
       should contain_concat__fragment('charon_logging-strongswan-log') \
         .with_content(/^\s*deamon\s*/)
      }
    it {
       should contain_concat__fragment('charon_logging-strongswan-log') \
         .with_content(/^\s*identifier = charon-custom/)
      }
    
  end

  context 'example settings on a Solaris system' do
    let(:facts) { { :osfamily => 'Solaris' } }
    let(:title) { 'gw' }

    it do
      expect {
        should compile
      }.to raise_error(/Solaris is not supported./)
    end
  end
end
