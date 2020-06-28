#!/usr/bin/env bash

mkdir -p dist

node_modules/.bin/willet-compile app.wlt dist

if [ $? != 0 ]; then
  printf "Compile failed"
  exit 1
fi

node_modules/.bin/browserify main.js -o dist/bundle.js
