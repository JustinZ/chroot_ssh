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
        $full_path = "/chroot/$dir_name"
        exec {"check if $full_path parent folder presence":
          command => "/bin/mkdir -p $full_path",
          creates => "$full_path",
          onlyif => "/usr/bin/test ! -e $full_path",
        }
        file {"${full_path}/inbox/" :
          path => "/$full_path/inbox/",
          ensure => $ensure,
          owner => $username,
          group => $group,
          mode => $mode,
          require => Exec["check parent folder presence"],
          before => File["${full_path}/outbox"]
          }
        file {"${full_path}/outbox/" :
          path => "/$full_path/outbox/",
          ensure => $ensure,
          owner => $username,
          group => $group,
          require => Exec["check parent folder presence"],
          mode => $mode,  
          }
          }
    }
  }
else {
  notify {"this is not a primary node, will not create DRBD folders":}
  }
}
