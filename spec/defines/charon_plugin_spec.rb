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

      context 'with complex configuration' do
        let :params do
          {
            options: {
              'load'   => 'yes',
              'option' => {
                'sub_opt1' => 1,
                'sub_opt2' => {
                  'foo' => 'bar'
                }
              }
            }
          }
        end

        it {
          is_expected.to contain_file('charon_plugin_eap'). \
            with_content(Regexp.new(<<-HEREDOC
eap {
    load = yes
    option {
        sub_opt1 = 1
        sub_opt2 {
            foo = bar
        }
    }
}
            HEREDOC
                                   ))
        }
      end
    end
  end
end
