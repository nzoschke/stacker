#!/bin/bash

exec 2>&1
set -ex

cat > /etc/apt/sources.list <<EOF
deb http://archive.ubuntu.com/ubuntu lucid main
deb http://archive.ubuntu.com/ubuntu lucid-security main
deb http://archive.ubuntu.com/ubuntu lucid-updates main
deb http://archive.ubuntu.com/ubuntu lucid universe
EOF

apt-get update

export LANG=en_US.UTF-8
apt-get install -y --force-yes language-pack-en
/usr/sbin/update-locale LANG=en_US.UTF-8

apt-get install -y --force-yes coreutils tar build-essential autoconf
apt-get install -y --force-yes libxslt-dev libxml2-dev libglib2.0-dev libbz2-dev libreadline5-dev zlib1g-dev libevent-dev libssl-dev libpq-dev libncurses5-dev libcurl4-openssl-dev libjpeg-dev libmysqlclient-dev
apt-get install -y --force-yes daemontools
apt-get install -y --force-yes curl netcat telnet
apt-get install -y --force-yes ed bison
apt-get install -y --force-yes strace gdb
apt-get install -y --force-yes openssh-client openssh-server


# build packages from src
cd /tmp




stacklet squashfs-tools_3.3 --source http://launchpadlibrarian.net/11397899/squashfs-tools_3.3-1ubuntu2_amd64.deb
stacklet postgresql-9.1     --source postgresql --ppa ppa:pitti/postgresql
stacklet ruby-1.9.2-p290    --source http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz --dest s3://stacklets/ --deb -s <<EOF
  configure --prefix=/usr/local
  make && make install
EOF

s3cmd put ruby-1.9.2-p290.* s3://stacklets/

STACKLET=ruby-1.9.2-p290                                              \
SOURCES="http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz"  \
package <<EOF
  
EOF

(
  STACKLET="ruby-1.9.2-p290"
  mkdir root/ data/
  (
    cd root
    curl -O http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz | tar xfz root/
    configure --prefix=/usr/local
    make && make install DESTDIR=../data/
  )

  fpm -s dir -t deb -n $STACKLET -v 1.0 data/
  s3cmd put $STACKLET.deb s3://stacklets/
  s3cmd url --ttl=10000000 s3://stacklets/$STACKLET.deb
)

(
  mkdir root/ data/
  stacklet="squashfs-tools_3.3"
  pkgs="http://launchpadlibrarian.net/11397899/squashfs-tools_3.3-1ubuntu2_amd64.deb"
  for u in $pkgs; do
    deb=$(basename $u)
    curl --retry 3 --max-time 60 --write-out %{http_code} --silent -O $u
    ar -x $deb
    tar xfz data.tar.gz -C data/
  done

  fpm -s dir -t deb -a all -n $STACKLET -v 1.0 data/
  s3cmd put $STACKLET.deb s3://stacklets/
  s3cmd url --ttl=10000000 s3://stacklets/$STACKLET.deb
)

(
  mkdir root/ data/
  stacklet="openjdk-6-jdk"
  pkgs="openjdk-6-jdk openjdk-6-jre-headless"
  urls=$(apt-get -y --print-uris install $pkgs | egrep -o --regex '[a-z]+://[^ ]*deb')
  mkdir data
  for u in $urls; do
    deb=$(basename $u)
    wget -q $u
    ar -x $deb
    tar xfz data.tar.gz -C data/
  done
  fpm -s dir -t deb -a all -n $STACKLET -v 1.0 data/
  s3cmd put $STACKLET.deb s3://stacklets/
  s3cmd url --ttl=10000000 s3://stacklets/$STACKLET.deb
)


(
  mkdir root/ data/
  STACKLET=git-1.7.0 NO_EXPAT=yes NO_SVN_TESTS=yes NO_IPV6=yes NO_TCLTK=yes
  curl -O http://www.mirrorservice.org/sites/ftp.kernel.org/pub/software/scm/git/$STACKLET.tar.gz | tar xfz root/
  make && DESTDIR=data make install
  fpm -s dir -t deb -a all -n $STACKLET -v 1.0 data/
  s3cmd put $STACKLET.deb s3://stacklets/
  s3cmd url --ttl=10000000 s3://stacklets/$STACKLET.deb
)

(
  STACKLET=git-1.7.0 NO_EXPAT=yes NO_SVN_TESTS=yes NO_IPV6=yes NO_TCLTK=yes
  curl -O http://www.mirrorservice.org/sites/ftp.kernel.org/pub/software/scm/git/$STACKLET.tar.gz | tar xfz root/
  make && DESTDIR=data make install
  fpm -s dir -t deb -a all -n $STACKLET -v 1.0 data/
  s3cmd put $STACKLET.deb s3://stacklets/
  s3cmd url --ttl=10000000 s3://stacklets/$STACKLET.deb
)


# delete everything that should not be captured

