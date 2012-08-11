class hubot inherits hubot::params {
  include stdlib
  
  anchor { 'hutbot::begin': }
  -> class { 'hubot::package': }
  -> class { 'hubot::config': }
  ~> class { 'hubot::service': }
  -> anchor { 'hubot::end': }
}
