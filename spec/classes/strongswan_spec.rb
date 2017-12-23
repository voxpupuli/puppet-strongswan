require 'spec_helper'

describe 'strongswan' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('strongswan') }
        it { is_expected.to contain_class('strongswan::package') }
        it { is_expected.to contain_class('strongswan::config') }
        it { is_expected.to contain_class('strongswan::service') }
      end

      context 'strongswan::package' do
        it { is_expected.to contain_package('strongswan') }
      end

      context 'strongswan::config' do
        it { is_expected.to contain_concat('/etc/strongswan/ipsec.conf') }
        it { is_expected.to contain_concat('/etc/strongswan/ipsec.secrets') }
      end

      context 'strongswam::service' do
        it { is_expected.to contain_service('strongswan') }
      end
    end
  end
end
