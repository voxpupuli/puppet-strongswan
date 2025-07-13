require 'spec_helper'

describe 'strongswan::setup' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        case facts[:os]['family']
        when 'RedHat'
          it { is_expected.to contain_concat__fragment('ipsec_conf_setup').with_target('/etc/strongswan/ipsec.conf') }
        when 'Debian'
          it { is_expected.to contain_concat__fragment('ipsec_conf_setup').with_target('/etc/ipsec.conf') }
        end
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            with_content(%r{^\s*config setup})
        }
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            without_content(%r{^\s*strictcrlpolicy=yes})
        }
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            without_content(%r{^\s*uniqueids=never})
        }
      end

      describe 'with params' do
        let(:params) do
          { options:
            {
              strictcrlpolicy: 'yes',
              uniqueids: 'never'
            } }
        end

        it { is_expected.to compile.with_all_deps }

        case facts[:os]['family']
        when 'RedHat'
          it {
            is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
              with_target('/etc/strongswan/ipsec.conf')
          }
        when 'Debian'
          it {
            is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
              with_target('/etc/ipsec.conf')
          }
        end
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            with_content(%r{^\s*config setup})
        }
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            with_content(%r{^\s*strictcrlpolicy=yes})
        }
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            with_content(%r{^\s*uniqueids=never})
        }
      end
    end
  end
end
