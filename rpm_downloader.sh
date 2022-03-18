#!/bin/bash

#If you get a "command not found" error, you can install with the following command
# sudo yum install -y yum-plugin-downloadonly
# sudo yum install yum-utils

# check args count
if [ $# -eq 0 ]; then
  echo "Usage : $0 <package name> or"
  echo "Usage : $0 -f <file_name>"
  exit
fi

if [ $# -ge 1 ]; then
  if [ $1 = '-f' ]; then
    if [ -z $2 ]; then
      echo "Usage : $0 -f <file_name>"
      exit 1
    fi
    cat $2 | while read pkg
    do
      mkdir -p ./packages/$pkg
      yum list installed |grep $pkg 2>&1 > /dev/null
      if [ $? -ne 0 ]; then
        sudo yum install -y --downloadonly --downloaddir=./packages/$pkg $pkg
      else
        sudo yumdownloader --resolve --destdir ./packages/$pkg $pkg
      fi
    done
  else
    for pkg in "$@"
    do
      mkdir -p ./packages/$pkg
      yum list installed |grep $pkg 2>&1 > /dev/null
      if [ $? -ne 0 ]; then
        sudo yum install -y --downloadonly --downloaddir=./packages/$pkg $pkg
      else
        sudo yumdownloader --resolve --destdir ./packages/$pkg $pkg
      fi
    done
  fi
fi
