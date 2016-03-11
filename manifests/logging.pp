define strongswan::logging (
  $logger,
  $key        = $title,
  $options    = {},
  $identifier = false,
) {
  # The base class must be included first because it is used by parameter
  # defaults.
  if ! defined(Class['strongswan']) {
    fail('You must include the strongswan base class before using any strongswan defined resources')
  }

  validate_hash($options)

  concat::fragment { "charon_logging-${title}":
    content => template('strongswan/charon-logging.conf.erb'),
    target  => $strongswan::params::charon_logging_conf,
    order   => '05',
  }
}
