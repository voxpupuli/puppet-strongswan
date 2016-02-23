require 'spec_helper'

describe 'strongswan::conn', :type => :define do
  let :pre_condition do
    'include strongswan'
  end

  context 'default conn settings on a Debian system' do
    let(:facts) {
      {
        :id             => 'root',
        :is_pe          => false,
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
        :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
      }
    }
    let(:title) { '%default' }
    let :params do
      {
        :options => {
          'ike'         => 'aes128gcm128-prfsha256-ecp256!',
          'esp'         => 'aes128gcm128-ecp256!',
          'keyexchange' => 'ikev2',
        },
      } 
    end

    it { should contain_class('strongswan::params') }

    it {
      should contain_concat__fragment('ipsec_conf_conn-%default') \
        .with_content(/^conn %default$/)
    }
    it {
      should contain_concat__fragment('ipsec_conf_conn-%default') \
        .with_content(/    ike=aes128gcm128-prfsha256-ecp256/)
    }
    it {
      should contain_concat__fragment('ipsec_conf_conn-%default') \
        .with_content(/    esp=aes128gcm128-ecp256/)
    }
    it {
      should contain_concat__fragment('ipsec_conf_conn-%default') \
        .with_content(/    keyexchange=ikev2/)
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
