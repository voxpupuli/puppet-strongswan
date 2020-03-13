require 'spec_helper'

describe 'strongswan::pki::ca' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:params) do
        {
          common_name: 'vpnCA',
          country_code: 'CC',
          organization: 'Strongswan'
        }
      end

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        case facts[:osfamily]
        when 'RedHat'
          it { is_expected.to contain_exec('Create self-signed CA certificate').with_creates(['/etc/strongswan/ipsec.d/cacerts/vpnCA.crt']) }
          it { is_expected.to contain_exec('Create CA private key').with_creates(['/etc/strongswan/ipsec.d/private/vpnCA.der']) }
          it { is_expected.to contain_file('/etc/strongswan/ipsec.d/private/vpnCA.der') }
          it { is_expected.to contain_exec('Convert CA certificate from DER to PEM format').with_creates(['/etc/strongswan/ipsec.d/cacerts/vpnCA.pem']) }
        when 'Debian'
          it { is_expected.to contain_exec('Create self-signed CA certificate').with_creates(['/etc/ipsec.d/cacerts/vpnCA.crt']) }
          it { is_expected.to contain_exec('Create CA private key').with_creates(['/etc/ipsec.d/private/vpnCA.der']) }
          it { is_expected.to contain_file('/etc/ipsec.d/private/vpnCA.der') }
          it { is_expected.to contain_exec('Convert CA certificate from DER to PEM format').with_creates(['/etc/ipsec.d/cacerts/vpnCA.pem']) }
        end
      end

      context 'with common_name => vpn CA' do
        let(:params) do
          super().merge(common_name: 'vpn CA')
        end

        case facts[:osfamily]
        when 'RedHat'
          it { is_expected.to contain_file('/etc/strongswan/ipsec.d/private/vpn_CA.der') }
        when 'Debian'
          it { is_expected.to contain_file('/etc/ipsec.d/private/vpn_CA.der') }
        end
      end
    end
  end
end
