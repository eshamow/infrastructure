apt-get update && apt-get install -y curl
curl -O https://apt.puppetlabs.com/puppetlabs-release-precise.deb && sudo dpkg -i puppetlabs-release-precise.deb
apt-get update
apt-get -y install puppet build-essential ruby-dev git
gem install librarian-puppet --no-ri --no-rdoc
cp Puppetfile /etc/puppet/
cp manifest.pp /etc/puppet/
cd /etc/puppet
librarian-puppet install
puppet apply -v ./manifest.pp
