VPN-gate Cookbook
=================
This cookbook allows creation of VPN with strongSwan linked with PAM authentication.
The cookbook also installed nss to enable caching between machine.

StrongSwan Package
------------------
In order to create package you'll need to download the strongSwan source.
<tt>https://download.strongswan.org/</tt>

For the ease of creating the package use checkinstall. Links to the wiki below.
<tt>https://wiki.debian.org/CheckInstall</tt>

Create the package by running below instructions
<tt>./configure <options> && make && checkinstall</tt>

Binary gate-nss-cache
---------------------
The source for gate-nss-cache binary can be found in https://github.com/gate-sso/gate-nss-cache.

Binary pam_gate.so
------------------
The source for pam_gate.so can be found in https://github.com/gate-sso/pam_gate.
In order to be recognized by strongSwan you'll need to add -lpam in the compilation of the source.

