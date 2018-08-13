set -e

# After we will do this again once we have the debug repos added.
apt-get update
apt-get install --yes \
    ubuntu-dbgsym-keyring

# Since we're doing some heavy debugging related things we need the dbg repos
CODENAME=$(lsb_release -c | awk  '{print $2}')
echo "deb http://ddebs.ubuntu.com/ ${CODENAME}      main restricted universe multiverse" \
    >> /etc/apt/sources.list.d/ddebs.list
# Seems there is no `bionic-security` repo.
# echo "deb http://ddebs.ubuntu.com/ ${CODENAME}-security      main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
echo "deb http://ddebs.ubuntu.com/ ${CODENAME}-updates      main restricted universe multiverse" \
    >> /etc/apt/sources.list.d/ddebs.list
echo "deb http://ddebs.ubuntu.com/ ${CODENAME}-proposed      main restricted universe multiverse" \
    >> /etc/apt/sources.list.d/ddebs.list

# Upgrade the node and bootstrap some packages.
apt-get update
apt-get upgrade --yes

# Kernel with the debugging symbols for systemtap etc.
apt-get install --yes \
   linux-image-$(uname -r)-dbgsym

# Basics, requirements.
apt-get install --yes \
    curl \
    git \
    tree \
    docker.io \
    docker-compose

# Basics, try to get common useful tools folks might commonly use.
apt-get install --yes \
    htop \
    powertop \
    neovim \
    emacs \
    vim \
    mosh \
    fish \
    zsh

# Namazu
apt-get install --yes \
    git \
    golang \
    libzmq3-dev \
    libnetfilter-queue-dev
curl -L \
    "https://github.com/osrg/namazu/releases/download/v0.2.1/nmz.linux-x86_64.static" \
    -o /usr/bin/nmz
chmod +x \
    /usr/bin/nmz

# Pumba
curl -L \
    "https://github.com/alexei-led/pumba/releases/download/0.5.0/pumba_linux_amd64" \
    -o /usr/bin/pumba
chmod +x \
    /usr/bin/pumba

# Systemtap
apt-get install --yes \
    systemtap \
    gcc

# Fail-rs
curl -sSf \
    https://sh.rustup.rs \
    | sh -s -- \
    -y
# TODO: Demo project of fail-rs.
