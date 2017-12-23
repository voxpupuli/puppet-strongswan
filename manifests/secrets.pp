# Configure a strongSwan secrets configuration.
define strongswan::secrets(
  $options = {},
) {
  concat::fragment { "ipsec_secrets_secret-${title}":
    content => template('strongswan/ipsec_secrets_secret.erb'),
    target  => $::strongswan::ipsec_secrets,
    order   => '02',
    require => Class['strongswan'],
    notify  => Class['strongswan::service'],
  }
}
