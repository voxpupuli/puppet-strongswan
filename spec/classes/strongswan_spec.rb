require 'spec_helper'

describe 'strongswan' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('strongswan') }
        it { is_expected.to contain_class('strongswan::package') }
        it { is_expected.to contain_class('strongswan::config') }
        it { is_expected.to contain_class('strongswan::service') }
      end

      context 'strongswan::package' do
        it { is_expected.to contain_package('strongswan') }
      end

      context 'strongswam::service' do
        case facts[:operatingsystem]
        when 'Debian'
          case facts[:operatingsystemmajrelease]
          when '8', '9', '10'
            strongswan_service_name = 'strongswan'
          else
            strongswan_service_name = 'strongswan-starter'
          end
        when 'Ubuntu'
          case facts[:operatingsystemmajrelease]
          when '16.04', '18.04'
            strongswan_service_name = 'strongswan'
          else
            strongswan_service_name = 'strongswan-starter'
          end
        else
          strongswan_service_name = 'strongswan'
        end
        it { is_expected.to contain_service(strongswan_service_name) }
      end

      context 'strongswan::config' do
        case facts[:osfamily]
        when 'RedHat'
          it { is_expected.to contain_concat('/etc/strongswan/ipsec.conf') }
          it { is_expected.to contain_concat('/etc/strongswan/ipsec.secrets') }
        when 'Debian'
          it { is_expected.to contain_concat('/etc/ipsec.conf') }
          it { is_expected.to contain_concat('/etc/ipsec.secrets') }
        end
      end
    end
  end
end
