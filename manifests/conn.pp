# Configure a strongSwan connection configuration.
define strongswan::conn(
  $conn_name = $title,
  $options = {},
) {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['strongswan']) {
    fail('You must include the strongswan base class before using any strongswan defined resources')
  }

  concat::fragment { "ipsec_conf_conn-${conn_name}":
    content => template('strongswan/ipsec_conf_conn.erb'),
    target  => $strongswan::params::ipsec_conf,
    order   => '03',
    notify  => Class['Strongswan::Service']
  }
}
