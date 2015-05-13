package { 'zsh': } ->
class { 'docker': } ->
user { 'eshamow':
  ensure => present,
  managehome => true,
  groups     => 'docker',
  shell      => '/usr/bin/zsh',
}
exec { 'install_oh_my_zsh':
  command => '/usr/bin/curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | /bin/sh',
  user    => 'eshamow',
  creates => '/home/eshamow/.oh-my-zsh',
}
file { ['/proj','/proj/eshamow']:
  ensure => directory,
}
vcsrepo { '/proj/eshamow/dotfiles':
  ensure     => present,
  provider   => git,
  source     => 'https://github.com/eshamow/dotfiles',
  submodules => false,
}
file { '/home/eshamow/.vimrc':
  ensure  => link,
  target  => '/proj/eshamow/dotfiles/vimrc',
  require => [Vcsrepo['/proj/eshamow/dotfiles'], User['eshamow']],
}
file { '/home/eshamow/.vim':
  ensure  => link,
  target  => '/proj/eshamow/dotfiles/vim',
  require => [Vcsrepo['/proj/eshamow/dotfiles'], User['eshamow']],
}
file { '/home/eshamow/.ssh':
  ensure => directory,
  owner  => 'eshamow',
  group  => 'eshamow',
  mode   => '0600',
}
file { '/home/eshamow/.ssh/authorized_keys':
  ensure  => file,
  owner   => 'eshamow',
  group   => 'eshamow',
  mode    => '0400',
  content => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAuOXYbTgVygIMYoJYTv7g2XhqHGa5KjiQe2V4+SwwPCMM1a2/BuzAb0OETFh4YyQtLbJIC9a6hA0LmmiJZJ0dy81GpMhjCfemCpElS6US7icS9mVzkU7rv+NGH507POw01OBNdmLLiildr7yvk5EEzXWKfch0f+xXnTvgQtq3i99GfFuwk+sKj1iFPKlNrEfeapJbrpd4sPRrxZ7bm5X+Ozdenowwa363aFFQbfbqXA6PUzpMBMtIV1qQ0T+zbUSeJy9s7jZDO4jJESWhKSLC/xHqzaaWomxxciSIoIg1djd8l826aoF5IX6if/6tYGHN41Z2lY2GG4chNUlvz15JdQ== eric@Aimee-Faheys-MacBook-Pro-2.local'
}
swap_file::files { 'default':
  ensure   => present,
  swapfile => '/swapfile',
}
sysctl { 'vm.swappiness': value => '10' }
sysctl { 'vm.vfs_cache_pressure': value => '50' }
class { 'rbenv': }
rbenv::plugin { 'sstephenson/ruby-build': }
rbenv::build { '2.2.2': global => true }
cron { 'clean_exited_containers':
  command => 'docker ps -a | grep Exited | awk "{print $1};" | xargs docker rm -f',
  user    => root,
  minute  => 15,
  hour    => '*/4',
}
cron { 'clean_unused_images':
  command => 'docker images | grep "<none>" | awk "{print $3};" | xargs docker rmi',
  user    => root,
  minute  => 30,
  hour    => '*/4',
}
