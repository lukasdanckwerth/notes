# .htaccess and .htpasswd

## .htpasswd

### Add user

```bash
# To add or update a users password use:
$ htpasswd .htpasswd john

# To create or add to a `.htpasswd` file use the `-c` argument:
$ htpasswd -B -c .htpasswd john

# use -B to force bcrypt encryption of the password (very secure).
$ htpasswd -B .htpasswd john
```

### Set permissions

```bash
$ chmod 644 .htpasswd
```

#### Code examples to add to the .htaccess file

> Note that the specifyed path to the `.htpasswd` must be absolute.

##### Protect an entire directory

```bash
AuthName "Dialog prompt"
AuthType Basic
AuthUserFile /absolute/path/to/your/.htpasswd
Require valid-user
```

##### Protect a single file

```bash
<Files SecretFile.php>
    AuthName "Dialog prompt"
    AuthType Basic
    AuthUserFile /absolute/path/to/your/.htpasswd
    Require valid-user
</Files>
```

##### Protect multiple files

```bash
<FilesMatch "^(SecretFile|OtherFile).php$">
    AuthName "Dialog prompt"
    AuthType Basic
    AuthUserFile /absolute/path/to/your/.htpasswd
    Require valid-user
</FilesMatch>
```
