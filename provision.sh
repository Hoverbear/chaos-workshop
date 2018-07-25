set -e

# Install monitoring.
curl -sSL https://agent.digitalocean.com/install.sh | sh

apt-get update
apt-get install --yes ubuntu-dbgsym-keyring

# Since we're doing some heavy debugging related things we need the dbg repos
CODENAME=$(lsb_release -c | awk  '{print $2}')
echo "deb http://ddebs.ubuntu.com/ ${CODENAME}      main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
# Seems there is no `bionic-security` repo.
# echo "deb http://ddebs.ubuntu.com/ ${CODENAME}-security      main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
echo "deb http://ddebs.ubuntu.com/ ${CODENAME}-updates      main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
echo "deb http://ddebs.ubuntu.com/ ${CODENAME}-proposed      main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list

# Oupgrade the cluster
apt-get update
apt-get upgrade --yes

# Install the kernel with the debugging symbols for systemtap etc.
apt-get install --yes linux-image-$(uname -r)-dbgsym

# Basics
apt-get install --yes htop curl git software-properties-common powertop tree neovim docker.io docker-compose mosh

# Namazu
apt-get install --yes git golang libzmq3-dev libnetfilter-queue-dev
curl -L "https://github.com/osrg/namazu/releases/download/v0.2.1/nmz.linux-x86_64.static" -o /usr/bin/nmz
chmod +x /usr/bin/nmz

# Systemtap
apt-get install --yes systemtap gcc

# Fail-rs
curl https://sh.rustup.rs -sSf | sh -s -- -y
# TODO: Demo project of fail-rs.
