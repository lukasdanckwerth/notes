# ssh

### Create key pair
```shell
# use rsa
$ ssh-keygen -t rsa -b 4096

# use ecdsa (Digital Signature Algorithm)
$ ssh-keygen -t ecdsa -b 521

# use ed25519 (OpenSSH)
$ ssh-keygen -t ed25519
```

### Copying public key to a server
```shell
$ ssh-copy-id -i ~/.ssh/ed25519 $USER@$HOST
```