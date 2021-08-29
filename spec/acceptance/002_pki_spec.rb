require 'spec_helper_acceptance'
require 'shared_examples'

describe 'pki:' do
  case fact('os.family')
  when 'Debian'
    ipsec_d_dir = '/etc/ipsec.d'
  when 'RedHat'
    ipsec_d_dir = '/etc/strongswan/ipsec.d'
  end
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
  include_examples 'service is running'
  describe file("#{ipsec_d_dir}/private/StrongswanVPN.der") do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
  end
  describe file("#{ipsec_d_dir}/certs/StrongswanVPN.crt") do
    it { is_expected.to be_file }
  end
  describe file("#{ipsec_d_dir}/certs/StrongswanVPN.pem") do
    it { is_expected.to be_file }
  end
  describe file("#{ipsec_d_dir}/private/user1.der") do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 600 }
  end
  describe file("#{ipsec_d_dir}/certs/user1.crt") do
    it { is_expected.to be_file }
  end
  describe file("#{ipsec_d_dir}/certs/user1.pem") do
    it { is_expected.to be_file }
  end
  describe file("#{ipsec_d_dir}/certs/user1.p12") do
    it { is_expected.to be_file }
  end
end
