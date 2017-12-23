require 'beaker-rspec'
require 'beaker/puppet_install_helper'

hosts.each do |host|
  install_puppet
  install_package host, 'net-tools'
  install_package host, 'make'
  install_package host, 'gcc'
  install_package host, 'ruby-devel'
  install_package host, 'epel-release'
  install_package host, 'openssl'
  on host, 'yum makecache'
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    puppet_module_install(source: proj_root, module_name: 'strongswan')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-concat'), acceptable_exit_codes: [0, 1]
    end
  end
end
