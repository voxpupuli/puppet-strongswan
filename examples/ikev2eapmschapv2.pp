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

# Strongswan IKEv2-EAP-MSCHAPv2 configuration example
# works with OS X native Strongswan client
# https://download.strongswan.org/osx/

class {'strongswan':}
class {'strongswan::pki::ca':}

strongswan::pki::certificate {'server':
  san => ['@strongswan-1','strongswan-1','192.168.33.42', '@192.168.33.42']
}


strongswan::secrets { 'user1':
  options => {
    'EAP' => 'qwerty',
  },
}

strongswan::secrets { ' ':
  options => {
    'RSA' => 'server.der',
  },
}


strongswan::conn {'ikev2-eap-mschapv2':
  options => {
    'auto'          => 'add',
    'compress'      => 'no',
    'type'          => 'tunnel',
    'keyexchange'   => 'ikev2',
    'dpdaction'     => 'clear',
    'dpddelay'      => '300s',
    'rekey'         => 'no',
    'left'          => '%any',
    'leftid'        => '192.168.33.42',
    'leftcert'      => 'server.crt',
    'leftsendcert'  => 'always',
    'leftsubnet'    => '192.168.33.0/24',
    'right'         => '%any',
    'rightid'       => '%any',
    'rightauth'     => 'eap-mschapv2',
    'rightsourceip' => '10.10.10.0/24',
    'rightdns'      => '8.8.8.8,8.8.4.4',
    'rightsendcert' => 'never',
    'eap_identity'  => '%identity'
  }
}

strongswan::logging { '/var/log/vpn.log':
  logger  => 'filelog',
  options => {
    'time_format' => '%b %e %T',
    'ike_name'    => 'yes',
    'append'      => 'no',
    'default'     => '1',
    'flush_line'  => 'yes',
  },
}

strongswan::logging { 'stderr':
  logger  => 'filelog',
  options => {
    'ike' => '2',
    'knl' => '2',
  },
}
