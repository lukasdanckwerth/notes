# install-apache2-server

### Development
```bash
# create multipass ubuntu instance
$ multipass launch -n development-server -d 7G -c 2 -m 2G

# connect to new installed instance
$ multipass shell development-server

# long url
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/lukasdanckwerth/install-apache2-server/main/install-apache2.sh)"

```
