#!/bin/bash

vagrant up
vagrant ssh

stacklet /vagrant/stacklets/erlang-R14B04.sh
stacklet /vagrant/stacklets/git-1.7.0.sh
stacklet /vagrant/stacklets/python-2.7.2.sh
stacklet /vagrant/stacklets/ruby-1.9.2-p290.sh

ls
  erlang-R14B04.tgz git-1.7.0.tgz python-2.7.2.tgz ruby-1.9.2-p290.tgz

stack /vagrant/stacklets/cedar-2.0.0.sh
ls /tmp
  cedar-2.0.0.tgz erlang-R14B04.tgz git-1.7.0.tgz python-2.7.2.tgz ruby-1.9.2-p290.tgz

tar2img /tmp/cedar-2.0.0.tgz
tar2deb /tmp/erlang-R14b04.tgz
ls /tmp
  cedar-2.0.0.tgz cedar-2.0.0.img.tgz erlang-R14B04.deb erlang-R14B04.tgz 

deb2tar --ppa ppa:pitti/postgresql postgresql
-> Resolving postgresql 9.1
       Downloading and Extracting ssl-cert_1.0.23ubuntu2_all.deb
       Downloading and Extracting libpq5_9.1.1-1~lucid_amd64.deb
       Downloading and Extracting postgresql-client-common_124~lucid_all.deb
       Downloading and Extracting postgresql-client-9.1_9.1.1-1~lucid_amd64.deb
       Downloading and Extracting postgresql-common_124~lucid_all.deb
       Downloading and Extracting postgresql-9.1_9.1.1-1~lucid_amd64.deb
       Downloading and Extracting postgresql_9.1+124~lucid_all.deb
ls /tmp/
  postgresql-9.1.tgz

######

TARGET_DIR=lucid
MOUNT_DIR=/mnt/$TARGET_DIR
IMG_FILE=lucid.img

apt-get update
apt-get install -y debootstrap
debootstrap --variant=minbase lucid $TARGET_DIR

dd if=/dev/zero of=$IMG_FILE bs=100M count=24
yes | mkfs -t ext3 -m 1 $IMG_FILE
tune2fs -c 9999  $IMG_FILE
tune2fs -i 9999w $IMG_FILE

mkdir -p $MOUNT_DIR
mount -o loop,noatime,nodiratime $IMG_FILE $MOUNT_DIR

(
  cd $TARGET_DIR
  rsync -a --exclude=/lib/modules bin etc lib lib64 sbin usr $MOUNT_DIR
  rsync -a var/lib $MOUNT_DIR/var
)

for d in app tmp proc dev var var/log var/tmp home/group_home mnt/slug-compiler; do
  mkdir -p $MOUNT_DIR/$d
done
chmod 755 $MOUNT_DIR/home/group_home

echo "127.0.0.1 localhost localhost.localdomain" > $MOUNT_DIR/etc/hosts

echo "heroku-runtime" > $MOUNT_DIR/etc/hostname

for f in etc/profile etc/bash.bashrc; do
  echo "export PS1='\\[\\033[01;34m\\]\\w\\[\\033[00m\\] \\[\\033[01;32m\\]$ \\[\\033[00m\\]'" > $MOUNT_DIR/$f
done

cat >$MOUNT_DIR/etc/resolv.conf <<EOF
nameserver 172.16.0.23
domain z-2.compute-1.internal
search z-2.compute-1.internal
EOF

cat > $MOUNT_DIR/home/group_home/.gitconfig <<EOF
[user]
  name = Heroku Git
  email = git@heroku.com
EOF