# initialize a new raspberry pi

## local configuration

```
sudo raspi-config
```

 * set new password
 * set new hostname
 * expand filesystem

## update & upgrade system

```shell
sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install -y \
    vim \
    git
```

## OPTIONAL: remove unused package
```shell
sudo apt autoremove
```

## disable ssh local environment
```shell
sudo vim /etc/ssh/ssh_config

# comment out following line
SendEnv LANG LC_*
```

## install `ffmpeg`
```shell
sudo apt-get install ffmpeg
```

## Set date

#### Set timezone

```shell
sudo dpkg-reconfigure tzdata
```

#### Set timezone manually

```shell
# list timezones
timedatectl list-timezones

# set timezone
sudo timedatectl set-timezone Europe/Berlin
```

#### Enable `timesyncd`

```shell
sudo timedatectl set-ntp on
```

