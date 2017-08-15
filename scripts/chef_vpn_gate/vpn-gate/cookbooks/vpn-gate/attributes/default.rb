default['vpn']['leftid'] 	= "gate-vpn"
default['vpn']['leftsubnet']	= "192.168.0.0/16"
default['vpn']['rightsourceip']	= "192.168.0.2/16"
default['vpn']['aggressive']	= true
default['vpn']['psk']		= "defaultpassword"
default['vpn']['pam_service']	= "gate-sso"

default['nss_cache']['api_key']		= "defaultapikey"
default['nss_cache']['gate_host']	= "https://192.168.1.1/nss"

default['pam_gate']['auth_url'] = "https://127.0.0.1"
default['pam_gate']['account_url'] = "https://127.0.0.1"
default['pam_gate']['token'] = "defaulttoken"
default['pam_gate']['min_user_id'] = "500"
