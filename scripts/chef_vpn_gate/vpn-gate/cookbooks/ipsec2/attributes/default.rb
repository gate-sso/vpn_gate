default['vpn']['gate_host']                 = ENV['GATE_HOST']
default['vpn']['ipsec']['fqdn']             = ENV['IPSEC_FQDN']
default['vpn']['ipsec']['leftsubnet']       = ENV['LEFT_SUBNET']
default['vpn']['ipsec']['rightsourceip']    = ENV['RIGHT_SOURCE_IP']
default['vpn']['ipsec']['radius_fqdn']      = ENV['RADIUS_FQDN']
default['vpn']['ipsec']['radius_secret']    = ENV['RADIUS_SECRET']

default['vpn']['radius']['fqdn']            = ENV['RADIUS_FQDN']
default['vpn']['radius']['radius_secret']   = ENV['RADIUS_SECRET']
default['vpn']['radius']['db_user']         = ENV['DB_USER'] || "db_user"
default['vpn']['radius']['db_passwd']       = ENV['DB_PASSWD'] || "db_password"
default['vpn']['radius']['db_name']         = ENV['DB_NAME'] || "db_name"


