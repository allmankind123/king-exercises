class jenkins_slave {
  contain jenkins_slave::slave
  contain jenkins_slave::package
  contain jenkins_slave::android
}
