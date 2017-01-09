source 'https://rubygems.org'

source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :unit_tests do
  gem 'rake',                                              :require => false
  gem 'rspec',                                             :require => false
  gem 'rspec-puppet',                                      :require => false
  gem 'puppetlabs_spec_helper',                            :require => false
  gem 'metadata-json-lint',                                :require => false
  gem 'puppet-lint', '>= 2.0.0',                           :require => false
  gem 'rspec-puppet-facts',                                :require => false
  gem 'jimdo-rspec-puppet-helpers',                        :require => false
  gem 'json_pure', '< 2.0.2',                              :require => false
  gem 'rubocop',                                           :require => false if RUBY_VERSION !~ /^1\./
end

group :system_tests do
  gem 'beaker',                       :require => false
  gem 'beaker-rspec',                 :require => false
  gem 'beaker_spec_helper',           :require => false
  gem 'beaker-puppet_install_helper', :require => false
  gem 'serverspec',                   :require => false
  gem 'specinfra',                    :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
