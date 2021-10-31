
## Users
When installing postgreSQL the user __postgres__ is already created. To login use:
```shell
sudo -i -u postgres
```

To run the postgres command line interface then use:
```shell
psql
```

To quit the postgres cli use `\q`:
```postgres
postgres=# \q
```

### Create new user
```shell
# if you are logged in as postgres it's simply
postgres@foo:~$ createuser --interactive

# or as an other user
sudo -u postgres createuser --interactive

# ... this prompts an wizard for the user creation
```