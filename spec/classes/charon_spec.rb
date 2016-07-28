require 'spec_helper'

describe 'strongswan::charon', :type => 'class' do
  context "on a Redhat OS" do
    let :facts do
      {
        :osfamily       => 'Redhat',
      }
    end

    it {
      should contain_file('charon.conf').with(
        "ensure"  => "file",
        "path"    => "/etc/strongswan/strongswan.d/charon.conf",
        "mode"    => '0644',
        "owner"   => 'root',
        "group"   => 'root',
        "require" => "Package[strongswan]",
        "notify"  => "Class[Strongswan::Service]",
      )
    }

    context "with setup options set" do
      let :params do
        {
          :dns1 => '8.8.8.8',
        }
      end

      it {
        should contain_file('charon.conf') \
          .with_content(/^    dns1 = 8.8.8.8$/)
      }

      it {
        should contain_file('charon.conf') \
          .without_content(/^    dns2 = 8.8.8.8$/)
      }
    end
    context "with charon user and group set" do
      let :params do
        {
          :user => 'strongswan',
          :group => 'nogroup',
        }
      end

      it {
        should contain_file('charon.conf') \
          .with_content(/^    group = nogroup$/)
      }

      it {
        should contain_file('charon.conf') \
          .with_content(/^    user = strongswan$/)
      }
    end

    context "with charon interfaces_use set" do
      let :params do
        {
          :interfaces_use => 'eth0',
        }
      end

      it {
        should contain_file('charon.conf') \
          .with_content(/^    interfaces_use = eth0$/)
      }
    end

    context "with charon ikesa_table_size set" do
      let :params do
        {
          :ikesa_table_size => '1024',
        }
      end

      it {
        should contain_file('charon.conf') \
          .with_content(/^    ikesa_table_size = 1024$/)
      }
    end
  end
end
