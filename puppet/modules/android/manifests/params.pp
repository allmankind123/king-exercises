# == Class: android::params
#
# Defines some sensible default parameters.
#
# === Authors
#
# Etienne Pelletier <epelletier@maestrodev.com>
#
# === Copyright
#
# Copyright 2012 MaestroDev, unless otherwise noted.
#
class android::params {

  $version    = '22.3'
  $proxy_host = undef
  $proxy_port = undef
  $installdir = '/usr/local/android'

  $ndk_version = 'android-ndk-r10d-linux-x86_64.bin'

  case $::kernel {
    'Linux': {
      $user       = 'root'
      $group      = 'root'
    }
    'Darwin': {
      $user       = 'root'
      $group      = 'admin'
    }
    default: {
      fail("Unsupported Kernel: ${::kernel} operatingsystem: ${::operatingsystem}")
    }
  }
}
