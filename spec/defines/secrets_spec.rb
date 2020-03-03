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
        is_expected.to contain_concat__fragment('ipsec_secrets_secret-user'). \
          with_content(%r{# Secrets for user\.})
      }

      it {
        is_expected.to contain_concat__fragment('ipsec_secrets_secret-user'). \
          with_content(%r{user : ECDSA user\.der})
      }
      context 'with empty selectors' do
        let :params do
          {
            selectors: [],
            options: {
              'RSA' => 'server.key'
            }
          }
        end

        it {
          is_expected.to contain_concat__fragment('ipsec_secrets_secret-user'). \
            with_content(%r{^ : RSA server.key})
        }
      end
      context 'with selectors' do
        let :params do
          {
            selectors: ['my_id', '10.1.2.3'],
            options: {
              'ECDSA' => 'user.der'
            }
          }
        end

        it {
          is_expected.to contain_concat__fragment('ipsec_secrets_secret-user'). \
            with_content(%r{my_id 10.1.2.3 : ECDSA user\.der})
        }
      end
    end
  end
end
