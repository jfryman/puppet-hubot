class hubot::service inherits hubot::params {
  service { $hubot::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
