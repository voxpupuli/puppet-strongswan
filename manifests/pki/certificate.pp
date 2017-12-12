# Define: name
 # Parameters:
 # arguments
 #
define strongswan::pki::certificate (
  $ca_cert_path     = '/etc/strongswan/ipsec.d/cacerts/strongswanCA.der',
  $ca_kay_path      = '/etc/strongswan/ipsec.d/private/strongswanCA.der',
  $certificate_dir  = '/etc/strongswan/ipsec.d/certs',
  $private_key_dir  = '/etc/strongswan/ipsec.d/private',
  $common_name      = $::fqdn,
  $country_code     = 'GB',
  $organization     = 'Strongswan',
  $san              = ['localhost'],
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
    command => "strongswan pki --pub --in ${private_key_dir}/${title}.der --type rsa | strongswan pki --issue --lifetime 730 --cacert ${ca_cert_path} --cakey ${ca_kay_path} --dn \"C=${country_code}, O=${organization}, CN=${common_name}\" ${san_str} --flag serverAuth --flag ikeIntermediate --outform der > ${certificate_dir}/${title}.crt",
    creates => [ "${certificate_dir}/${title}.crt"],
    path    => ['/usr/bin', '/usr/sbin'],
    require => File["${private_key_dir}/${title}.der"],
  }

}
