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
  service { $::strongswan::service_name:
    ensure => running,
    enable => true,
  }
}
