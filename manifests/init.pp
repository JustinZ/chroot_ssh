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
      notify {"$folders_for_user is created for $username":}
      $folders_for_user.each | String $dir_name |
      {
        file {"${dir_name}/inbox/" :
          path => "${dir_name}/inbox/",
          ensure => $ensure,
          owner => $username,
          group => $group,
          mode => $mode,   
          }
        file {"${dir_name}/outbox/" :
          path => "${dir_name}/outbox/",
          ensure => $ensure,
          owner => $username,
          group => $group,
          mode => $mode,  
          }
      $parent = regsubst($dir_name, '/[^/]*/?$', '')
      if ($parent != $dir_name) and ($parent != '') 
      {
        exec { "create parent directory $parent for $dir_name": 
        command => "/bin/mkdir -p $parent",
        creates => "$parent",
        before => File[$dir_name]
        }
      }
    }
  }

}
else {
  notify {"this is not a primary node, will not create DRBD folders":}   
  }
}
