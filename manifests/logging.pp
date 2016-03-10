define strongswan::logging (
  $logger         = 'filelog',
  $options        = {},
) {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['strongswan']) {
    fail('You must include the strongswan base class before using any strongswan defined resources')
  }

  validate_hash($options)
  
   file { 'charon-logging.conf':
    ensure  => present,
    path    => $strongswan::params::charon_logging_conf,
    content => template("strongswan/charon-logging.conf.erb"),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$strongswan::params::package],
    notify  => Class['Strongswan::Service'],
  }

  concat::fragment { "${title}-${logger}":
    content => template('strongswan/ipsec_conf_conn.erb'),
    target  => $strongswan::params::ipsec_conf,
    order   => '03',
  }
}
