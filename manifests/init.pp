class hubot (
  $adapter          = $hubot::params::options['adapter'],
  $install_dir      = $hubot::params::options['install_dir'],
  $git_source       = $hubot::params::options['git_source'],
  $daemon_user      = $hubot::params::options['daemon_user'],
  $daemon_pass      = undef,
  $irc_nickname     = $hubot::params::irc['nickname'],
  $irc_password     = undef,
  $irc_server       = $hubot::params::irc['server'],
  $irc_rooms        = $hubot::params::irc['rooms'],
  $vagrant_hubot    = false,
  $campfire_account = undef,
  $campfire_rooms   = undef,
  $campfire_token   = undef,
  $environment      = undef,
) inherits hubot::params {
  include stdlib

  anchor { 'hutbot::begin': }
  -> class { 'hubot::package': 
    install_dir => $install_dir,
    git_source  => $git_source,
  }
  -> class { 'hubot::config': 
    adapter          => $adapter,
    install_dir      => $install_dir,
    daemon_user      => $daemon_user,
    daemon_pass      => $daemon_pass,
    irc_nickname     => $irc_nickname,
    irc_password     => $irc_password,
    irc_server       => $irc_server,
    irc_rooms        => $irc_rooms,
    campfire_account => $campfire_account,
    campfire_rooms   => $campfire_rooms,
    campfire_token   => $campfire_token,
    vagrant_hubot    => $vagrant_hubot,
    environment      => $environment,
  }
  ~> class { 'hubot::service': }
  -> anchor { 'hubot::end': }
}
