# Default Strongswan params
#
# This class file is not called directly
class strongswan::params {
  case $::osfamily {
    'Redhat': {
      $package             = 'strongswan'
      $ipsec_d_dir         = '/etc/strongswan/ipsec.d'
      $ipsec_conf          = '/etc/strongswan/ipsec.conf'
      $ipsec_secrets       = '/etc/strongswan/ipsec.secrets'
      $charon_conf         = '/etc/strongswan/strongswan.d/charon.conf'
      $charon_logging_conf = '/etc/strongswan/strongswan.d/charon-logging.conf'
      $charon_conf_dir     = '/etc/strongswan/strongswan.d'
      $service             = 'strongswan'
    },
    'Debian': {
      $package             = 'strongswan'
      $ipsec_d_dir         = '/etc/ipsec.d'
      $ipsec_conf          = '/etc/ipsec.conf'
      $ipsec_secrets       = '/etc/ipsec.secrets'
      $charon_conf         = '/etc/strongswan.d/charon.conf'
      $charon_logging_conf = '/etc/strongswan.d/charon-logging.conf'
      $charon_conf_dir     = '/etc/strongswan.d'
      $service             = 'strongswan'
    }

    default: {
      fail("${::osfamily} is not supported.")
    }
  }
}
