#
# Cookbook Name:: vpn-gate 
# Recipe:: pam_gate 
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "libcurl4-openssl-dev"
package "libpam0g-dev"

security_folder = `cd /lib/*/security && pwd`.strip()

cookbook_file "#{security_folder}/pam_gate.so" do
    source "pam_gate.so"
    owner "root"
    group "root"
    mode "0644"
end

template "/etc/pam.d/gate-sso" do
    source "default/pam-gate-core/gate-sso.erb"
end

