# @summary This class manages the Strongswan service
#
# @api private
class strongswan::service {
  if ($strongswan::service_manage) {
    service { $strongswan::service_name:
      ensure => $strongswan::service_ensure,
      enable => $strongswan::service_enable,
    }
  }
}
