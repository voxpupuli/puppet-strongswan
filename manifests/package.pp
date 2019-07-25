# Class strongswan::package
#
# This module manages Strongswan package installation
#
# Parameters:
#
# There are no default parameters for this class.
#
# Sample Usage:
#
# This class file is not called directly

class strongswan::package {

  package { $strongswan::package_name:
    ensure => $strongswan::package_ensure,
  }
}
