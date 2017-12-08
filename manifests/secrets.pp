# Configure a strongSwan secrets configuration.
define strongswan::secrets(
  $options = {},
) {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['strongswan']) {
    fail('You must include the strongswan base class before using any strongswan defined resources')
  }

  concat::fragment { "ipsec_secrets_secret-${title}":
    content => template('strongswan/ipsec_secrets_secret.erb'),
    target  => $strongswan::params::ipsec_secrets,
    order   => '02',
    notify  => Class['Strongswan::Service']
  }
}
