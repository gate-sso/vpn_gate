#!/bin/bash

check_env() {

	service=$1

	if [ "${service}" == "ipsec" ]; then
		
		[ -z "$IPSEC_FQDN" ] && echo "Environment variable IPSEC_FQDN is not set." && exit 1;
		[ -z "$LEFT_SUBNET" ] && echo "Environment variable LEFT_SUBNET is not set." && exit 1;
		[ -z "$RIGHT_SOURCE_IP" ] && echo "Environment variable RIGHT_SOURCE_IP is not set." && exit 1;
		[ -z "$RADIUS_FQDN" ] && echo "Environment variable RADIUS_FQDN is not set." && exit 1;
		[ -z "$RADIUS_SECRET" ] && echo "Environment variable RADIUS_SECRET is not set." && exit 1;
		
	elif [ "${service}" == "ipsec_radius" ]; then
		
		[ -z "$IPSEC_FQDN" ] && echo "Environment variable IPSEC_FQDN is not set." && exit 1;
		
	elif [ "${service}" == "radius" ]; then
		
		[ -z "$RADIUS_SECRET" ] && echo "Environment variable RADIUS_SECRET is not set." && exit 1;
		[ -z "$GATE_HOST" ] && echo "Environment variable GATE_HOST is not set." && exit 1;
		# [ -z "$RADIUS_FQDN" ] && echo "Environment variable RADIUS_FQDN is not set." && exit 1;
                # [ -z "$DB_USER" ] && echo "Environment variable DB_USER is not set." && exit 1;
 		# [ -z "$DB_PASSWDN" ] && echo "Environment variable DB_PASSWD is not set." && exit 1;
 		# [ -z "$DB_NAME" ] && echo "Environment variable DB_NAME is not set." && exit 1;
		
	fi   

} 


check-and-run-chef-solo() {
	service=$1
	
	if [ "${service}" == "ipsec" ]; then
		_conf_file_name="/etc/ipsec.conf"
		_recipe="ipsec2::ipsec"
		check_env 'ipsec'
	elif [ "${service}" == "ipsec_radius" ]; then
		_conf_file_name="/etc/ipsec.conf"
		_recipe="ipsec2::ipsec_radius"
		check_env 'ipsec_radius'
	elif [ "${service}" == "radius" ]; then
		_conf_file_name="/etc/freeradius/clients.conf"
		_recipe="ipsec2::radius"
		check_env 'radius'
	fi
	
	if [ -e $_conf_file_name ]; then
	  echo "You already have ${service} configuration in the machine."
	  read -p "Do you want to install and overwrite the configuration (y/n) " CONT
	  if [ "$CONT" = "y" ]; then
	    echo 'Running chef-solo'
	    chef-solo -c solo.rb -o $_recipe
	  fi
	else
	  echo 'Running chef-solo...'
	  chef-solo -c solo.rb -o $_recipe
	fi
	
}

if [ "$#" -ne 1 ]; then
	echo "Usage: ${0} [IPSEC|RADIUS|IPSEC_RADIUS]" && exit 1;
fi

which chef-solo > /dev/null
if [ $? == 1 ]; then
  echo "chef-solo is not installed. You might want to run 'apt install chef.'" && exit 1;
fi

TYPE=$( echo $1 | tr '[:upper:]' '[:lower:]')

if [ "${TYPE}" == "ipsec" ]; then
	check-and-run-chef-solo "ipsec"
elif [ "${TYPE}" == "radius" ]; then
	check-and-run-chef-solo "radius"
elif [ "${TYPE}" == "ipsec_radius" ];then
	check-and-run-chef-solo "ipsec_radius"
else
	echo "$TYPE is not supported. Please use one of these [IPSEC|RADIUS|RADIUS_IPSEC]" && exit 1;
fi

