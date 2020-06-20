# docker-openlitespeed-wordpress

## Usage

### Clone this repository

```
$ git clone https://github.com/stedplay/docker-openlitespeed-wordpress.git site_name/
$ cd site_name/
```

### Prepare wordpress environment

There are two ways to prepare the wordpress environment.

- (A) New installation.
- (B) Mirroring remote environment using wordmove.

#### (A) New installation.

##### Edit .env

```
$ vi .env
$ cat .env | grep WORDPRESS_INITIAL_INSTALL
WORDPRESS_INITIAL_INSTALL=true
$
```

##### Start containers

```
$ docker-compose up -d
```

#### (B) Mirroring remote environment using wordmove.

##### Put private key for ssh

```
$ ls -1 ~/.ssh/your_ssh_rsa
${HOME}/.ssh/your_ssh_rsa
$
```

##### Edit .env

```
$ vi .env
$ cat .env | grep WORDPRESS_INITIAL_INSTALL
WORDPRESS_INITIAL_INSTALL=false
$
```

Edit following variables according to remote environment.

```
$ cat .env | grep -e WEB_HTML_SCHEME -e WEB_HTML_EXPOSE_PORT -e WORDPRESS_SITEURL_DIR
WEB_HTML_SCHEME=https
WEB_HTML_EXPOSE_PORT=443
WORDPRESS_SITEURL_DIR=/wordpress
$
```

##### Copy and edit movefile.yml

Edit variables defined below 'production:' to appropriate values of remote environment in movefile.yml.

```
$ ls -1 ./migrator/conf/
movefile.yml.template
$ cp -p ./migrator/conf/movefile.yml.template ./migrator/conf/movefile.yml
$ vi ./migrator/conf/movefile.yml
```

##### Start containers

```
$ docker-compose up -d
```

##### Login to migrator container

```
$ docker-compose exec migrator bash
Agent pid 12
/html#
```

##### Adds private key for ssh to ssh-agent

```
/html# ssh-add ~/.ssh/your_ssh_rsa
Enter passphrase for /root/.ssh/your_ssh_rsa:
Identity added: /root/.ssh/your_ssh_rsa (/root/.ssh/your_ssh_rsa)
/html# ssh-add -l
2048 SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX /root/.ssh/your_ssh_rsa (RSA)
/html#
```

##### Mirror wordpress files and database from remote environment

```
/html# ls -1
movefile.yml
movefile.yml.template
/html# wordmove pull --all
```

##### Create wp-config.php

```
/html# cd /var/www/html${WORDPRESS_SITEURL_DIR}
/var/www/html/wordpress# wp core config --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${DB_HOST} --allow-root
/var/www/html/wordpress# ls -1 wp-config.php
wp-config.php
/var/www/html/wordpress# exit
$
```

##### Restart web server

```
$ docker-compose exec web /usr/local/lsws/bin/lswsctrl restart
[OK] Send SIGUSR1 to 31
$
```

### Access top page of website

1. Access to http://localhost:8080

### Access management portal of wordpress

1. Access to http://localhost:8080/wordpress/wp-admin/

2. Login to wordpress with

  - (A) wp_user/wp_pw
  - (B) same user/password as remote environment

### Access management portal of openlitespeed

1. Access to http://localhost:7080

2. Login to openlitespeed with admin/123456

### Stop and restart containers (Leave persistent data)

```
$ docker-compose down --rmi all
$ docker-compose up -d
```

### Reset environment (Delete persistent data)

```
$ docker-compose down --rmi all
$ rm -r ./db/mysql/ ./web/html/ ./web/lsws/
```
