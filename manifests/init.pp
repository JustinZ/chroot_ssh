# Class: sftp_folders
#
# This module manages chroot folders and sshd MatchConfig string
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#


class chroot_ssh
(
  $folders = undef,
  $dir_list = undef,
  $ensure = 'directory',
  $owner = undef,
  $group = 'root',
  $mode = '0650',
) 
{
if $::drbd_node_status == 'Primary' {
  notify {"this is primary node, creating sftp folders":}
  $folders.each | $username, $folders_for_user | {
      notify {"####### $folders_for_user is created for $username #####":}
      folders_for_user.each | Integer $number, String $dir_name |
      {
        notice("${dir_name}")
        #notify {"$number":
        #  message => "$number current dir is $dir_name"
         # }
      }
  }
 #keys($dir_list).each | String $client_env |  
 #{
 #  $dir_list[$client_env][directory].each|String $dir_name |
 #  {
 #    file {$dir_name :
 #      path => $dir_name,
 #      ensure => $ensure,
 #      owner => $dir_list[$client_env][owner],
 #      group => $group,
 #      mode => $mode,    
 #  }
 # 
 #  $parent = regsubst($dir_name, '/[^/]*/?$', '')
 #  if ($parent != $dir_name) and ($parent != '') {
 #    exec { "create parent directory $parent for $dir_name":
 #      command => "/bin/mkdir -p $parent",
 #      creates => "$parent",
 #      before => File[$dir_name]
 #    }
 #   }
 #  }
 #  }
  }
else {
  notify {"this is not a primary node, will not create DRBD folders":}   
  }
}
