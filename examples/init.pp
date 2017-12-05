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

#include strongswan
class { 'strongswan': }
class {'strongswan::pki::ca': }

strongswan::secrets { 'peer':
  options => {
    'EAP' => 'qwerty',
  },
}

strongswan::secrets { '%any':
  options => {
    'RSA' => 'serverKey.der',
  },
}

strongswan::logging { '/var/log/strongswan.log':
  logger  => 'filelog',
  options => {
    'time_format' => '%b %e %T',
    'ike_name'    => 'yes',
    'append'      => 'no',
    'default'     => '2',
    'flush_line'  => 'yes',
  },
}

strongswan::logging { 'stderr':
  logger  => 'filelog',
  options => {
    'ike' => '0',
    'knl' => '0',
  },
}
