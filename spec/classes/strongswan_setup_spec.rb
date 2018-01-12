require 'spec_helper'

describe 'strongswan::setup' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { 'include strongswan' }

      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat__fragment('ipsec_conf_setup').with_target('/etc/strongswan/ipsec.conf') }
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
        it {
          is_expected.to contain_concat__fragment('ipsec_conf_setup'). \
            with_target('/etc/strongswan/ipsec.conf')
        }
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
