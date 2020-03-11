# Configure charon plugin
# @param [Hash] options
#   plugin configuration options
#
# @example enable plugin
#   strongswan::charon::plugin{'eap-radius':
#     options => {
#       'load'   => 'yes',
#       'secret' => '$ecRet',
#     }
#
# @example disable plugin
#   strongswan::charon::plugin{'revocation':
#     options => {
#       'load' => 'no'
#     }
#

define strongswan::charon::plugin (
  Hash $options = {},
) {

  file {"charon_plugin_${name}":
    ensure  => present,
    path    => "${strongswan::charon_conf_dir}/charon/${name}.conf",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => epp('strongswan/charon_plugin.conf.epp',
                  {name => $name, options => $options}),
    require => Class['strongswan'],
    notify  => Class['strongswan::service'],
  }
}
