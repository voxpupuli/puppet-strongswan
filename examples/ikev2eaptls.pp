# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#

# Strongswan IKEv2-EAP-TLS configuration example

class { 'strongswan': }
class { 'strongswan::pki::ca': }

strongswan::pki::certificate { 'server':
  san => ['@strongswan-1','strongswan-1','192.168.33.42', '@192.168.33.42'],
}

strongswan::pki::certificate { 'user1':
  common_name  => 'user1@strongswan-1.local',
  p12_password => 'StrongPass',
}

strongswan::secrets { ' ':
  options => {
    'RSA' => 'server.der',
  },
}

strongswan::conn { 'IKEv2-EAP-TLS':
  options => {
    'auto'          => 'add',
    'type'          => 'tunnel',
    'keyexchange'   => 'ikev2',
    'leftid'        => '192.168.33.42',
    'leftcert'      => 'server.crt',
    'leftauth'      => 'pubkey',
    'leftsendcert'  => 'always',
    'leftsubnet'    => '192.168.33.0/24',
    'rightauth'     => 'eap-tls',
    'rightsourceip' => '10.10.10.0/24',
    'rightdns'      => '8.8.8.8,8.8.4.4',
    'right'         => '%any',
    'rightid'       => '%any',
  },
}

strongswan::charon { 'log':
  options => {
    'filelog' => {
      '/var/log/strongswan.log' => {
        'time_format' => '%b %e %T',
        'ike_name'    => 'yes',
        'append'      => 'no',
        'default'     => '1',
        'flush_line'  => 'yes',
      },
      'stderr'                  => {
        'ike' => '2',
        'knl' => '2',
      },
    },
  },
}

strongswan::charon { 'dns':
  options => {
    'dns1' => '8.8.8.8',
    'dns2' => '8.8.4.4',
  },
}
