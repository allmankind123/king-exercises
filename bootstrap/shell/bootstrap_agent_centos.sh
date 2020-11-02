echo "*******************************************************************"
echo " BOOTSTRAP FILE ${0} ********************************"
echo "*******************************************************************"

FOLDER_VAGRANT_SHARED='/vagrant'

####TODO -firewall rules update  until I create an iptables.pp configuration
# commands to create sudo iptables -D INPUT 7 sudo iptables -D FORWARD 9 sudo iptables-save > /$FOLDER_VAGRANT_SHARED/iptables
sudo iptables-restore < ${FOLDER_VAGRANT_SHARED}/bootstrap/iptables/firewall_fix

####TODO -- use puppet package resource
#install git
sudo yum -y install git

####TODO -- create puppet class to install gradle
####   create erb template configure hiera for updating jenkins config .
####   save the idempotent files in <jenkins_home>/init.d/
####   refrain from using raw xml files as these become out-of-date

echo "wget gradle 5 ---start..."
wget -nv  https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /tmp
echo "wget gradle 5 ---end..."
sudo mkdir -p /opt/gradle
sudo yum -y  install unzip
sudo unzip -n  -d /opt/gradle /tmp/gradle-5.0-bin.zip


#
# package install failure
#sudo yum update
#sudo yum -y  install zlib
#yum install libstdc++.x86_64 -y
#rpm -e --nodeps libstdc++.x86_64
#rm -f /var/tmp/libstdc*
#yum install libstdc++.i686 -y
#rpm -e --nodeps libstdc++.i686
#yum install --downloadonly --downloaddir=/var/tmp/ libstdc++.i686
#yum install libstdc++.x86_64 -y
#rpm -ivh --force --nodeps /var/tmp/libstdc++*
#rm -f /var/tmp/libstdc*
#
#
sudo /etc/init.d/jenkins-slave start || /etc/init.d/jenkins-slave restart
echo "completed"

