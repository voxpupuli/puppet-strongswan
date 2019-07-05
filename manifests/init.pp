# Default strongSwan class.
class strongswan(
  $package_name        = $strongswan::params::package,
  $version             = $strongswan::params::version,
  $service_name        = $strongswan::params::service,
  $ipsec_d_dir         = $strongswan::params::ipsec_d_dir,
  $ipsec_conf          = $strongswan::params::ipsec_conf,
  $ipsec_secrets       = $strongswan::params::ipsec_secrets,
  $charon_conf         = $strongswan::params::charon_conf,
  $charon_logging_conf = $strongswan::params::charon_logging_conf,
) inherits strongswan::params {


  include strongswan::package
  include strongswan::config
  include strongswan::service


  Class['Apt::Update']
  -> Class['strongswan::package']
  -> Class['strongswan::config']
  ~> Class['strongswan::service']

}
