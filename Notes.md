Stacklets extracted from cedar
  apt-get install -y --force-yes imagemagick libmagick9-dev
  http://launchpadlibrarian.net/11397899/squashfs-tools_3.3-1ubuntu2_amd64.deb


-----
$ bin/vstack --ppa ppa:pitti/postgresql postgresql
-> Starting Vagrant
       [default] VM already created. Booting if its not already running...
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

$ s3cmd put stacklets/postgresql-9.1.tgz s3://stacklets/
stacklets/postgresql-9.1.tgz -> s3://stacklets/postgresql-9.1.tgz  [1 of 1]
 8650779 of 8650779   100% in   18s   464.41 kB/s  done

$ heroku create postgres -s cedar
$ heroku run --stacklet="$(s3cmd url --ttl=100000000 s3://stacklets/postgresql-9.1.tgz)" bash --app postgres

$ export PGDATA=/app
$ /usr/lib/postgresql/9.1/bin/pg_ctl init
$ /usr/lib/postgresql/9.1/bin/postgres -k $PGDATA -p $PORT
...
LOG:  database system is ready to accept connections
