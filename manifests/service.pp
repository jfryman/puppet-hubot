# Hubot service class
class hubot::service {
  service { $hubot::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
