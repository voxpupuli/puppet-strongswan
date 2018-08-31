# Define strongswan::pki::certificate
# ===========================
#
# Manage strongswan certificates
#
# Example configuration:
# ===========================
#
# strongswan::pki::certificate {'server':
#   common_name => 'myvpn.local',
#   san         => ['@strongswan-1','strongswan-1','192.168.33.42', '@192.168.33.42']
# }



define strongswan::pki::certificate (
  $ca_name            = $strongswan::pki::ca::ca_name,
  $ca_certificate_dir = $strongswan::ca_certificate_dir,
  $ca_private_key_dir = $strongswan::private_key_dir,
  $certificate_dir    = $strongswan::certificate_dir,
  $private_key_dir    = $strongswan::private_key_dir,
  $strongswan_dir     = $strongswan::strongswan_dir,
  $common_name        = fact('fqdn'),
  $country_code       = 'GB',
  $organization       = 'Strongswan',
  $san                = ['localhost'],
  $p12_password       = undef,
  ){

  $san_arr = $san.map | $s | { "--san ${s}" }
  $san_str = join($san_arr,' ')

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
    command => "strongswan pki --pub --in ${private_key_dir}/${title}.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ${ca_certificate_dir}/${ca_name}.crt --cakey ${ca_private_key_dir}/${ca_name}.der --dn \"C=${country_code}, O=${organization}, CN=${common_name}\" ${san_str} --flag serverAuth --flag ikeIntermediate --outform der > ${certificate_dir}/${title}.crt",
    creates => [ "${certificate_dir}/${title}.crt"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => File["${private_key_dir}/${title}.der"],
  }

  exec {"Convert RSA key ${title} from DER to PEM format":
    command => "openssl rsa -inform DER -in ${private_key_dir}/${title}.der -out ${private_key_dir}/${title}.pem -outform PEM",
    cwd     => $strongswan_dir,
    creates => [ "${private_key_dir}/${title}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec["${title} private key"],
  }

  file { "${private_key_dir}/${title}.pem":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec["Convert RSA key ${title} from DER to PEM format"],
  }

  exec {"Convert certificate ${title} from DER to PEM format":
    command => "openssl x509 -inform DER -in ${certificate_dir}/${title}.crt -out ${certificate_dir}/${title}.pem -outform PEM",
    cwd     => $strongswan_dir,
    creates => [ "${certificate_dir}/${title}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec["${title} certificate"],
    notify  => Class['Strongswan::Service'],
  }

  if $p12_password {
    exec {"Create a PKCS#12 container for ${title}":
      command => "openssl pkcs12 -in ${certificate_dir}/${title}.pem -inkey ${private_key_dir}/${title}.pem -certfile ${ca_certificate_dir}/${ca_name}.pem -export -password pass:${p12_password} -out ${certificate_dir}/${title}.p12",
      cwd     => $strongswan_dir,
      creates => [ "${certificate_dir}/${title}.p12"],
      path    => ['/usr/bin', '/usr/sbin'],
      require => [
        Exec["Convert RSA key ${title} from DER to PEM format"],
        Exec["Convert certificate ${title} from DER to PEM format"],
      ],
    }
  }

}
