class hubot::config (
  $adapter,
  $install_dir,
  $daemon_user,
  $daemon_pass = undef,
  $irc_nickname = undef,
  $irc_password = undef,
  $irc_server = undef,
  $irc_rooms = undef,
  $campfire_account = undef,
  $campfire_rooms = undef,
  $campfire_token = undef,
  $vagrant_hubot,
  $environment = undef
) inherits hubot::params {

  # Sanity check config
  case $adapter {
    irc: {
        if (!defined($irc_nickname)) and ($irc_rooms[0] == '') and (!defined($irc_server)) {
            fail("Required Options missing: $adapter requires options: irc_nickname, irc_server, irc_rooms")
	}
    }
    campfire: {
        if (!defined($campfire_account)) and ($campfire_rooms[0] == '') and (!defined($campfire_token)) {
            fail("Required Options missing: $adapter requires options: campfire_account, campfire_rooms, campfire_token")
	}
    }
    default:  {
      fail("Unsupported Adapter: ${adapter}. Supported Adpaters: irc|campfire")
    }
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  Exec {
    path => '/bin:/usr/bin:/sbin:/usr/sbin',
  }

  file { '/etc/init.d/hubot':
    ensure  => file,
    mode    => '0755',
    content => template('hubot/hubot.init.erb')
  }

  # User Account for Hubot
  user { $daemon_user:
    ensure     => present,
    comment    => 'Hubot Daemon user',
    home       => "/home/${daemon_user}",
    shell      => '/bin/bash',
    managehome => true,
    password   => $daemon_pass,
  }

  # Main hubot configuration file
  file { "${install_dir}/package.json":
    ensure  => file,
    content => template('hubot/package.json.erb'),
    notify  => Exec['install hubot deps'],
  }

  # Notification of installation comes from hubot::package
  exec { 'install hubot deps':
    command     => 'npm install',
    cwd         => $install_dir,
    refreshonly => true,
  }
  file { '/usr/local/sbin/rebuild-hubot-scripts.rb':
    ensure  => present,
    mode    => '0755',
    content => template('hubot/rebuild-hubot-scripts.rb.erb'),
    before  => Exec['rebuild hubot scripts'],
  }

  if $vagrant_hubot != false {
    exec { 'rebuild hubot scripts':
      command => 'ruby /usr/local/sbin/rebuild-hubot-scripts.rb',
    }
    file { "${install_dir}/scripts":
      ensure => symlink,
      target => $vagrant_hubot,
      force  => true,
    }
  } else {
    # Create a repository for scripts that hubot will read
    file { "${install_dir}/scripts":
      ensure  => directory,
      purge   => true,
      recurse => true,
    }
    exec { 'rebuild hubot scripts':
      command     => 'ruby /usr/local/sbin/rebuild-hubot-scripts.rb',
      refreshonly => true,
      subscribe   => File["${install_dir}/scripts"],
    }
    # End File Fragment
  }
}
