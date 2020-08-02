# @summary strongSwan secrets configuration.
#
# @param selectors
#   List of selectors for current secret
# @param options
#   A hash of options to use with the secret
#
# @example Example 1
#    strongswan::secrets { '%any':
#      options => {
#        'RSA' => 'vpnHostKey.der keypass'
#      }
#    }
#
# @example Example 2
#    strongswan::secrets { 'John':
#      options => {
#        'EAP' => 'SuperSecretPass'
#      }
#    }
#
# @see https://linux.die.net/man/5/ipsec.secrets
define strongswan::secrets (
  Array[String[1]] $selectors = [$title],
  Hash $options               = {},
) {
  include strongswan

  concat::fragment { "ipsec_secrets_secret-${title}":
    content => template('strongswan/ipsec_secrets_secret.erb'),
    target  => $strongswan::ipsec_secrets,
    order   => '02',
  }
}
