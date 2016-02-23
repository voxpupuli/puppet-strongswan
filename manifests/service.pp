# strongSwan service management.
class strongswan::service(
  $service_name   = $::strongswan::params::service,
) {
  service { $service_name:
    ensure  => running,
    enable  => true,
    require => Class['strongswan'],
  }
}
