# puppet-strongswan [![Build Status](https://travis-ci.org/CommanderK5/puppet-strongswan.svg?branch=master)](https://travis-ci.org/CommanderK5/puppet-strongswan)

This Puppet module contains configurations for strongSwan. 
## Example usage

strongSwan default config:

```puppet
include strongswan
```

### Default configuration

*conn %default* configurations can be set as follows:
```puppet
strongswan::conn { '%default':
  options => {
    "ike"         => "aes128gcm128-prfsha256-ecp256!",
    "esp"         => "aes128gcm128-ecp256!",
    "keyexchange" => "ikev2",
    "ikelifetime" => "60m",
    "lifetime"    => "20m",
    "margintime"  => "3m",
    "closeaction" => "restart",
    "dpdaction"   => "restart",
  }
}
```

Parameters for an IPsec gateway server:

```puppet
strongswan::conn { 'IPsec-IKEv2':
  options => {
    "rekey"         => "no",
    "left"          => "%any",
    "leftsubnet"    => "0.0.0.0/0",
    "leftcert"      => "vpnHostCert.der",
    "right"         => "%any",
    "rightdns"      => "8.8.8.8,8.8.4.4",
    "rightsourceip" => "10.10.10.0/24",
    "auto"          => "add",
  }
}

strongswan::conn { 'IKEv2-EAP':
  options => {
    "also"          => "IPSec-IKEv2",
    "leftauth"      => "pubkey",
    "leftsendcert"  => "always",
    "rightauth"     => "eap-mschapv2",
    "rightsendcert" => "never",
    "eap_identity"  => "%any",
  }

strongswan::secrets { '%any':
  options => {
    'RSA' => 'vpnHostKey.der keypass'
  }
}

strongswan::secrets { 'John':
  options => {
    'EAP' => 'SuperSecretPass'
  }
}
```
logging configuration example:

```puppet
strongswan::logging { '/var/log/strongswan.log':
  logger  => 'filelog',
  options => {
    'time_format' => '%b %e %T',
    'ike_name'    => 'yes',
    'append'      => 'no',
    'default'     => '2',
    'flush_line'  => 'yes'
  }
}
```
```puppet
strongswan::logging { 'stderr':
  logger  => 'filelog',
  options => {
    'ike' => '0',
    'knl' => '0'
  }
}
```

charon daemon configuration example:

```puppet
class { 'strongswan::charon':
  initiator_only        => "yes",
  integrity_test        => "yes",
  crypto_test_on_add    => "yes",
  crypto_test_on_create => "yes",
  crypto_test_required  => "yes",
}
```

### Setup configuration

The IPsec 'config setup' section:

```puppet
class { 'strongswan::setup':
  options => {
    'charondebug'     => '"ike 2, knl 2, cfg 2"'
  }
}
```

## License

See [LICENSE](LICENSE) file.
