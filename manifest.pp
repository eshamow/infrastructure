class { 'docker': } ->
user { 'eshamow':
  ensure => present,
  managehome => true,
  groups     => 'docker',
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
swap_file::files { 'default':
  ensure   => present,
  swapfile => '/swapfile',
}
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
