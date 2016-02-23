# puppet-strongswan [![Build Status](https://travis-ci.org/CommanderK5/puppet-strongswan.svg?branch=master)](https://travis-ci.org/CommanderK5/puppet-strongswan)

cloned from https://github.com/jpds/puppet-strongswan

This Puppet module contains configurations for strongSwan. 
## Example usage

strongSwan can be installed by simply doing:

```puppet
include strongswan
```

### Default configuration

*conn %default* configurations can be set as follows, please note that while
this is a working example, the toppings should be adjusted for one's
preference:

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
    "compress"    => "no",
  }
}
```

### Peer configuration

Parameters for an IPsec peer:

```puppet
strongswan::conn { 'peer':
  options => {
    "left"         => "10.0.1.1",
    "leftcert"     => 'peerCert.der',
    "leftfirewall" => 'no',
    "leftid"       => '"C=UK, CN=Peer 1"',
    "leftsubnet"   => "10.0.1.0/24",
    "right"        => '10.0.2.1',
    "rightauth"    => 'pubkey',
    "rightid"      => '"C=UK, CN=Peer 2"',
    "rightsubnet"  => '10.0.2.0/24',
    "auto"         => "start",
  }
}

strongswan::secrets { 'peer':
  options => {
    'ECDSA' => 'peerKey.der'
  }
}
```

### Gateway configuration

Parameters for an IPsec gateway server:
```puppet
strongswan::conn { 'gateway':
  options => {
    "left"          => '%any',
    "leftcert"      => 'gwCert.der',
    "leftfirewall"  => "yes",
    "leftid"        => '"C=UK, CN=GW"',
    "leftsubnet"    => '10.0.0.0/24',
    "right"         => '%any',
    "rightauth"     => "pubkey",
    "rightsourceip" => '10.0.1.0/24',
    "auto"          => 'add',
  }
}

strongswan::secrets { 'peer':
  options => {
    'ECDSA' => 'gwKey.der'
  }
}
```

Gateway charon configuration:

```puppet
class { 'strongswan::charon':
  dns1                  => "10.0.0.5",
  initiator_only        => "no",
  integrity_test        => "yes",
  group                 => 'nogroup',
  user                  => 'strongswan',
}
```

**Note**: This module is solely intended to handle the strongSwan components of
the system. Other parts of the infrastructure, such as *iptables* and *sysctl*,
are to be managed by their respective modules. The following will enable packet
forwarding on the gateway node, for instance:

```puppet
sysctl { 'net.ipv4.ip_forward': value => '1' }
```

### Roadwarrior configuration

Parameters for an IPsec roadwarrior connection:

```puppet
strongswan::conn { 'roadwarrior':
  options => {
    "keyingtries"  => "%forever",
    "left"         => '%any',
    "leftcert"     => 'rwCert.der',
    "leftid"       => '"C=UK, CN=rw"',
    "right"        => '10.0.0.1',
    "rightid"      => '"C=UK, CN=GW"',
    "rightsubnet"  => '0.0.0.0/0',
    "auto"         => 'start',
  }
}

strongswan::secrets { 'roadwarrior':
  options => {
    'ECDSA' => 'rwKey.der'
  }
}
```

charon daemon configuration can also be adjusted, for example, for a client
configuration:

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

The IPsec 'config setup' section can be configured as follows:

```puppet
class { 'strongswan::setup':
  options => {
    'strictcrlpolicy' => 'yes',
    'charondebug'     => '"ike 2, knl 3, cfg 0"'
  }
}
```

## License

See [LICENSE](LICENSE) file.
