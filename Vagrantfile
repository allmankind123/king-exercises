VAGRANTFILE_API_VERSION = "2"
nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']


 Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
   config.hostmanager.enabled = false
   config.vbguest.auto_update = false
   config.winrm.timeout =   1800


   nodes_config.each do |node|
     node_name   = node[0].dup 
     node_values = node[1].dup

     config.vm.boot_timeout = 1200
     config.vm.synced_folder ".", "/vagrant", disabled: false
     # config.vm.synced_folder ".", "/vagrant", type: "nfs"
     config.vm.define node_name.dup  do |config|

       config.vm.box = node_values[':vagrant_image'] 
       config.vm.hostname = node_name.dup
       config.vm.network "private_network", ip: node_values[':ip']
       config.vm.network "forwarded_port", host: node_values[":forward_port_web"], guest: 8080, id: "web"
       config.vm.network "forwarded_port", host: node_values[":forward_port_ssh"], guest: 22, id: "ssh"

       config.vm.provider :virtualbox do |v|

         v.name = node_name.dup
         v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
         v.customize ["modifyvm", :id, "--memory", 512]
         v.customize ["modifyvm", :id, "--name", node_name.dup]
         v.customize ["modifyvm", :id, "--usb", "off"]
         v.customize ["modifyvm", :id, "--usbehci", "off"]

       end

       config.vm.provision :puppet do |puppet|

         puppet.module_path       = ["puppet/roles", "puppet/modules" ]
         puppet.manifests_path    = "puppet/manifests"
         puppet.manifest_file     = "site.pp"
         puppet.hiera_config_path = "puppet/hiera.yaml"
         puppet.working_directory = "/tmp/vagrant-puppet"
         puppet.options           = "--verbose --debug"

      end

     config.vm.provision :shell, :path => node_values[':bootstrap']

   end #node_name
     
  end #nodes_config 

end #Vagrant-configure 


