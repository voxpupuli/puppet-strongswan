# This module manages Strongswan service
#
# Parameters:
#
# There are no default parameters for this class.
#
# Sample Usage:
#
# This class file is not called directly
class strongswan::service {
  service { $strongswan::service_name:
    ensure => $strongswan::service_ensure,
    enable => $strongswan::service_enable,
  }
}
