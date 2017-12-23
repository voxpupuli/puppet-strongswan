source 'https://rubygems.org'

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'metadata-json-lint',                                         require: false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  require: false
  gem 'puppet-lint-leading_zero-check',                             require: false
  gem 'puppet-lint-trailing_comma-check',                           require: false
  gem 'puppet-lint-unquoted_string-check',                          require: false
  gem 'puppet-lint-variable_contains_upcase',                       require: false
  gem 'puppet-lint-version_comparison-check',                       require: false
  gem 'puppetlabs_spec_helper', '~> 2.5.0',                         require: false
  gem 'rack', '~> 1.0',                                             require: false if RUBY_VERSION < '2.2.2'
  gem 'rspec-puppet', '~> 2.5',                                     require: false
  gem 'rspec-puppet-facts',                                         require: false
  gem 'rspec-puppet-utils',                                         require: false
  gem 'rubocop', '~> 0.49.1',                                       require: false if RUBY_VERSION >= '2.3.0'
  gem 'rubocop-rspec', '~> 1.15.0',                                 require: false if RUBY_VERSION >= '2.3.0'
end

group :system_tests do
  gem 'beaker',                       require: false
  gem 'beaker-puppet_install_helper', require: false
  gem 'beaker-rspec',                 require: false
  gem 'beaker_spec_helper',           require: false
  gem 'serverspec',                   require: false
  gem 'specinfra',                    require: false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion.to_s, require: false, groups: [:test]
else
  gem 'facter', require: false, groups: [:test]
end

puppetversion = ENV['PUPPET_VERSION'].nil? ? '~> 5.0' : ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, require: false, groups: [:test]
