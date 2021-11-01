# install-server

### Notes

- [ssh](https://github.com/lukasdanckwerth/install-apache2-server/blob/main/markdown/ssh.md)
- [postgresql](https://github.com/lukasdanckwerth/install-apache2-server/blob/main/markdown/postgresql.md)
- [.htaccess / .htpasswd](https://github.com/lukasdanckwerth/install-apache2-server/blob/main/markdown/htaccess-htpasswd.md)

### Development

##### Create ubuntu instance with [multipass](https://multipass.run)

```shell
multipass launch -n development-server -d 7G -c 2 -m 2G
```

##### Connect to new installed instance

```shell
multipass shell development-server
```

##### Install apache2, php, postgresql etc. ([`install-server.sh`](https://github.com/lukasdanckwerth/install-apache2-server/blob/main/install-server.sh))

```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main/install-server.sh?t=$(date +%s000))"
```
