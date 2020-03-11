require 'spec_helper_acceptance'

describe 'strongswan default' do
  context 'default parameters' do
    it 'runs successfully' do
      pp = "class { 'strongswan': }
            class { 'strongswan::setup': }
            class { 'strongswan::pki::ca':}"

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes:  true)
    end
  end
  describe 'components' do
    case fact('os.family')
    when 'Debian'
      ipsec_conf = '/etc/ipsec.conf'
      ipsec_secrets = '/etc/ipsec.secrets'
    when 'RedHat'
      ipsec_conf = '/etc/strongswan/ipsec.conf'
      ipsec_secrets = '/etc/strongswan/ipsec.secrets'
    end
    describe package('strongswan') do
      it { is_expected.to be_installed }
    end
    describe file(ipsec_conf) do
      it { is_expected.to be_file }
      it { is_expected.to contain 'setup' }
    end
    describe file(ipsec_secrets) do
      it { is_expected.to be_file }
    end
    describe service('strongswan') do
      it { is_expected.to be_running }
    end
  end
end
