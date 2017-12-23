require 'spec_helper'

describe 'strongswan::pki::certificate', type: :define do
  let(:pre_condition) do
    'include strongswan
     include strongswan::pki::ca'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let :params do
        {
          ca_name: 'strongswanCA',
          ca_certificate_dir: '/etc/strongswan/ipsec.d/private',
          ca_private_key_dir: '/etc/strongswan/ipsec.d/cacerts',
          certificate_dir: '/etc/strongswan/ipsec.d/certs',
          private_key_dir: '/etc/strongswan/ipsec.d/private',
          common_name: 'vpn.test.local',
          country_code: 'GB',
          organization: 'Strongswan',
          san: ['localhost,strongswanVPN'],
          p12_password: 'xyz123'
        }
      end

      context 'with defaults' do
        let(:title) { 'john_smith' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('john_smith private key') }
        it { is_expected.to contain_exec('john_smith certificate') }
        it { is_expected.to contain_file('/etc/strongswan/ipsec.d/private/john_smith.der') }
      end
    end
  end
end
