# PostgreSQL

- [Users](#users)
  - [Create database user](#create-database-user)
  - [Create linux user](#create-linux-user)
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

```shell
postgres=# \q
```

### Create database user

To create a new database user:

```shell
# assuming you are logged in as postgres (sudo -i -u postgres)
$ createuser --interactive
```

Use `psql` to change password for newly created database user.

```shell
$ psql

postgres=# \password postgres;
```

### Create linux user

> Note that first it's necessary to have a linux user for a database user and second you can't be logged in as `postgres` user for this action.

```shell
$ sudo adduser john

# if you would like to set a password for the new user
$ sudo passwd john

# to start the postgres cli as user john use:
$ sudo -u john psql [-d $DATABASE_NAME]
```

## Database

To create a new database named `john`:

```shell
# assuming you are logged in as postgres
$ createdb john
```
