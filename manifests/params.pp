# Default Strongswan params
#
# This class file is not called directly
class strongswan::params {
  case fact('osfamily') {
    'Redhat': {
      $package             = 'strongswan'
      $strongswan_dir      = '/etc/strongswan'
      $ipsec_d_dir         = '/etc/strongswan/ipsec.d'
      $ipsec_conf          = '/etc/strongswan/ipsec.conf'
      $ipsec_secrets       = '/etc/strongswan/ipsec.secrets'
      $ca_certificate_dir  = '/etc/strongswan/ipsec.d/cacerts'
      $private_key_dir     = '/etc/strongswan/ipsec.d/private'
      $certificate_dir     = '/etc/strongswan/ipsec.d/certs'
      $charon_conf         = '/etc/strongswan/strongswan.d/charon.conf'
      $charon_logging_conf = '/etc/strongswan/strongswan.d/charon-logging.conf'
      $charon_conf_dir     = '/etc/strongswan/strongswan.d'
      $service             = 'strongswan'
    }
    'Debian': {
      $package             = 'strongswan'
      $strongswan_dir      = '/etc/ipsec.d'
      $ipsec_d_dir         = '/etc/ipsec.d'
      $ipsec_conf          = '/etc/ipsec.conf'
      $ipsec_secrets       = '/etc/ipsec.secrets'
      $ca_certificate_dir  = '/etc/ipsec.d/cacerts'
      $private_key_dir     = '/etc/ipsec.d/private'
      $certificate_dir     = '/etc/ipsec.d/certs'
      $charon_conf         = '/etc/strongswan.d/charon.conf'
      $charon_logging_conf = '/etc/strongswan.d/charon-logging.conf'
      $charon_conf_dir     = '/etc/strongswan.d'
      $service             = 'strongswan'
    }

    default: {
      fail("${fact('osfamily')} is not supported.")
    }
  }
}
