default['vpn']['leftsubnet'] = ENV['LEFT_SUBNET']
default['vpn']['rightsourceip'] = ENV['RIGHT_SOURCE_IP']
default['vpn']['aggressive'] = true
default['vpn']['psk'] = ENV['PSK']
default['vpn']['pam_service']	= "gate-sso"

default['nss_cache']['api_key'] = ENV['NSS_API_KEY']
default['nss_cache']['gate_host'] = ENV['NSS_GATE_HOST']

default['pam_gate']['url'] = ENV['GATE_URL']
default['pam_gate']['token'] = ENV['GATE_TOKEN']
default['pam_gate']['min_user_id'] = "5000"
