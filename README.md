# install-server

### Notes

- [git](https://github.com/lukasdanckwerth/notes/blob/main/markdown/git.md)
- [ssh](https://github.com/lukasdanckwerth/notes/blob/main/markdown/ssh.md)
- [postgresql](https://github.com/lukasdanckwerth/notes/blob/main/markdown/postgresql.md)
- [.htaccess / .htpasswd](https://github.com/lukasdanckwerth/notes/blob/main/markdown/htaccess-htpasswd.md)

## Install Scripts

##### Install apache2, php, postgresql etc. ([`install-server.sh`](https://github.com/lukasdanckwerth/notes/blob/main/scripts/install-server.sh))

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/install-server.sh)"
```

##### Install Samba

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/notes/main/scripts/install-samba.sh)"
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
