#
# Cookbook Name:: vpn_gate 
# Recipe:: radius 
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "freeradius"

template "/etc/freeradius/clients.conf" do
  backup 5  
  source "default/radius/clients.conf.erb"
end

template "/usr/local/bin/gate_auth.sh" do
  source "default/radius/gate_auth.sh.erb"
  mode '0755'
end

template "/etc/freeradius/modules/mschap" do
  backup 5
  source "default/radius/mschap.erb"
end

service "freeradius" do
  action [:enable, :restart]
end