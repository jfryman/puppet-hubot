

class hubot (
  $adapter      = $hubot::params::options['adapter'],
  $install_dir  = $hubot::params::options['install_dir'],
  $git_source   = $hubot::params::options['git_source'],
  $daemon_user  = $hubot::params::options['daemon_user'],
  $irc_nickname = $hubot::params::irc['nickname'],
  $irc_password = undef,
  $irc_server   = $hubot::params::irc['server'],
  $irc_rooms    = $hubot::params::irc['rooms']
) inherits hubot::params {
  include stdlib

  anchor { 'hutbot::begin': }
  -> class { 'hubot::package': 
    install_dir => $install_dir,
    git_source  => $git_source,
  }
  -> class { 'hubot::config': 
    adapter      => $adapter,
    install_dir  => $install_dir,
    daemon_user  => $daemon_user,
    irc_nickname => $irc_nickname,
    irc_password => $irc_password,
    irc_server   => $irc_server,
    irc_rooms    => $irc_rooms,
  }
  ~> class { 'hubot::service': }
  -> anchor { 'hubot::end': }
}
