#!/bin/bash

[ -z "$NSS_API_KEY" ] && echo "Environment variable NSS_API_KEY is not set." && exit 1;
[ -z "$NSS_GATE_HOST" ] && echo "Environment variable NSS_GATE_HOST is not set." && exit 1;
[ -z "$GATE_URL" ] && echo "Environment variable GATE_URL is not set." && exit 1;
[ -z "$GATE_TOKEN" ] && echo "Environment variable GATE_TOKEN is not set." && exit 1;
which chef-solo
if [ $? == 1 ]; then
  echo "chef-solo is not installed. You might want to run 'apt install chef.'" && exit 1;
fi
echo 'Running chef-solo...'
chef-solo -c solo.rb. -j solo.json
