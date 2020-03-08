# StrongSwan secrets configuration.
# **$selectors** - list of selectors for current secret(@see ipsec.secrets(5))
define strongswan::secrets(
  Array[String[1]] $selectors = [$title],
  Hash $options               = {},
) {
  concat::fragment { "ipsec_secrets_secret-${title}":
    content => template('strongswan/ipsec_secrets_secret.erb'),
    target  => $strongswan::ipsec_secrets,
    order   => '02',
    require => Class['strongswan'],
    notify  => Class['strongswan::service'],
  }
}
