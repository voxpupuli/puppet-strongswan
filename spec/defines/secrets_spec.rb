require 'spec_helper'

describe 'strongswan::secrets', type: :define do
  let(:pre_condition) { 'include strongswan' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:title) { 'user' }
      let :params do
        {
          options: {
            'ECDSA' => 'user.der'
          }
        }
      end

      it {
        is_expected.to contain_concat__fragment('ipsec_secrets_secret-user') \
          .with_content(/# Secrets for user\./)
      }

      it {
        is_expected.to contain_concat__fragment('ipsec_secrets_secret-user') \
          .with_content(/: ECDSA user\.der/)
      }
    end
  end
end
