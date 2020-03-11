require 'spec_helper_acceptance'

describe 'connection:' do
  case fact('os.family')
  when 'Debian'
    ipsec_conf = '/etc/ipsec.conf'
    ipsec_secrets = '/etc/ipsec.secrets'
  when 'RedHat'
    ipsec_conf = '/etc/strongswan/ipsec.conf'
    ipsec_secrets = '/etc/strongswan/ipsec.secrets'
  end
  describe 'default' do
    it 'runs successfully' do
      pp = '
          class { \'strongswan\': }
          strongswan::conn { \'%default\':
              options => {
              "ike"         => "aes128gcm128-prfsha256-ecp256!",
              "esp"         => "aes128gcm128-ecp256!",
              "keyexchange" => "ikev2",
              "ikelifetime" => "60m",
              "lifetime"    => "20m",
              "margintime"  => "3m",
              "closeaction" => "restart",
              "dpdaction"   => "restart",
            }
          }
          strongswan::conn { \'IKEv2-EAP\':
            options => {
              "leftauth"      => "pubkey",
              "leftsendcert"  => "always",
              "rightauth"     => "eap-mschapv2",
              "rightsendcert" => "never",
              "eap_identity"  => "%any",
            }
          }
          strongswan::secrets { " ":
            options => {
              "RSA" => "server.der",
            },
          }
          strongswan::secrets { "John":
            options => {
              "EAP" => "SuperSecretPass",
            }
          }'
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to eq(%r{error}i)
      end
    end
  end
  describe service('strongswan') do
    it { is_expected.to be_running }
  end
  describe file(ipsec_conf) do
    it { is_expected.to be_file }
    it { is_expected.to contain 'conn IKEv2-EAP' }
    it { is_expected.to contain 'conn %default' }
  end
  describe file(ipsec_secrets) do
    it { is_expected.to be_file }
    it { is_expected.to contain '  : RSA server.der' }
  end
end
