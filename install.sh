apt-get update
apt-get -y install wget
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get -y install puppet build-essential ruby-dev
gem install librarian-puppet --no-ri --no-rdoc
librarian-puppet install
puppet apply -v ./manifest.pp
