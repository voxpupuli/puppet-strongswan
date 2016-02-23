require 'spec_helper'

describe 'strongswan::secrets', :type => :define do
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
    let(:title) { 'rw' }
    let :params do
      {
        :options => {
          'ECDSA'  => 'rwKey.der',
        },
      } 
    end

    it { should contain_class('strongswan::params') }

    it {
      should contain_concat__fragment('ipsec_secrets_secret-rw') \
        .with_content(/# Secrets for rw\./)
    }

    it {
      should contain_concat__fragment('ipsec_secrets_secret-rw') \
        .with_content(/: ECDSA rwKey\.der/)
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
