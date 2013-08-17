#
# Cookbook Name:: gauth
# Recipe:: default
# aug 4, 2013
# Author: Gaurav Rajput
# Copyright 2013, gauravrajput@aasaanpay.com
#
# All rights reserved - Do Not Redistribute
########################################################################################

package 'wget'
package 'gcc'
package 'make'
package 'gcc-c++'
package 'git'

bash 'configuring_the_epel_and_rpmforge_repo' do
	user 'root'
	cwd '/root'
	code <<-EOH
	rpm -ivh http://epel.mirror.net.in/epel/6/i386/epel-release-6-8.noarch.rpm
	EOH
	ignore_failure true
end

package 'pam-devel'
package 'totpcgi'
package 'openssl'
package 'pam_url'

bash 'installing_the_google_authenticator' do
	user 'root'
	cwd '/root'
	code <<-EOH
	wget http://google-authenticator.googlecode.com/files/libpam-google-authenticator-1.0-source.tar.bz2
	tar -xvf libpam-google-authenticator-1.0-source.tar.bz2	
	cd libpam-google-authenticator-1.0
	make && make install && cd
	sed -i '1s/^/auth  required  pam_google_authenticator.so\n /' /etc/pam.d/sshd
	sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
	service sshd restart
	google-authenticator -t -d -f --rate-limit=3 --rate-time=30 -W
	EOH
end






