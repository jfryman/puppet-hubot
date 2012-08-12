define hubot::script (
  source,
  type = 'coffee'
) {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  case $type {
    js,javascript: { $file_extension = '.js' }
    cs,coffee,coffeescript: { $file_extension = '.coffee' }
    default: {
      fail("Unsupported Type: ${type}. Allowed are: js,javascript| cs,coffee,coffeescript")
    }
  }

  exec { "download hubot script: ${name}":
    command => "wget ${source} -O /opt/hubot/scripts/${name}.${file_extension}",
    creates => "/opt/hubot/scripts/${name}.${file_extension}",
  }

  # Ensure Puppet knows about the file
  # to ensure the File-Fragment is okay.
  file { "/opt/hubot/scripts-enabled/${name}.${file_extension}":
    ensure => file,
  }
}
