# install-apache2-server

### Development

##### Create ubuntu instance with [multipass](https://multipass.run)
```shell
multipass launch -n development-server -d 7G -c 2 -m 2G
```

##### Connect to new installed instance
```shell
multipass shell development-server
```

##### Install apache2, php, postgresql etc. ([`install-apache2.sh`](https://github.com/lukasdanckwerth/install-apache2-server/blob/main/install-apache2.sh))
```shell
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main/install-apache2.sh?t=$(date +%s000))"
```
