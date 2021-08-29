RSpec.shared_examples 'service is running' do
  strongswan_service = case fact('os.name')
                       when 'Debian'
                         case fact('os.release.major')
                         when '8', '9', '10' then 'strongswan'
                         else
                           'strongswan-starter'
                         end
                       when 'Ubuntu'
                         case fact('os.release.major')
                         when '16.04', '18.04' then 'strongswan'
                         else
                           'strongswan-starter'
                         end
                       else
                         'strongswan'
                       end

  describe service(strongswan_service) do
    it { is_expected.to be_running }
  end
end
