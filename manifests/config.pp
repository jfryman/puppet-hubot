class hubot::config (
  $adapter,
  $install_dir,
  $daemon_user,
  $irc_nickname,
  $irc_password = undef,
  $irc_server,
  $irc_rooms,
  $vagrant_hubot
) inherits hubot::params {
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
    password   => '$1$ihlrowCw$ry859tfQCVnvwpsT.dDIR0',
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
