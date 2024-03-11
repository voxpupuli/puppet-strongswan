# @summary Operating specific default parameters
#
# @api private
class strongswan::params {
  case $facts['os']['family'] {
    'Redhat': {
      $strongswan_dir      = '/etc/strongswan'
      $service_name        = 'strongswan'
      $ipsec_d_dir         = '/etc/strongswan/ipsec.d'
      $ipsec_conf          = '/etc/strongswan/ipsec.conf'
      $ipsec_secrets       = '/etc/strongswan/ipsec.secrets'
      $ca_certificate_dir  = '/etc/strongswan/ipsec.d/cacerts'
      $private_key_dir     = '/etc/strongswan/ipsec.d/private'
      $certificate_dir     = '/etc/strongswan/ipsec.d/certs'
      $charon_conf         = '/etc/strongswan/strongswan.d/charon.conf'
      $charon_conf_dir     = '/etc/strongswan/strongswan.d'
    }
    'Debian': {
      $strongswan_dir      = '/etc/ipsec.d'
      $ipsec_d_dir         = '/etc/ipsec.d'
      $ipsec_conf          = '/etc/ipsec.conf'
      $ipsec_secrets       = '/etc/ipsec.secrets'
      $ca_certificate_dir  = '/etc/ipsec.d/cacerts'
      $private_key_dir     = '/etc/ipsec.d/private'
      $certificate_dir     = '/etc/ipsec.d/certs'
      $charon_conf         = '/etc/strongswan.d/charon.conf'
      $charon_conf_dir     = '/etc/strongswan.d'
      case $facts['os']['name'] {
        'debian': {
          if versioncmp($facts['os']['release']['full'], '11') >= 0 {
            $service_name = 'strongswan-starter'
          } else {
            $service_name = 'strongswan'
          }
        }
        'ubuntu': {
          if versioncmp($facts['os']['release']['full'], '20.04') >= 0 {
            $service_name = 'strongswan-starter'
          } else {
            $service_name = 'strongswan'
          }
        }
        default: {
          fail("Unsupport OS ${facts['os']['name']}")
        }
      }
    }

    default: {
      fail("${facts['os']['family']} is not supported.")
    }
  }
}
