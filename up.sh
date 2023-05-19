#!/bin/sh

# make sure wget and xz are installed locally
brew install wget xz

# DEVOPS-958: force each submodule to use git-cache as the remote
# to avoid any network operations (then switch back to real remotes
# below with the 'git submodule sync')
if [ "x$USER" == "xjenkins" ]; then
  for i in `grep path .gitmodules | sed 's/.*= //'`
  do
    git config -f .git/config submodule.$i.url $HOME/git-cache
  done
  time git submodule update
  if [ $? -ne 0 ]; then
    echo "Error updating submodules. Is the git-cache up-to-date?"
    exit 1
  fi
fi

# update git submodules
git submodule sync
git submodule update --init --recursive

# navigate down into the carmel-bin submodule
cd portkey/External/carmel-bin

# setup carmel-bin
./fetch.sh

# navigate back up
cd ../../../

# print completion text to console
GREEN='\033[0;32m'
NC='\033[0m'
echo "\n${GREEN}WINGARDIUM LEVIOSA!${NC}"
echo 'portkey is set up\n'
