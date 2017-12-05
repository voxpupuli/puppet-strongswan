class strongswan::pki::ca (
  $caname              = 'strongswanCA',
  $server_country_code = 'GB',
  $server_organization = 'Strongswan',
  $server_san          = 'localhost',
  $server_ip           = '127.0.0.1',
  $server_key_name     = 'server'
  ){


  exec {'Create CA private key':
    command => "strongswan pki --gen --type rsa --size 4096 --outform der > ipsec.d/private/${caname}Key.der",
    cwd     => "/etc/strongswan",
    creates => [ "/etc/strongswan/ipsec.d/private/${caname}Key.der"],
    path    => ['/usr/bin', '/usr/sbin']
  } ->

  file { "/etc/strongswan/ipsec.d/private/${caname}Key.der":
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600'
  } ->

  exec {'Create self-signed CA certificate':
    command => "strongswan pki --self --ca --lifetime 3650 --in ipsec.d/private/${caname}Key.der --type rsa --dn \"CN=${caname}\" --outform der > ipsec.d/cacerts/${caname}Cert.der",
    cwd     => "/etc/strongswan",
    creates => [ "/etc/strongswan/ipsec.d/cacerts/${caname}Cert.der"],
    path    => ['/usr/bin', '/usr/sbin']
  }->

  exec {"Convert CA certificate from DER to PEM format":
    command => "openssl x509 -inform DER -in ipsec.d/cacerts/${caname}Cert.der -out ipsec.d/cacerts/${caname}Cert.pem -outform PEM",
    cwd     => "/etc/strongswan",
    creates => [ "/etc/strongswan/ipsec.d/cacerts/${caname}Cert.pem"],
    path    => ['/usr/bin', '/usr/sbin']
  }->

  exec {'VPN Server private key':
    command => "strongswan pki --gen --type rsa --size 2048 --outform der > ipsec.d/private/${server_key_name}Key.der",
    cwd     => "/etc/strongswan",
    creates => [ "/etc/strongswan/ipsec.d/private/${server_key_name}Key.der"],
    path    => ['/usr/bin', '/usr/sbin']
  }->

  file { "/etc/strongswan/ipsec.d/private/${server_key_name}Key.der":
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600'
  }->

  exec {'VPN Server certificate':
    command => "strongswan pki --pub --in ipsec.d/private/${server_key_name}Key.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ipsec.d/cacerts/${caname}Cert.der --cakey ipsec.d/private/${caname}Key.der --dn \"C=${server_country_code}, O=${server_organization}, CN=${::fqdn}\" --san ${server_san} --san @${server_san} --san ${server_ip} --san @${server_ip} --flag serverAuth --flag ikeIntermediate --outform der > ipsec.d/certs/${server_key_name}Cert.der",
    cwd     => "/etc/strongswan",
    creates => [ "/etc/strongswan/ipsec.d/certs/${server_key_name}Cert.der"],
    path    => ['/usr/bin', '/usr/sbin']
  }
}
