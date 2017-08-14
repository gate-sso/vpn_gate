#
# Cookbook Name:: vpn-gate 
# Recipe:: pam_gate 
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git"
package "libcurl4-openssl-dev"
package "gcc"
package "make"
package "libpam0g-dev"

execute "create_pam_directory" do
    command "mkdir /usr/local/lib/gate_pam"
end

cookbook_file "/usr/local/lib/gate_pam/pam_gate.c" do
    source "pam_gate.c"
    owner "root"
    group "root"
    mode "0755"
end

execute "compile_pam_gate" do
    command "cd /usr/local/lib/gate_pam/ && gcc -fPIC -c pam_gate.c"
end

execute "link_pam_gate" do
    command "cd /usr/local/lib/gate_pam/ && ld -x --shared -o pam_gate.so pam_gate.o -lcurl -lpam"
end

execute "move_pam_gate" do
    command "chmod 644 /usr/local/lib/gate_pam/pam_gate.so && mv /usr/local/lib/gate_pam/pam_gate.so /lib/*/security"
end

template "/etc/pam.d/gate-sso" do
    source "default/pam-gate-core/gate-sso.erb"
end
