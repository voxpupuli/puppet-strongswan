# @summary Manages the Strongswan 'setup' section in ipsec.conf
#
# @param options
#   The hash of options to configure
#
# @example Sample Usage
#   class { 'strongswan::setup':
#     options => {
#       'strictcrlpolicy' => 'yes',
#       'uniqueids'       => 'never',
#       }
#     }
#   }
class strongswan::setup(
  Hash $options = {},
) {
  include strongswan

  concat::fragment { 'ipsec_conf_setup':
    content => template('strongswan/ipsec_conf_setup.erb'),
    target  => $strongswan::ipsec_conf,
    order   => '02',
  }
}
