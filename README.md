# docker-openlitespeed-wordpress

## Usage

### Prepare wordpress environment

#### New installation.

##### Start containers

```
$ docker-compose up -d
```

### Access top page of website

1. Access to http://localhost:8080

### Access management portal of wordpress

1. Access to http://localhost:8080/wordpress/wp-admin/

2. Login to wordpress with wp_user/wp_pw

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
