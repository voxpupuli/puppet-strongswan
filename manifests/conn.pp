# Configure a strongSwan connection configuration.
define strongswan::conn(
  $conn_name = $title,
  $options = {},
) {
  concat::fragment { "ipsec_conf_conn-${conn_name}":
    content => template('strongswan/ipsec_conf_conn.erb'),
    target  => $strongswan::ipsec_conf,
    order   => '03',
    require => Class['Strongswan'],
    notify  => Class['Strongswan::Service'],
  }
}
