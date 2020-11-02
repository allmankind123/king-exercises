System Requirements to Build This Jenkins Ecosystem:

Essential Software To Be Installed
VirtualBox 6.1 ( > 5) 
Vagrant 2.2.10 ( > 2 )
Git            (any version)

I had Ruby and Puppet pre-installed on a macbook air  so cannot rule out other pre-installed requirements apart from the above.


Structure of the exercise Answers:







1. checkout the following repo (master branch)
git clone 

	
Error: Could not start Service[jenkins-slave]: Execution of '/bin/systemctl start jenkins-slave' returned 1: Job for jenkins-slave.service failed because the control process exited with error code. See "systemctl status jenkins-slave.service" and "journalctl -xe" for details.


