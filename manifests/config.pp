# @summary Manages Strongswan basic configuration
#
# @api private
class strongswan::config {
  file { 'ipsec.d':
    ensure => directory,
    path   => $strongswan::ipsec_d_dir,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { 'ipsec.d/private':
    ensure => directory,
    path   => "${strongswan::ipsec_d_dir}/private",
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  concat { $strongswan::ipsec_conf:
    mode  => '0644',
    owner => 'root',
    group => 'root',
  }

  concat::fragment { 'ipsec_conf_header':
    content => template('strongswan/ipsec_conf_header.erb'),
    target  => $strongswan::ipsec_conf,
    order   => '01',
  }

  concat { $strongswan::ipsec_secrets:
    mode      => '0600',
    owner     => 'root',
    group     => 'root',
    show_diff => false,
    backup    => false,
  }

  concat::fragment { 'ipsec_secrets_header':
    content => template('strongswan/ipsec_secrets_header.erb'),
    target  => $strongswan::ipsec_secrets,
    order   => '01',
  }
}
