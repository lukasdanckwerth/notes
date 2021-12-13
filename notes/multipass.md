# Multipass Development

##### Create ubuntu instance with [multipass](https://multipass.run)

```shell
multipass launch -n development-server -d 7G -c 2 -m 2G
```

##### Connect to new installed instance

```shell
multipass shell development-server
```
