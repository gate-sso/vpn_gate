#
# Cookbook Name:: vpn-gate 
# Recipe:: libnss-cache
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git"
package "gcc"
package "make"

execute 'clone_libnss-cache' do
    command "cd /usr/local/lib && git clone https://github.com/gate-sso/libnss-cache.git"
end

execute 'make_libnss-cache' do
    command "cd /usr/local/lib/libnss-cache && make install"
end
