# Class: strongswan::config
#
# This module manages Strongswan basic configuration
#
# Parameters:
#
# There are no default parameters for this class.
#
# Sample Usage:
#
# This class file is not called directly

class strongswan::config {

  file { 'ipsec.d':
    ensure => directory,
    path   => $::strongswan::ipsec_d_dir,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { 'ipsec.d/private':
    ensure => directory,
    path   => "${::strongswan::ipsec_d_dir}/private",
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  concat {  $strongswan::params::ipsec_conf:
    mode  => '0644',
    owner => 'root',
    group => 'root',
  }

  concat::fragment { 'ipsec_conf_header':
    content => template('strongswan/ipsec_conf_header.erb'),
    target  => $::strongswan::ipsec_conf,
    order   => '01',
  }

  concat {  $strongswan::params::ipsec_secrets:
    mode  => '0600',
    owner => 'root',
    group => 'root',
  }

  concat::fragment { 'ipsec_secrets_header':
    content => template('strongswan/ipsec_secrets_header.erb'),
    target  => $::strongswan::ipsec_secrets,
    order   => '01',
  }
}
