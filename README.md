# puppet-strongswan [![Build Status](https://travis-ci.org/CommanderK5/puppet-strongswan.svg?branch=master)](https://travis-ci.org/CommanderK5/puppet-strongswan)

This Puppet module contains configurations for Strongswan.
## Example usage

### StrongSwan default config:

```puppet
include strongswan
```

### Strongswan self-signed CA:

```puppet
include strongswan::pki::ca
```

### Strongswan certificates management:

strongswan::pki::certificate {'server':
  common_name => 'myvpn.local',
  san         => ['@strongswan-1','strongswan-1','192.168.33.42', '@192.168.33.42'],
}

strongswan::pki::certificate {'John Smith':
  common_name  => 'Jonh Smith',
  p12_password => 'mySuperStrongPass',
}

### Example configuration ipsec.conf:

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
```

### ipsec.secrets

```puppet
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

### charon daemon configuration example:

```puppet
strongswan::charon { 'dns':
  options => {
    'dns1' => '8.8.8.8',
    'dns2' => '8.8.4.4'
  }
}
```

### charon logging configuration example:

```puppet
strongswan::charon { '/var/log/vpn.log':
  options => {
    'filelog' => {
      '/var/log/vpn.log' => {
        'time_format' => '%b %e %T',
        'ike_name'    => 'yes',
        'append'      => 'no',
        'default'     => '1',
        'flush_line'  => 'yes',
      },
      'stderr' => {
        'ike' => '2',
        'knl' => '2',
      }
    }
  }
}
```

### Setup configuration

### The IPsec 'config setup' section in ipsec.conf:

```puppet
class { 'strongswan::setup':
  options => {
    'charondebug' => '"ike 2, knl 2, cfg 2"'
  }
}
```

## License

MIT License
