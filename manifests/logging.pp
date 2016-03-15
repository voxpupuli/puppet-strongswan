# Define strongswan::logging
# ===========================
#
# Manage strongswan charon-logging.conf
#
# Example configuration:
# ===========================
#
# include strongswan
# strongswan::logging { '/var/log/strongswan.log':
#   logger  => 'filelog',
#   options => {
#     'time_format' => '%b %e %T',
#     'ike_name'    => 'yes',
#     'append'      => 'no',
#     'default'     => '2',
#     'flush_line'  => 'yes'
#   }
# }
#
# Paramseters
# ==========================
#
# ```logger```
# filelog or syslog
# 
# ```key```
# case filelog selected as logger, key is either a file in the filesystem or one of stdout, or stderr
# case syslog selected as logger, key is one of auth, or daemon

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
