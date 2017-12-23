# Class: strongswan::pki::ca
#
# This module manages Strongswan CA
#
# Example configuration:
# =======================
#
# #Default:
# include strongswan::pki::ca
#
#
# #With Params:
# class {'strongswan::pki::ca':
#   $common_name     => 'myVPN',
#   $country_code    => 'XX',
#   $organization    => 'myOrg',
# }

class strongswan::pki::ca (
  $certificate_dir = '/etc/strongswan/ipsec.d/cacerts',
  $private_key_dir = '/etc/strongswan/ipsec.d/private',
  $common_name     = 'strongswanCA',
  $country_code    = 'GB',
  $organization    = 'Strongswan',
){

  $ca_name = regsubst($common_name, ' ', '_', 'G')

  exec {'Create CA private key':
    command => "strongswan pki --gen --type rsa --size 4096 --outform der > ${private_key_dir}/${ca_name}.der",
    cwd     => '/etc/strongswan',
    creates => [ "${private_key_dir}/${ca_name}.der"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Class['strongswan'],
  }

  file { "${private_key_dir}/${ca_name}.der":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec['Create CA private key'],
  }

  exec {'Create self-signed CA certificate':
    command => "strongswan pki --self --ca --lifetime 3650 --in ${private_key_dir}/${ca_name}.der --type rsa --dn \"C=${country_code}, O=${organization}, CN=${common_name}\" --outform der > ${certificate_dir}/${ca_name}.crt",
    cwd     => '/etc/strongswan',
    creates => [ "${certificate_dir}/${ca_name}.crt"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => File["${private_key_dir}/${ca_name}.der"],
  }

  exec {'Convert CA certificate from DER to PEM format':
    command => "openssl x509 -inform DER -in ${certificate_dir}/${ca_name}.crt -out ${certificate_dir}/${ca_name}.pem -outform PEM",
    cwd     => '/etc/strongswan',
    creates => [ "${certificate_dir}/${ca_name}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec['Create self-signed CA certificate'],
    notify  => Class['Strongswan::Service'],
  }

}
