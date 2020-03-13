# @summary Configure a strongSwan connection configuration.
#
# @param conn_name
#   The name of the connection.
# @param options
#   A hash of configuration options for the connection.
#
# @example Configure defaults for other connections
#    strongswan::conn { '%default':
#      options => {
#        'ike'         => 'aes128gcm128-prfsha256-ecp256!',
#        'esp'         => 'aes128gcm128-ecp256!',
#        'keyexchange' => 'ikev2',
#        'ikelifetime' => '60m',
#        'lifetime'    => '20m',
#        'margintime'  => '3m',
#        'closeaction' => 'restart',
#        'dpdaction'   => 'restart',
#      }
#    }
#
#  @example Configure `IPsec-IKEv2` connection.
#    strongswan::conn { 'IPsec-IKEv2':
#      options => {
#        'rekey'         => 'no',
#        'left'          => '%any',
#        'leftsubnet'    => '0.0.0.0/0',
#        'leftcert'      => 'vpnHostCert.der',
#        'right'         => '%any',
#        'rightdns'      => '8.8.8.8,8.8.4.4',
#        'rightsourceip' => '10.10.10.0/24',
#        'auto'          => 'add',
#      }
#    }
#
#  @example Configure `IKEv2-EAP` connection.
#    strongswan::conn { 'IKEv2-EAP':
#      options => {
#        'also'          => 'IPSec-IKEv2',
#        'leftauth'      => 'pubkey',
#        'leftsendcert'  => 'always',
#        'rightauth'     => 'eap-mschapv2',
#        'rightsendcert' => 'never',
#        'eap_identity'  => '%any',
#      }
define strongswan::conn(
  String[1] $conn_name = $title,
  Hash      $options = {},
) {
  include strongswan

  concat::fragment { "ipsec_conf_conn-${conn_name}":
    content => template('strongswan/ipsec_conf_conn.erb'),
    target  => $strongswan::ipsec_conf,
    order   => '03',
  }
}
