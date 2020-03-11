# @summary Manage strongswan charon config files
#
# @param options
#   charon options hash
#
# @example Define file loggers in charon_log.conf file
#   strongswan::charon { 'log':
#     options => {
#       'filelog' => {
#         '/var/log/strongswan.log' => {
#           'time_format' => '%b %e %T',
#           'ike_name'    => 'yes',
#           'append'      => 'no',
#           'default'     => '1',
#           'flush_line'  => 'yes',
#         },
#         'stderr' => {
#           'ike' => '2',
#           'knl' => '2',
#         },
#       },
#     },
#   }
define strongswan::charon (
  Hash $options = {},
) {
  require strongswan::package

  $fname = regsubst($title, '\W', '_', 'G')

  file { "charon_${fname}":
    ensure  => file,
    path    => "${strongswan::charon_conf_dir}/charon_${fname}.conf",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template('strongswan/charon.conf.erb'),
  }
}
