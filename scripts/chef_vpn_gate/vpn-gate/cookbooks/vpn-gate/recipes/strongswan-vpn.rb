#
# Cookbook Name:: vpn-gate 
# Recipe:: strongswan-vpn 
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
=begin
%w{strongswan}.each do |pkg|
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
=end
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
    command "cd /usr/local/lib/strongswan-5.5.3/ && ./configure -prefix=/satu --sysconfdir=/dua --enable-unity --enable-xauth-pam --enable-dhcp"
end

execute 'make_strongSwan' do
    command "cd /usr/local/lib/strongswan-5.5.3/ && make install"
end
=end

cookbook_file "/usr/local/lib/strongswan_5.5.3-1_amd64.deb" do
    source "strongswan_5.5.3-1_amd64.deb"
    owner "root"
    group "root"
    mode "0444"
end

dpkg_package "strongswan" do
    source "/usr/local/lib/strongswan_5.5.3-1_amd64.deb"
    action :install
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
