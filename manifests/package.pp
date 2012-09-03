class hubot::package (
  $install_dir,
  $git_source
) inherits hubot::params {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  package { $hubot::params::packages:
    ensure => present,
  }
  package { $hubot::params::npm_packages:
    ensure   => present,
    provider => 'npm',
  }
  package {
    "json":
        ensure => installed,
        provider => gem,
  }
  exec { 'download hubot via git':
    command => "git clone ${git_source} ${install_dir}",
    creates => $install_dir,
    notify  => Class['hubot::config'],
  }
}
