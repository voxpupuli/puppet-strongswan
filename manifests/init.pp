# Default strongSwan class.
class strongswan(
  $package_name = $strongswan::params::package,
  $service_name = $strongswan::params::service,
) inherits strongswan::params {
  package { $package_name:
    ensure => installed,
    before => File['ipsec.d'],
  }

  class { '::strongswan::service':
    service_name => $service_name,
  }

  file { 'ipsec.d':
    ensure => directory,
    path   => $strongswan::params::ipsec_d_dir,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { 'ipsec.d/private':
    ensure => directory,
    path   => "${strongswan::params::ipsec_d_dir}/private",
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  concat { $strongswan::params::charon_logging_conf:
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    notify  => Class['Strongswan::Service'],
  }

  concat::fragment { 'charon_logging_header':
    content => "charon {\n",
    target  => $strongswan::params::charon_logging_conf,
    order   => '01',
    require => Package[$package_name],
    notify  => Class['Strongswan::Service'],
  }

  concat::fragment { 'charon_logging_footer':
    content => "\n}",
    target  => $strongswan::params::charon_logging_conf,
    order   => '99',
    require => Package[$package_name],
    notify  => Class['Strongswan::Service'],
  }

  concat {  $strongswan::params::ipsec_conf:
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    notify  => Class['Strongswan::Service'],
  }


  concat::fragment { 'ipsec_conf_header':
    content => template('strongswan/ipsec_conf_header.erb'),
    target  => $strongswan::params::ipsec_conf,
    order   => '01',
  }

  concat {  $strongswan::params::ipsec_secrets:
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    notify  => Class['Strongswan::Service'],
  }

  concat::fragment { 'ipsec_secrets_header':
    content => template('strongswan/ipsec_secrets_header.erb'),
    target  => $strongswan::params::ipsec_secrets,
    order   => '01',
  }
}

