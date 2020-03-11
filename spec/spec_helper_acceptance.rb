require 'beaker-rspec'
require 'beaker-puppet'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      install_package(host, 'epel-release') if fact('os.family') == 'RedHat'
    end
  end
end
