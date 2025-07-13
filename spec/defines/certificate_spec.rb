require 'spec_helper'

describe 'strongswan::pki::certificate', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let :params do
        {
          common_name: 'vpn.test.local',
          country_code: 'GB',
          organization: 'Strongswan',
          san: ['localhost,strongswanVPN'],
          p12_password: 'xyz123'
        }
      end

      context 'with defaults' do
        let(:title) { 'john_smith' }
        let(:ipsec_dir) do
          if facts[:os]['family'] == 'RedHat'
            '/etc/strongswan/ipsec.d'
          else
            '/etc/ipsec.d'
          end
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_exec('john_smith private key') }
        it { is_expected.to contain_exec('john_smith certificate') }
        it { is_expected.to contain_file("#{ipsec_dir}/private/john_smith.der") }
      end
    end
  end
end
