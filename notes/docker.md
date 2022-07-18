# docker

## Remove
```bash
# remove all containers
docker rm -f $(docker ps -a -q)

# remove all volumes
docker volume rm $(docker volume ls -q)
```
