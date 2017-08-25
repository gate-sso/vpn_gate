#!/bin/bash

[ -z "$NSS_API_KEY" ] && echo "Environment variable NSS_API_KEY is not set." && exit 1;
[ -z "$NSS_GATE_HOST" ] && echo "Environment variable NSS_GATE_HOST is not set." && exit 1;
[ -z "$GATE_URL" ] && echo "Environment variable GATE_URL is not set." && exit 1;
[ -z "$GATE_TOKEN" ] && echo "Environment variable GATE_TOKEN is not set." && exit 1;
[ -z "$LEFT_SUBNET" ] && echo "Environment variable LEFT_SUBNET is not set." && exit 1;
[ -z "$RIGHT_SOURCE_IP" ] && echo "Environment variable RIGHT_SOURCE_IP is not set." && exit 1;
[ -z "$PSK" ] && echo "Environment variable PSK is not set." && exit 1;
which chef-solo > /dev/null
if [ $? == 1 ]; then
  echo "chef-solo is not installed. You might want to run 'apt install chef.'" && exit 1;
fi
if [ -e /etc/ipsec.conf ]; then
  echo "You already have ipsec configuration in the machine."
  read -p "Do you want to install and overwrite the configuration (y/n) " CONT
  if [ "$CONT" = "y" ]; then
    echo 'Running chef-solo'
    chef-solo -c solo.rb -j solo.json
  fi
else
  echo 'Running chef-solo...'
  chef-solo -c solo.rb -j solo.json
fi

