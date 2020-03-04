# Configure charon pluging
define strongswan::charon::plugin (
  $options    = {},
) {

  file {"charon_plugin_${name}":
    ensure  => present,
    path    => "${strongswan::charon_conf_dir}/charon/${name}.conf",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template('strongswan/charon_plugin.conf.erb'),
    require => Class['strongswan'],
    notify  => Class['strongswan::service'],
  }
}
