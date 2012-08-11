class hubot::config {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/init.d/hubot':
    ensure  => file,
    mode    => '0755',
    content => template('hubot/hubot.init.erb')
  }

  user { 'hubot':
    ensure     => present,
    password   => '$1$ihlrowCw$ry859tfQCVnvwpsT.dDIR0',
    managehome => true,
    comment    => 'hubot daemon user',
    home       => '/home/hubot',
    shell      => '/bin/bash',
  }
}
