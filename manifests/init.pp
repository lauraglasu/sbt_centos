class sbt_centos ($source_url = "https://dl.bintray.com/sbt/rpm", 
  $sbt_major_version = 13, 
  $sbt_minor_version = 6,
  ) {
 
  $sbt_filename = "sbt-0.${sbt_major_version}.${sbt_minor_version}.rpm"

 # Install java openJDK
  exec { "java":
    command     => "/usr/bin/yum -y install java",
  }   
  
  exec { "java-devel":
    command     => "/usr/bin/yum -y install java-devel",
  }   
 
 # Download sbt from location of choice
  include wget
  
  wget::fetch { 'sbt':
    source      => "${source_url}/$sbt_filename",
    destination => "/usr/local/$sbt_filename",
    timeout     => 0,
    verbose     => false,
  }
  ->
  # Install sbt
  package {'sbt':
    provider => rpm,
    ensure   => "0.${sbt_major_version}.${sbt_minor_version}",
    source   => "/usr/local/$sbt_filename",
    require  => [ Exec['java'],
			Exec['java-devel']
			]
  }

  notify { "Major Version: $sbt_major_version, Minor Version: $sbt_minor_version": }

}
