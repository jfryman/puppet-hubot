class hubot::package inherits hubot::params {
  package { $hubot::params::packages:
    ensure => present,
  }

  package { $hubot::params::npm_packages:
    ensure   => present,
    provider => 'npm',
  }
}
