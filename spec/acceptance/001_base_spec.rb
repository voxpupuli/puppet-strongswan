require 'spec_helper_acceptance'

describe 'strongswan default:' do
  describe 'run puppet' do
    it 'should run successfully' do
      pp = "class { 'strongswan': }"

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
      it { should be_installed }
    end
    describe file('/etc/strongswan/ipsec.conf') do
      it { should be_file }
    end
    describe file('/etc/strongswan/ipsec.secrets') do
      it { should be_file }
    end
    describe service('strongswan') do
      it { should be_running }
    end
  end
end
