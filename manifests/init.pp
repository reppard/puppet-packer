class packer(
  $version,
  $install_dir = $::packer::params::install_dir,
  $base_url = $::packer::params::base_url,
  $owner = $::packer::params::owner,
  $group = $::packer::params::group,
  $architecture = $::packer::params::architecture,
  $timeout = 600,
  $staging_dir = '/var/staging'
) inherits packer::params {

  multi_validate_re($version, $architecture, $::kernel, $::architecture, '^.+$')
  validate_absolute_path($install_dir)
  validate_re($base_url, '^(http|https|ftp)\:\/\/.+$')
  validate_re("${timeout}", '^\d+$')
  if 'Windows' != $::kernel { multi_validate_re($owner, $group, '^.+$') }

  $package_name = downcase("${version}_${::kernel}_${architecture}.zip")
  $full_url = "${base_url}/${package_name}"

  if !defined(Class[::staging]) {
    class { '::staging':
      path => $staging_dir,
      owner => 'puppet',
      group => 'puppet', }
  }

  $install_path = dirtree($install_dir)
  file { $install_path:
    ensure => directory,
    owner => $owner,
    group => $group,
    mode => '0644',
  }

  include ::staging
  ::staging::file { $package_name: source => $full_url, } ->
  ::staging::extract { $package_name:
    target => $install_dir,
    creates => $::kernel ? {
      'Windows' => "${install_dir}/packer.exe",
      default => "${install_dir}/packer",
    },
    require => File[$install_path],
  }
}
