#
# Cookbook Name:: vpn-gate 
# Recipe:: strongswan-vpn 
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/usr/local/lib/strongswan-gojek_5.5.3-1_amd64.deb" do
    source "strongswan-gojek_5.5.3-1_amd64.deb"
    owner "root"
    group "root"
    mode "0444"
end

dpkg_package "strongswan-gojek" do
    source "/usr/local/lib/strongswan-gojek_5.5.3-1_amd64.deb"
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

execute "enable ipv4 forward" do
    command "echo 1 > /proc/sys/net/ipv4/ip_forward"
end

