# Hubot package class
class hubot::package (
  $install_dir,
  $git_source,
) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  package { $hubot::packages:
    ensure => present,
  }
  package { $hubot::npm_packages:
    ensure   => present,
    provider => 'npm',
  }
  package { 'json':
        ensure   => installed,
        provider => gem,
  }
  exec { 'download hubot via git':
    command => "git clone ${git_source} ${install_dir}",
    creates => $install_dir,
    notify  => Class['hubot::config'],
  }
}
