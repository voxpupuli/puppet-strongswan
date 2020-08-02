# @summary Manage strongswan certificates
#
# @param common_name
#   The certificate `Common Name (CN)`
# @param country_code
#   The certificate `Country Code (C)`
# @param organization
#   The certificate `Organization (O)`
# @param san
#   An Array of `Subject Alternative Names`
# @param p12_password
#   An optional `PKCS#12` password for the certificate
#
# @example Add a certificate
#   strongswan::pki::certificate {'server':
#     common_name => 'myvpn.local',
#     san         => ['@strongswan-1','strongswan-1','192.168.33.42', '@192.168.33.42']
#   }
define strongswan::pki::certificate (
  String[1]           $common_name  = fact('fqdn'),
  String[2]           $country_code = 'GB',
  String[1]           $organization = 'Strongswan',
  Array[String[1]]    $san          = ['localhost'],
  Optional[String[1]] $p12_password = undef,
) {
  require strongswan::pki::ca

  $ca_name            = $strongswan::pki::ca::ca_name
  $ca_certificate_dir = $strongswan::ca_certificate_dir
  $ca_private_key_dir = $strongswan::private_key_dir
  $certificate_dir    = $strongswan::certificate_dir
  $private_key_dir    = $strongswan::private_key_dir
  $strongswan_dir     = $strongswan::strongswan_dir

  $san_arr = $san.map | $s | { "--san ${s}" }
  $san_str = join($san_arr,' ')

  exec { "${title} private key":
    command => "${strongswan::pki::ca::pki_command} pki --gen --type rsa --size 2048 --outform der > ${private_key_dir}/${title}.der",
    creates => ["${private_key_dir}/${title}.der"],
    path    => ['/usr/bin', '/usr/sbin'],
  }

  file { "${private_key_dir}/${title}.der":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Exec["${title} private key"],
  }

  exec { "${title} certificate":
    command => "${strongswan::pki::ca::pki_command} pki --pub --in ${private_key_dir}/${title}.der --type rsa | ${strongswan::pki::ca::pki_command} pki --issue --lifetime 730 --cacert ${ca_certificate_dir}/${ca_name}.crt --cakey ${ca_private_key_dir}/${ca_name}.der --dn \"C=${country_code}, O=${organization}, CN=${common_name}\" ${san_str} --flag serverAuth --flag ikeIntermediate --outform der > ${certificate_dir}/${title}.crt",
    creates => ["${certificate_dir}/${title}.crt"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => File["${private_key_dir}/${title}.der"],
  }

  exec { "Convert RSA key ${title} from DER to PEM format":
    command => "openssl rsa -inform DER -in ${private_key_dir}/${title}.der -out ${private_key_dir}/${title}.pem -outform PEM",
    cwd     => $strongswan_dir,
    creates => ["${private_key_dir}/${title}.pem"],
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

  exec { "Convert certificate ${title} from DER to PEM format":
    command => "openssl x509 -inform DER -in ${certificate_dir}/${title}.crt -out ${certificate_dir}/${title}.pem -outform PEM",
    cwd     => $strongswan_dir,
    creates => ["${certificate_dir}/${title}.pem"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => Exec["${title} certificate"],
  }

  if $p12_password {
    exec { "Create a PKCS#12 container for ${title}":
      command => "openssl pkcs12 -in ${certificate_dir}/${title}.pem -inkey ${private_key_dir}/${title}.pem -certfile ${ca_certificate_dir}/${ca_name}.pem -export -password pass:${p12_password} -out ${certificate_dir}/${title}.p12",
      cwd     => $strongswan_dir,
      creates => ["${certificate_dir}/${title}.p12"],
      path    => ['/usr/bin', '/usr/sbin'],
      require => [
        Exec["Convert RSA key ${title} from DER to PEM format"],
        Exec["Convert certificate ${title} from DER to PEM format"],
      ],
    }
  }
}
