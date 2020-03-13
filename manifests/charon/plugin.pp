# @summary Configure charon plugin
#
# @param options
#   plugin configuration options
#
# @example enable plugin
#   strongswan::charon::plugin { 'eap-radius':
#     options => {
#       'load'   => 'yes',
#       'secret' => '$ecRet',
#     }
#   }
#
# @example disable plugin
#   strongswan::charon::plugin { 'revocation':
#     options => {
#       'load' => 'no',
#     }
#   }
define strongswan::charon::plugin (
  Hash $options = {},
) {
  require strongswan::package

  file { "charon_plugin_${name}":
    ensure  => file,
    path    => "${strongswan::charon_conf_dir}/charon/${name}.conf",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => epp('strongswan/charon_plugin.conf.epp',
                  {name => $name, options => $options}),
  }
}
