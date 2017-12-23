# Class: strongswan::setup
#
# This module manages Strongswan 'setup' section in ipsec.conf
#
# Sample Usage:
#
# class{'strongswan::setup':
#   options => {
#     'strictcrlpolicy' => 'yes',
#     'uniqueids'       => 'never',
#     }
#   }
# }
#

class strongswan::setup(
  $options = {},
) {
  concat::fragment { 'ipsec_conf_setup':
    content => template('strongswan/ipsec_conf_setup.erb'),
    target  => $::strongswan::ipsec_conf,
    order   => '02',
    require => Class['Strongswan'],
    notify  => Class['Strongswan::Service'],
  }
}
