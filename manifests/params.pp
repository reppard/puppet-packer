class packer::params {
  case $::osfamily {
    'Debian','RedHat','Darwin': {
      $owner = 'root'
      $group = 'root'
      $staging_dir = '/tmp'
      $install_dir = '/opt/hashicorp'
      $symlink = '/usr/loca/bin/packer'
    }
    'Windows': {
      $staging_dir = 'C:/WINDOWS/Temp'
      $install_dir = 'C:/HashiCorp'
      $symlink = 'C:/Windows/System32/packer'
    }
    default: {fail("OS family ${::osfamily} not supported by this module!")}
  }

  case $::architecture {
    'amd4', 'x64', 'x86_64': { $architecture = 'adm64' }
    default: { $architecture = '386' }
  }
  
  $base_url = 'https://dl.bintray.com/mitchellh/packer'
}
