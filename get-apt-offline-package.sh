#!/bin/bash

# check params
if [ $# -ne 1 ]; then
  echo "usage: $(basename $0) package_name"
  exit
fi

package=$1
depends=$(apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances $package | grep "^\w" | sort -u)

if [ -z "$depends" ];then
  echo -e "invalid package name"
  exit
fi
echo -e " package [ $package ] all depends on: \n$depends\n"

# prepare dir
mkdir -p /tmp/$package-offline-packages/archives
sudo chmod 777 /tmp/$package-offline-packages/archives
# download
cd /tmp/$package-offline-packages/archives
sudo apt-get download $depends
# pack
cd /tmp
zip -rq /tmp/$package-offline-packages.zip ./$package-offline-packages
# clear
rm -rf /tmp/$package-offline-packages

echo -e "\ndone , package [ $package ] is placed in : \n/tmp/$package-offline-packages.zip"
