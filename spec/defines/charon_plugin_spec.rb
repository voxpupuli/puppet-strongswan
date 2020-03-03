require 'spec_helper'

describe 'strongswan::charon::plugin', type: :define do
  let(:pre_condition) { 'include strongswan' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:title) { 'eap' }
      let :params do
        {
          options: {
            'load' => 'yes'
          }
        }
      end

      it {
        is_expected.to contain_file('charon_plugin_eap'). \
          with_content(%r{load = yes})
      }

      it {
        is_expected.to contain_file('charon_plugin_eap'). \
          that_notifies('Class[strongswan::service]')
      }
    end
  end
end
