Stacker
=======

Stacker is a simple apt package to tgz convertor. It uses Vagrant and an Ubuntu 
10.04 image to perform apt operations.

Quick Start
===========

First, make sure your development machine has 
[VirtualBox](http://www.virtualbox.org) installed.

```bash
$ bundle install
$ bin/vstack --ppa ppa:pitti/postgresql postgresql
-> Starting Vagrant
       [default] Downloading box: http://files.vagrantup.com/lucid64.box
       [default] Running provisioner: Vagrant::Provisioners::Shell...
-> Adding Repository ppa:pitti/postgresql
-> Updating apt
-> Resolving postgresql 9.1
       Downloading and Extracting ssl-cert_1.0.23ubuntu2_all.deb
       Downloading and Extracting libpq5_9.1.1-1~lucid_amd64.deb
       Downloading and Extracting postgresql-client-common_124~lucid_all.deb
       Downloading and Extracting postgresql-client-9.1_9.1.1-1~lucid_amd64.deb
       Downloading and Extracting postgresql-common_124~lucid_all.deb
       Downloading and Extracting postgresql-9.1_9.1.1-1~lucid_amd64.deb
       Downloading and Extracting postgresql_9.1+124~lucid_all.deb
-> Stacking /tmp/stacklets/postgresql-9.1.tgz
```

The resulting stacklet will be in `./stacklets/postgresql-9.1.tgz` on the host.

Usage
=====

```bash
$ stack --help
Usage: stack [--ppa PPA ...] PACKAGE ...
Fetch PACKAGE and all dependencies and re-package as a .tgz
Example: stack --ppa ppa:pitti/postgresql postgresql

Apt Source Options:
  -p, --ppa     Personal Package Archive to add. Can specify more than one.

If multiple PACKAGE options are specified, the entire set of packages and
dependencies will be archived together. The first package specified determines
the name of the stacklet file.
```

