# Default strongSwan parameters.
class strongswan::params {
  case $::osfamily {
    'Debian': {
      $package             = 'strongswan'
      $ipsec_d_dir         = '/etc/ipsec.d'
      $ipsec_conf          = '/etc/ipsec.conf'
      $ipsec_secrets       = '/etc/ipsec.secrets'
      $charon_conf         = '/etc/strongswan.d/charon.conf'
      $charon_logging_conf = '/etc/strongswan.d/charon-logging.conf'
    }

    'RedHat': {
      $package             = 'strongswan'
      $ipsec_d_dir         = '/etc/strongswan/ipsec.d'
      $ipsec_conf          = '/etc/strongswan/ipsec.conf'
      $ipsec_secrets       = '/etc/strongswan/ipsec.secrets'
      $charon_conf         = '/etc/strongswan/strongswan.d/charon.conf'
      $charon_logging_conf = '/etc/strongswan/strongswan.d/charon-logging.conf'
    }

    default: {
      fail("${::osfamily} is not supported.")
    }
  }

  $service                = 'strongswan'
}
