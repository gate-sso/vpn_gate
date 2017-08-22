#
# Cookbook Name:: vpn-gate 
# Recipe:: strongswan-vpn 
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{strongswan strongswan-plugin-unity strongswan-plugin-dhcp strongswan-plugin-xauth-pam}.each do |pkg|
    package pkg
end

%w{ipsec.conf ipsec.secrets}.each do |fname|
    template "/etc/#{fname}" do
        source "default/ipsec-core/#{fname}.erb"
    end
end

template "/etc/strongswan.d/charon.conf" do
    source "default/ipsec-core/charon.conf.erb"
end

template "/etc/strongswan.d/charon/xauth-pam.conf" do
    source "default/ipsec-core/xauth-pam.conf.erb"
end

=begin
package "iptables-persistent"
package "gcc"
package "make"
package "libgmp3-dev"
package "libpam0g-dev"

execute 'get_strongSwan-5.5.3' do
    command "wget http://download.strongswan.org/strongswan-5.5.3.tar.bz2 -P /usr/local/lib"
end

execute 'extract_strongSwan-5.5.3' do
    command "tar xjvf /usr/local/lib/strongswan-5.5.3.tar.bz2 -C /usr/local/lib/"
end

execute 'remove_strongSwan-5.5.3' do
    command "rm /usr/local/lib/strongswan-5.5.3.tar.bz2"
end

execute 'configure_strongSwan' do
    command "cd /usr/local/lib/strongswan-5.5.3/ && ./configure -prefix=/usr --sysconfdir=/etc --enable-unity --enable-xauth-pam --enable-dhcp"
end

execute 'make_strongSwan' do
    command "cd /usr/local/lib/strongswan-5.5.3/ && make install"
end

%w{ipsec.conf ipsec.secrets}.each do |fname|
    template "/etc/#{fname}" do
        source "default/ipsec-core/#{fname}.erb"
    end
end

template "/etc/strongswan.d/charon.conf" do
    source "default/ipsec-core/charon.conf.erb"
end

template "/etc/strongswan.d/charon/xauth-pam.conf" do
    source "default/ipsec-core/xauth-pam.conf.erb"
end
=end

