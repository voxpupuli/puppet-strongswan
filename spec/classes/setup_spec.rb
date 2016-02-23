require 'spec_helper'

describe 'strongswan::setup', :type => 'class' do
  context "on a Debian OS" do
    let :facts do
      {
        :id             => 'root',
        :is_pe          => false,
        :osfamily       => 'Debian',
        :concat_basedir => '/dne',
        :path           => '/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end

    it {
      should contain_concat__fragment('ipsec_conf_setup') \
        .with_content(/^config setup$/)
    }

    context "with setup options set" do
      let :params do
        {
          :options => {
            'strictcrlpolicy' => 'yes',
            'charondebug'     => '"ike 2, knl 3, cfg 0"'
          }
        }
      end

      it {
        should contain_concat__fragment('ipsec_conf_setup') \
          .with_content(/^    strictcrlpolicy=yes$/)
      }

      it {
        should contain_concat__fragment('ipsec_conf_setup') \
          .with_content(/^    charondebug="ike 2, knl 3, cfg 0"$/)
      }
    end
  end
end
