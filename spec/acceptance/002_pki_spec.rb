require 'spec_helper_acceptance'

describe 'pki:' do
  describe 'default' do
    it 'runs successfully' do
      pp = 'class {"strongswan":}
            class {"strongswan::pki::ca":}

            strongswan::pki::certificate {"StrongswanVPN":
              san => ["@strongswan-1","strongswan-1"],
            }

            strongswan::pki::certificate {"user1":
              common_name  => "user1@strongswan-1.local",
              p12_password => "StrongPass",
            }'

      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stderr).not_to eq(%r{error}i)
      end
    end
  end
  describe service('strongswan') do
    it { is_expected.to be_running }
  end
  describe file('/etc/strongswan/ipsec.d/private/StrongswanVPN.der') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
  end
  describe file('/etc/strongswan/ipsec.d/certs/StrongswanVPN.crt') do
    it { is_expected.to be_file }
  end
  describe file('/etc/strongswan/ipsec.d/certs/StrongswanVPN.pem') do
    it { is_expected.to be_file }
  end
  describe file('/etc/strongswan/ipsec.d/private/user1.der') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
  end
  describe file('/etc/strongswan/ipsec.d/certs/user1.crt') do
    it { is_expected.to be_file }
  end
  describe file('/etc/strongswan/ipsec.d/certs/user1.pem') do
    it { is_expected.to be_file }
  end
  describe file('/etc/strongswan/ipsec.d/certs/user1.p12') do
    it { is_expected.to be_file }
  end
end
