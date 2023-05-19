### The `./up.sh` Script
*(the "make everything work" script)*

Basically a collection of our most important (but also [idempotent](https://en.wikipedia.org/wiki/Idempotence)) terminal commands to get the project working.

```sh
brew install wget xz
```

So that we have the necessary tools for the carmel build process


```sh
git submodule sync
git submodule update --init --recursive
```

So that our git submodules are all pointing to the right repos and are properly initialized/up-to-date

```sh
cd portkey/External/carmel-bin
./fetch.sh
```

This command will fetch the latest carmel binary. It belongs to the West Coast team (it is part of the `carmel-bin` repo), and only downloads a new binary if the versions do not match.

```sh
GREEN='\033[0;32m'
NC='\033[0m'
echo "\n${GREEN}WINGARDIUM LEVIOSA!${NC}"
echo 'portkey is set up\n'
```

Lets you know that things (hopefully) went well. :)
