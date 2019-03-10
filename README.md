# namecheap-ddns-updater
Script to update [Namecheap](https://www.namecheap.com/) DDNS records. Includes Dockerfile.

# Build docker image

```
docker build -t namecheap-ddns-refresher .
```

# How to use

You pass the hosts as arguments and the rest of parameters via environment variables.

These are all the options with their default value (`*` means it is mandatory):

`PASSWORD` __*__: Password provided by Namecheap to use the DDNS api.

`DOMAIN` __*__: Domain that contains the records.

`FREQ=300`: Frequency of the update in seconds. 

`ONLY_ONCE=false`: If true, it will only execute once and it will exit after that.

`VERBOSE=false`: Executes curl in verbose mode, which shows A LOT of info.

`SHOW_RESPONSE=true`: Logs the response from the Namecheap API.


## Use docker image

```
docker run -ti -e PASSWORD=abcdefg1234 -e DOMAIN=mydomain.xyz josefuentes/namecheap-ddns-refresher host1 host2 host3
```

## Use script

```
PASSWORD=abcdefg1234 DOMAIN=mydomain.xyz ./update.sh host1 host2 host3
```
