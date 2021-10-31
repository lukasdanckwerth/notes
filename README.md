# install-apache2-server

### Development

##### Create multipass ubuntu instance
```shell
multipass launch -n development-server -d 7G -c 2 -m 2G
```

##### Connect to new installed instance
```shell
$ multipass shell development-server
```

##### Install apache2, php, postgresql etc.
```shell
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main/install-apache2.sh)"
```
