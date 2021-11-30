# Samba

### Start

```shell
sudo service smbd start
```

### Stop

```shell
sudo service smbd stop
```

### Restart

```shell
sudo service smbd restart
```

### Permanently disable

```shell
sudo update-rc.d -f smbd remove
```

### Permanently enable

```shell
sudo update-rc.d smbd defaults
```

## Users

#### Add Samba user

```shell
sudo smbpasswd -a $USER
```

#### Remove Samba user

```shell
sudo smbpasswd -x $USER
```
