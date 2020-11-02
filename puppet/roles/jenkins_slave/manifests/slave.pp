class jenkins_slave::slave {

 $master_url =  hiera('jenkins_slave::slave::master_url')
 $executors  =  hiera('jenkins_slave::slave::executors',1)
 $slave_mode =  hiera('jenkins_slave::slave::slave_mode',"exclusive")
 $labels     =  hiera('jenkins_slave::slave::labels', ["slave"])

 class { 'jenkins::slave':
        masterurl   => $master_url,
        executors   => $executors,
        slave_mode  => $slave_mode,
        labels      => $labels
      }

}
