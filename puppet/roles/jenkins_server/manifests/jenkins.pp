class jenkins_server::jenkins {

 $default_plugin_hash =  hiera('jenkins_server::jenkins::plugins', {})
 $jenkins_rpm         =  hiera('jenkins_server::jenkins::rpm')
 class { 'jenkins':
    direct_download       => $jenkins_rpm,
    configure_firewall    => false,
    plugin_hash           => $default_plugin_hash
}

}
