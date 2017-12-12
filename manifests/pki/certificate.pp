# Define: name
 # Parameters:
 # arguments
 #
define strongswan::pki::certificate (
  $ca_name            = $strongswan::pki::ca::ca_name,
  $ca_certificate_dir = $strongswan::pki::ca::certificate_dir,
  $ca_private_key_dir = $strongswan::pki::ca::private_key_dir,
  $certificate_dir    = '/etc/strongswan/ipsec.d/certs',
  $private_key_dir    = '/etc/strongswan/ipsec.d/private',
  $common_name        = $::fqdn,
  $country_code       = 'GB',
  $organization       = 'Strongswan',
  $san                = ['localhost'],
  $p12_password       = 'xyz123',
  ){

  $san_arr = $san.map | $s | { "--san $s" }
  $san_str = join($san_arr," ")

  exec {"${title} private key":
    command => "strongswan pki --gen --type rsa --size 2048 --outform der > ${private_key_dir}/${title}.der",
    creates => [ "${private_key_dir}/${title}.der"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Class['strongswan::pki::ca'],
  }

  file { "${private_key_dir}/${title}.der":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec["${title} private key"],
  }

  exec {"${title} certificate":
    command => "strongswan pki --pub --in ${private_key_dir}/${title}.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ${ca_certificate_dir}/${ca_name}.der --cakey ${ca_private_key_dir}/${ca_name}.der --dn \"C=${country_code}, O=${organization}, CN=${common_name}\" ${san_str} --flag serverAuth --flag ikeIntermediate --outform der > ${certificate_dir}/${title}.crt",
    creates => [ "${certificate_dir}/${title}.crt"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => File["${private_key_dir}/${title}.der"],
  }

  exec {"Convert RSA kay ${title} from DER to PEM format":
    command => "openssl rsa -inform DER -in ${private_key_dir}/${title}.der -out ${private_key_dir}/${title}.pem -outform PEM",
    cwd     => "/etc/strongswan",
    creates => [ "${private_key_dir}/${title}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec["${title} private key"],
  }

  exec {"Convert certificate ${title} from DER to PEM format":
    command => "openssl x509 -inform DER -in ${certificate_dir}/${title}.crt -out ${certificate_dir}/${title}.pem -outform PEM",
    cwd     => "/etc/strongswan",
    creates => [ "${certificate_dir}/${title}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec["${title} certificate"],
  }

  exec {"Create a PKCS#12 container for ${title}":
    command => "openssl pkcs12 -in ${certificate_dir}/${title}.pem -inkey ${private_key_dir}/${title}.pem -certfile ${ca_certificate_dir}/${ca_name}.pem -export -password pass:${p12_password} -out ${certificate_dir}/${title}.p12",
    cwd     => "/etc/strongswan",
    creates => [ "${certificate_dir}/${title}.p12"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => [
      Exec["Convert RSA kay ${title} from DER to PEM format"],
      Exec["Convert certificate ${title} from DER to PEM format"],
    ]
  }

}
