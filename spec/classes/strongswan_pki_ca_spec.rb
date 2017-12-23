require 'spec_helper'

describe 'strongswan::pki::ca' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { 'include strongswan' }
      let(:params) do
        {
          certificate_dir: '/etc/strongswan/ipsec.d/cacerts',
          private_key_dir: '/etc/strongswan/ipsec.d/private',
          common_name: 'vpnCA',
          country_code: 'CC',
          organization: 'Strongswan'
        }
      end

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('Create self-signed CA certificate').with_creates(['/etc/strongswan/ipsec.d/cacerts/vpnCA.crt']) }
        it { is_expected.to contain_exec('Create CA private key').with_creates(['/etc/strongswan/ipsec.d/private/vpnCA.der']) }
        it { is_expected.to contain_file('/etc/strongswan/ipsec.d/private/vpnCA.der') }
        it { is_expected.to contain_exec('Convert CA certificate from DER to PEM format').with_creates(['/etc/strongswan/ipsec.d/cacerts/vpnCA.pem']) }
      end

      context 'with common_name => vpn CA' do
        let(:params) do
          super().merge(common_name: 'vpn CA')
        end

        it { is_expected.to contain_file('/etc/strongswan/ipsec.d/private/vpn_CA.der') }
      end
    end
  end
end
