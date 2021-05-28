# @summary This class manages Strongswan package installation
#
# @api private
class strongswan::package {
  include strongswan

  if ($strongswan::package_manage) {
    package { $strongswan::package_name:
      ensure => $strongswan::package_ensure,
    }
  }
}
