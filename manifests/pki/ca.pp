# @summary This class manages the Strongswan CA
#
# @param common_name
#   The Certificate Authority `Common Name (CN)`
# @param country_code
#   The Certificate Authority `Country Code (C)`
# @param organization
#   The Certificate Authority `Organization (O)`
#
# @example Default CA configuration
#   include strongswan::pki::ca
#
# @example Configure the CA with custom options
#   class {'strongswan::pki::ca':
#     $common_name  => 'myVPN',
#     $country_code => 'XX',
#     $organization => 'myOrg',
#   }
class strongswan::pki::ca (
  String[1] $common_name  = 'strongswanCA',
  String[2] $country_code = 'GB',
  String[1] $organization = 'Strongswan',
){
  require strongswan::package

  $ca_certificate_dir = $strongswan::ca_certificate_dir
  $private_key_dir    = $strongswan::private_key_dir
  $ipsec_dir          = $strongswan::ipsec_d_dir
  $strongswan_dir     = $strongswan::strongswan_dir

  $ca_name = regsubst($common_name, ' ', '_', 'G')

  if $facts['os']['family'] == 'Debian' {
    unless $facts['os']['release']['major'] == '16.04' or $facts['os']['release']['major'] == '8' {
      ensure_packages(['strongswan-pki'])
      Package['strongswan-pki'] -> Exec['Create CA private key']
    }
    $pki_command = 'ipsec'
  } else {
    $pki_command = 'strongswan'
  }

  exec {'Create CA private key':
    command => "${pki_command} pki --gen --type rsa --size 4096 --outform der > ${private_key_dir}/${ca_name}.der",
    cwd     => $strongswan_dir,
    creates => [ "${private_key_dir}/${ca_name}.der"],
    path    => ['/usr/bin', '/usr/sbin'],
  }

  file { "${private_key_dir}/${ca_name}.der":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec['Create CA private key'],
  }

  exec {'Create self-signed CA certificate':
    command => "${pki_command} pki --self --ca --lifetime 3650 --in ${private_key_dir}/${ca_name}.der --type rsa --dn \"C=${country_code}, O=${organization}, CN=${common_name}\" --outform der > ${ca_certificate_dir}/${ca_name}.crt",
    cwd     => $strongswan_dir,
    creates => [ "${ca_certificate_dir}/${ca_name}.crt"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => File["${private_key_dir}/${ca_name}.der"],
  }

  exec {'Convert CA certificate from DER to PEM format':
    command => "openssl x509 -inform DER -in ${ca_certificate_dir}/${ca_name}.crt -out ${ca_certificate_dir}/${ca_name}.pem -outform PEM",
    cwd     => $strongswan_dir,
    creates => [ "${ca_certificate_dir}/${ca_name}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec['Create self-signed CA certificate'],
  }

  Class['strongswan::pki::ca'] ~> Class['strongswan::service']
}
