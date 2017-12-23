require 'spec_helper'

describe 'strongswan::conn', type: :define do
  let(:pre_condition) { 'include strongswan' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:title) { 'ikev2-default' }
      let :params do
        {
          options: {
            'ike'         => 'aes128gcm128-prfsha256-ecp256!',
            'esp'         => 'aes128gcm128-ecp256!',
            'keyexchange' => 'ikev2'
          }
        }
      end

      it {
        is_expected.to contain_concat__fragment('ipsec_conf_conn-ikev2-default') \
          .with_content(/^conn ikev2-default$/)
      }
      it {
        is_expected.to contain_concat__fragment('ipsec_conf_conn-ikev2-default') \
          .with_content(/^\s*ike=aes128gcm128-prfsha256-ecp256/)
      }
      it {
        is_expected.to contain_concat__fragment('ipsec_conf_conn-ikev2-default') \
          .with_content(/^\s*esp=aes128gcm128-ecp256/)
      }
      it {
        is_expected.to contain_concat__fragment('ipsec_conf_conn-ikev2-default') \
          .with_content(/^\s*keyexchange=ikev2/)
      }
    end
  end
end
