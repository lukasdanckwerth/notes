# PostgreSQL

- [Users](#users)
- [Database](#database)

## Users
When installing postgreSQL the user `postgres` is already created. To login use:
```shell
$ sudo -i -u postgres
```

To run the postgres command line interface then use:
```shell
$ psql
```

Instead of the two previous commands they can be combined to:
```shell
$ sudo -u postgres psql
```

To quit the postgres cli use `\q`:
```postgres
postgres=# \q
```

### Create new database user
To create a new pg database user type:
```shell
# assuming you are logged in as postgres
$ createuser --interactive
```

### Create new linux user
> Note that first it's necessary to have a linux user for a database user and second you can't be logged in as `postgres` user for this action.
```shell
$ sudo adduser john

# if you would like to set a password for the new user
$ sudo passwd john

# to start the postgres cli as user john use:
$ sudo -u sammy psql [-d $DATABASE_NAME]
```

## Database
To create a new database named `john`:
```shell
# assuming you are logged in as postgres
$ createdb sammy
```

### Create database
As user `postgres` you type
```shell
# assuming you are logged in as postgres
postgres@pc:~$ createuser --interactive
```
