# @summary Installs and manages strongSwan
#
# @param package_name
#   The strongswan package name.
# @param package_ensure
#    The desired package state. Can be used to install `latest` or a specific version etc.
# @param service_name
#    The strongswan service name.
# @param service_ensure
#    The desired `ensure` state for the service.
# @param service_enable
#    The desired `enable` state for the service.
# @param ipsec_d_dir
#    The directory for the ipsec configuration files.  The default is operating system specific and you should not need to override this setting.
# @param ipsec_conf
#    The location of the `ipsec.conf` file. The default is operating system specific and you should not need to override this setting.
# @param ipsec_secrets
#    The location of the `ipsec.secrets` file. The default is operating system specific and you should not need to override this setting.
# @param charon_conf
#    The location of the main `charon.conf` config file. WARNING, this option is not currently used.
class strongswan (
  $package_name        = 'strongswan',
  $package_ensure      = 'installed',
  $service_name        = $strongswan::params::service_name,
  $service_ensure      = running,
  $service_enable      = true,
  $ipsec_d_dir         = $strongswan::params::ipsec_d_dir,
  $ipsec_conf          = $strongswan::params::ipsec_conf,
  $ipsec_secrets       = $strongswan::params::ipsec_secrets,
  $charon_conf         = $strongswan::params::charon_conf,
) inherits strongswan::params {
  contain strongswan::package
  contain strongswan::config
  contain strongswan::service

  Class['strongswan::package']
  -> Class['strongswan::config']
  ~> Class['strongswan::service']

  Strongswan::Charon <| |>           ~> Class['strongswan::service']
  Strongswan::Charon::Plugin <| |>   ~> Class['strongswan::service']
  Strongswan::Pki::Certificate <| |> ~> Class['strongswan::service']
}
