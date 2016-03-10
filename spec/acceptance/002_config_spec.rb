require 'spec_helper_acceptance'

describe 'connection:' do
  describe 'default' do
    it 'should run successfully' do
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
          strongswan::conn { \'IPsec-IKEv2\':
            options => {
              "rekey"         => "no",
              "left"          => "%any",
              "leftsubnet"    => "0.0.0.0/0",
              "leftcert"      => "vpnHostCert.der",
              "right"         => "%any",
              "rightdns"      => "8.8.8.8,8.8.4.4",
              "rightsourceip" => "10.10.10.0/24",
              "auto"          => "add",
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
          strongswan::secrets { "John":
            options => {
              "EAP" => "SuperSecretPass",
            }
          }'
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to eq(/error/i)
      end
    end
  end
end
