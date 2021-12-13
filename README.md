# install-server

### Notes

- [git](https://github.com/lukasdanckwerth/notes/blob/main/notes/git.md)
- [ssh](https://github.com/lukasdanckwerth/notes/blob/main/notes/ssh.md)
- [postgresql](https://github.com/lukasdanckwerth/notes/blob/main/notes/postgresql.md)
- [.htaccess / .htpasswd](https://github.com/lukasdanckwerth/notes/blob/main/notes/htaccess-htpasswd.md)

## Install [Scripts](https://github.com/lukasdanckwerth/notes/blob/main/scripts)

##### Install apache2, php, postgresql etc. ([`install-server.sh`](https://github.com/lukasdanckwerth/notes/blob/main/scripts/install-server.sh))

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/install-server.sh)"
```

##### Install Samba ([`install-samba.sh`](https://github.com/lukasdanckwerth/notes/blob/main/scripts/install-samba.sh))

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/install-samba.sh)"
```

##### Install ssmtp ([`install-ssmtp.sh`](https://github.com/lukasdanckwerth/notes/blob/main/scripts/install-ssmtp.sh))

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/install-ssmtp.sh)"
```

## Create new command

#### Create new command with ([`create-command.sh`](https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/create-command.sh)) script

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/create-command.sh)"
```

### Multipass Development

##### Create ubuntu instance with [multipass](https://multipass.run)

```shell
multipass launch -n development-server -d 7G -c 2 -m 2G
```

##### Connect to new installed instance

```shell
multipass shell development-server
```
