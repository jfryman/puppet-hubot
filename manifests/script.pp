define hubot::script (
  $source,
  $type = 'download',
  $format = 'coffee',
  $install_dir = undef
) {
  include hubot::params

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  # Make sure $install_dir is set properly
  if $install_dir == undef {
    $REAL_install_dir = $hubot::params::options['install_dir']
  } else { 
    $REAL_install_dir = $install_dir
  }

  # File format isn't going to come from the
  # title of the definition, so let's give
  # the user an attribute they can set 
  # to make sure that all is good with the world.
  case $format {
    js,javascript: { $file_extension = 'js' }
    cs,coffee,coffeescript: { $file_extension = 'coffee' }
    default: {
      fail("Unsupported Type: ${type}. Allowed are: js,javascript| cs,coffee,coffeescript")
    }
  }

  # Different options for a local file out of a repo
  # or via a download link (http)
  case $type {
    download,www,wget: {
      exec { "download hubot script: ${name}":
        command => "wget ${source} -O ${REAL_install_dir}/scripts/${name}.${file_extension}",
        creates => "${REAL_install_dir}/scripts/${name}.${file_extension}",
	notify  => File["${REAL_install_dir}/scripts/${name}.${file_extension}"],
      }
      # Ensure Puppet knows about the file
      # to ensure the File-Fragment is okay.
      file { "${REAL_install_dir}/scripts/${name}.${file_extension}":
        ensure       => file,
      }
    }
    puppet,local: {
      # Ensure Puppet knows about the file
      # to ensure the File-Fragment is okay.
      file { "${REAL_install_dir}/scripts/${name}.${file_extension}":
        ensure => file,
        source => $source,
      }
    }
  }
}
