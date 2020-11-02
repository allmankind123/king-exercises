
echo "*******************************************************************"
echo " BOOTSTRAP FILE ${0} ********************************"
echo "*******************************************************************"

FOLDER_VAGRANT_SHARED='/vagrant'
FOLDER_JENKINS_BOOTSTRAP='bootstrap/jenkins'
JENKINS_USER='jenkins'
JENKINS_GROUP='jenkins'

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
sudo cp ${FOLDER_VAGRANT_SHARED}/${FOLDER_JENKINS_BOOTSTRAP}/hudson.plugins.gradle.Gradle.xml /var/lib/jenkins/
chown ${JENKINS_USER}:${JENKINS_GROUP} /var/lib/jenkins/hudson.plugins.gradle.Gradle.xml


#### TODO: AS ABOVE -- HIERA ERB, IDEMPOTENT SCRIPTS IN INIT.D DIRECTORY
# agent jnlp protocol configuration
sudo cp ${FOLDER_VAGRANT_SHARED}/${FOLDER_JENKINS_BOOTSTRAP}/jnlp_config.xml /var/lib/jenkins/config.xml

# copy the exercise1 pipeline over
mkdir -p /var/lib/jenkins/jobs/exercise1_pipeline
sudo cp ${FOLDER_VAGRANT_SHARED}/${FOLDER_JENKINS_BOOTSTRAP}/config.xml_exercise1 /var/lib/jenkins/jobs/exercise1_pipeline/config.xml

mkdir -p /var/lib/jenkins/jobs/exercise1_job
cp ${FOLDER_VAGRANT_SHARED}/${FOLDER_JENKINS_BOOTSTRAP}/config.xml.exercise_job /var/lib/jenkins/jobs/exercise1_job/config.xml

mkdir -p /var/lib/jenkins/jobs/exercise3_android_sdk_centos
cp ${FOLDER_VAGRANT_SHARED}/${FOLDER_JENKINS_BOOTSTRAP}/config.xml_android_sdk_centos /var/lib/jenkins/jobs/exercise3_android_sdk_centos/config.xml

sudo chown -R ${JENKINS_USER}:${JENKINS_GROUP} /var/lib/jenkins/jobs/

# reload jenkins configuration from disk
#/usr/lib/jenkins/jenkins-cli.jar -noCertificateCheck -s http://localhost:<port> reload-configuration
sudo /etc/init.d/jenkins restart
