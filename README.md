# README

##VPN GATE is an IPSec server WebUI, Management console with MFA

VPN Gate allows you set up your own IPSec server with MFA. 

* Ruby 2.3.4

* You need to set up IPSec server using *setup_ipsec.sh* directory's Chef Solo scripts.

* VPN Gate requires gate_nss_cache and other software to operate appropriately.

* You will need to run scripts inside app to databases.

* To configure the database, please run rake db:migrate after setting appropriate variables defined in *config/db/database.yml*

* To Run tests, please run 'rake spec'

##Deployment instructions

VPN Gate has two components: IPSec VPN Server and IPSec Web Interface
=======

Setting Up Gate VPN Server
=================
A StrongSwan based IKEv1 (Cisco) VPN Server accessible via native VPN client.

This also uses NSS to sync users and MFA (using PAM) to authenticate.

Server Setup
------------
Change the attribute/default.rb to suit the needs of the VPN, and then run the chef-solo configuration.

<tt>./setup_ipsec.sh</tt>

Set up PAM URL, token, NSS URL, and NSS API KEY with GATE_URL, GATE_TOKEN, NSS_GATE_URL, NSS_API_KEY environment variables.

Default installation consists of PAM, StrongSwan, NSS, and lib-nss installation, it can be changed by editing solo.json file.

Before starting the chef-solo, make sure there is no installation of StrongSwan (along with it module, try apt autoremove) in the machine. Also, compilation of the pam module needs additional -lpam flag to be recognized by StrongSwan charon.

Change the left subnet inside default attributes to split tunnel (left subnet is the tunnelled adress).

Aggressive mode for the VPN is enabled by default.

Client Setup
------------
Mac:
Open System Preferences -> Network. Click the '+' at the lower left side.
Set Interface to 'VPN' and VPN Type to 'Cisco IPSec'. Add your desired VPN name.
Click 'Create'. Set server address and username. Click on Authentication Setting and fill the Pre-Shared Key.
Connect and fill the password.

Android:
Open Settings. Search for VPN. Click on the '+' at the upper right side.
Add desired VPN name. Set Type to IPSec Xauth PSK. Set server address and Pre-Shared Key. Click save. Click the newly created VPN profile to connect.

