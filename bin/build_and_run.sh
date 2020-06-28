#!/usr/bin/env bash

./bin/build.sh

 if [ $? != 0 ]; then
   printf "Build failed"
   exit 1
 fi

 node_modules/.bin/http-server
