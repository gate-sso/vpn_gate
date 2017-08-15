# README

##VPN GATE is IPSec server WebUI, Management console with MFA

VPN Gate allows you setup your own IPSec server with MFA. 

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby 2.3.4 or JRuby 9.1.x

* You need to setup IPSec server using *scripts* directory's Chef Solo scripts.

* VPN Gate requires gate_nss_cache and other software to operate appropriately.

* To configure database, please run rake db:migrate after setting appropriate variables defined in *config/db/database.yml*

* To Run tests please run rake spec

##Deployment instructions

VPN Gate has two components, IPSec VPN Server, second it has IPSec Web Interface
