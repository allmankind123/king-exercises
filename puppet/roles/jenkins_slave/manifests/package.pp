class jenkins_slave::package {

  package { 'ruby':
    ensure => 'installed'
  }
}
