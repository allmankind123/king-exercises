System Requirements to Build This Jenkins Ecosystem
=====================================================

Essential Software To Be Installed
----------------------------------
VirtualBox 6.1 ( > 5) 
Vagrant 2.2.10 ( > 2 )
Git            (any version)

I had Ruby and Puppet pre-installed on a macbook air  so cannot rule out other pre-installed requirements apart from the above.


1. Use Git to clone the following repo (master branch)
git clone  https://github.com/allmankind123/king-exercises

2. Become famailiar with the code structure

Vagrantfile  (build jenkins masters and slaves)
nodes.json   (list of hosts for vagrant to build out)
.
├── bootstrap ( Quick Fixes and configuration files to build out the Hosts)
│   ├── iptables (firewall quick-fix)
│   ├── jenkins (jenkins config files)
│   └── shell (shell scripts to be run by vagrant process)
├── data (Hiera data pertaining to nodes, and common functionality)
│   └── nodes ( 1:1 mapping with nodes.json)
└── puppet (puppetlabs libraries and Bespoke Wrappers)
    ├── manifests (entrypoint for puppet apply command)
    ├── modules (3rd party puppet modules used by classes in Roles directory)
    └── roles (bespoke roles to be referenced specifically for the exercises)

3.Run the all vagrant commands in the directory containing Vagrantfile.

4. in Same directory as Vagrantfile, run the following command
   vagrant status

result =>
jenkins-master1           not created (virtualbox)
jenkins-master2           not created (virtualbox)
jenkins-slave-centos      not created (virtualbox)

each of these hosts are referenced in nodes.json and puppet/nodes/<nodename>.yaml
you can build each nodes individually ( 'vagrant up jenkins-master1'
or you can build all together ( 'vagrant up' )

If all goes well, you will have 3 hosts built which you can reference as below:
jenkins-master1 : http://localhost:8080 or http://192.168.32.5:8080 
jenkins-master2 : http://localhost:8090 or http://192.168.32.15:8080
jenkins-slave-centos : attached to jenkins-master2 : 


Exercise Completion Order :  4, 1, 3

Exercise4: Devops and Jenkins
================================

Maintain Plugins independently
lets simplify the probem and  assume:
- we have two teams requiring their own jenkins instance.
- both teams are happy to use the same version of jenkins software
- each has different plugin requirements
- each want to specify THEIR own plugin requirements without interfering with the others
- both teams have access to update their plugins (can be controversial!!!)
- both teams have admin access (even less likely)

a.The commonality (version of jenkins) is configured here:
	data/common.yaml : here we refer to the common versions of jenkins

b.Team1 build jenkins-master1 with plugins configured according to 
	data/nodes/jenkins-master1.yaml  => nothing configured 
verify using this url: http://localhost:8080/pluginManager/installed

c. Team2 build jenkins-master2 and have actually specified the plugins they are interested in. see data/nodes/jenkins-master2.yaml
verify using this url: http://localhost:8090/pluginManager/installed

d. Team1 now install a few necessary plugins using the web gui and want them persisted after each jenkins rebuild.
To list the plugins and versions in the correct structure, do the following:
 on a browser go to http://localhost:8080/script
 and copy the contents of this file (bootstrap/jenkins/plugins.groovy) into the text box and submit.
 or use the jenkins-cli jarfile
  
the resulting 0output and the structure can be inserted into jenkins-master1.yaml

then at the directory level of the vagrantfile, type the following:
 vagrant up jenkins-master1 --provision
this will rerun the puppet and shell provider.
if this is successful, then this configuration can be committed to version control , tagged and submitted as a candidate for future rebuilds.

e. Team1 have been careless and allowed anyone to install from the plugin update site and need to revert back without rebulding jenkins.
 
	delete all the plugins:(either by the gui or sudo rm -rf /var/lib/jenkins/plugins/*)
   rerun puppet command: vagrant up jenkins-master1 --provision
    (on a productionised system, puppet agent -t )
   then perform a jenkins reload or restart.

   http://localhost:8080/cli/command/restart
   /etc/init.d/jenkins restart
   java -jar jenkins-cli.jar -s http://localhost:8080/ restart
	 
Note: puppet will update what is missing but not delete what shouldn't be there so to be sure, delete all the plugins to set the system back to 'original-settings'

f.  Team3,4 and 5 arrive and need a jenkins server of their own.
  1. add a new node into nodes.json
  2. create a new <node_name>.yaml and populate the file accordingly
  3. type : vagrant status (to verify you have not made a syntax error in nodes.json)
  4. type: vagrant up <node_name>
  5. verify that the data you inserted into nodes.json does not clash with other nodes.


g.  Team 6 arrives consisting of one person. He/she may be able to use the folder plugin and roles and co-exist with another team on the same jenkins Instance.



Exercise 1: Configuration As Code & Pipelines
============================================

Deliverables
-------------
The code can be cloned from this location 
 https://github.com/allmankind123/king-web/tree/master/web-hello-world
The pipeline job can be located here:
  http://localhost:8090/job/exercise1_pipeline/
The Jenkinsfile is located at the root of the github project.


first task was to be able to compile the project.

Notes on the build process
------------------------------
The project sourcecode was included amongst other projects. They weren't organised as part of a multi-module build system sharing versions for dependencies so I chose to extract the code into another git project , separated from the other projects and so I can update the codebase as well.

the sourcecode contains java source files  so I included the java plugin
the jetty plugin is out of date so I swapped it for the gradle upgrade, gretty
the project is a web-app structure so I included the war plugin.

the provided maven dependency means that whilst it is downloaded to compile with, it is not bundled into the end product (ie, should be part of the classpath of the jetty application server.
I have included junit and Mockito dependencies to create unit tests and mock the servlet.

I swapped mavenCentral for jcenter repository to retrieve the gretty plugin.

As I am using the default port 8080 for jenkins, I reconfigured the webapp to use 8088 instead.

The project consists of one servlet and the web.xml file
I've included one extra file :./src/test/java/org/gradle/examples/web/ServletTest.java

I've tried not to alter the source code itself as part of the build engineers role is to package and integrate code units, rarely to change intent of the code to better serve the build. I also prefer tdd as the intent of the code can only be inferred without pre-written tests.

one change was to place the web.xml in the correct directory (within WEB-INF).

I've mocked the request and response object and added one assertion.

I've:
 	- verified that the test compiles and passes (gradle test)
	- built manually, the war file ( gradle war)
	- manually tested the webapp: gradle appRun
	curl http:localhost:8088/hello and received the correct response.
	- I could have created an integration test but for the purposes of the exercise, it was not absolutely essential. 


In order to build this on Jenkins , there were pre-requisites that needed completion:
1. Gradle distribution to be installed
2. Jenkins pre-configured with this distribution 
3. A pipeline job created to run the tests and archive the results.

With extra time, I would have installed the gradle puppet module and added an extra class in the roles. However , the codebase was only tested on fedora and the priority was to build within the pipeline, not to have a decent mechanism to include new/multiple versions of gradle. Though my preferred way is to bundle the distribution in Artifactory. Have a hiera feature that included where to download and unpack , and auto configure jenkins using an idempotent groovy script in the <jenkins_home>/init.d directory , templated using an erb file and injected with the hiera values as necessary. It would also dynamically pickup any manually added distributions if developers needed to poc new versions. It is also possible to add custom tool integrations or provision docker images with pre-baked environments.


I added bash scripting to download a distribution and unpack the distribution and configured jenkins to  be aware of it. Normarily It would make sense to create somethibg similar to an rspec test to verify the building of it, but for now I created a jenkins pipeline here: http://localhost:8090/job/exercise1_pipeline/ 

I've included a Jenkinsfile within the project directory for the jenkins job to retrieve and execute. There are two stages: clean test and archive the war artifact and also to scrape the junit test.

Normarily, I'd include code coverage, findbugs/spotbugs as part of the CI and build process.
Also I'd configure the build to fail if there were no tests.




Exercise 3: Configuration Management
=======================================

Deliverable
----------------
http://localhost:8090/job/exercise3_android_sdk_centos/

Completion            Steps
--------------------------------------------------------------------------
(1/3)                 To create 3 jenkins-slaves (centos,osx and windows)
complete:             To autowire the slaves using the Swarm plugin
complete(centos/osx)  To integrate this using Puppet and Hiera
complete:             To install the android-dev and wget (dependency) module.
(2/3)                 To add puppet/roles/jenkins_slave/manifests/android.pp
complete:             Wire it in using init.pp in the same directory
(1/3):                To add each slave node into nodes.json
complete:             To create a job that takes a labeled ('slave') and executes an android sdk command.

Pseudo Code for Windows Slave
----------------------------
add the distribution location in hiera
create a puppet class in the roles to use the wget module to download the distribution
Invesigate the use of the Archive module to unpack the distribution else use the exec resource.
Update the environment variables (ANDROID_HOME and add ANDROID_HOME/tools and platform-tools to  the system PATH ) on the slaves (with 'androidsdk' labels )
In the Android.pp class , I would either include a case statement (or hiera variable in the node definition)  to use the above logic or default to the Android-dev puppet module configuration.

Further Notes
----------------

As the android puppet module has been developed to work on both osx and centos, I would have to either augment/wrap the module to cater for the  windows environment

I was unable to find a windows and osx image that would run on virtualbox and vagrant and was sufficiently compact in size.

I also investiaged whether I would be able to install the jenkins docker plugin and source the windows and osx docker images.

It was also possible to investigate developing a  custom jenkins tooling to install the androidsdk distributions on-demand.





