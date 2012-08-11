class hubot::params {
  case $::operatingsystem {
    debian: {
      $packages = ['build-essential', 'libssl-dev', 'git-core', 
                   'redis-server', 'libexpat1-dev'
                  ]
      $npm_packages = ['coffee-script']
      $service_name = 'hubot'
    }
  }
}
