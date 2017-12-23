require 'spec_helper_acceptance'

describe 'strongswan default:' do
  describe 'run puppet' do
    it 'runs successfully' do
      pp = "class { 'strongswan': }
            class { 'strongswan::setup': }
            class { 'strongswan::pki::ca':}"

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to eq(/error/i)
      end

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to eq(/error/i)
        expect(r.exit_code).to be_zero
      end
    end
  end
  describe 'componets:' do
    describe package('strongswan') do
      it { is_expected.to be_installed }
    end
    describe file('/etc/strongswan/ipsec.conf') do
      it { is_expected.to be_file }
    end
    describe file('/etc/strongswan/ipsec.secrets') do
      it { is_expected.to be_file }
    end
    describe service('strongswan') do
      it { is_expected.to be_running }
    end
  end
end
