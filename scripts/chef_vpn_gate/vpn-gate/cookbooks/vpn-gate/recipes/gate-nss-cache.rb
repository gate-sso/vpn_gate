#
# Cookbook Name:: vpn-gate 
# Recipe:: gate-nss-cache
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'create_nss_configuration' do
    command "mkdir -p /etc/nss/"
end

template "/etc/nss/nss_http.yml" do
    source "default/gate-nss-cache-core/nss_http.yml.erb"
end

template "/etc/nsswitch.conf" do
    source "default/gate-nss-cache-core/nsswitch.conf.erb"
end

cookbook_file "/bin/gate-nss-cache" do
    source "gate_nss_cache"
    owner "root"
    group "root"
    mode  "0755"
end

cron 'adding cron for gate nss cache ' do
    hour '*/3'
    command %W{
        GATE_CONFIG_FILE="/etc/nss/nss_http.yml"
        /bin/gate-nss-cache
    }.join(' ')
end

