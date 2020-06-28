#!/usr/bin/env bash

mkdir -p dist

willet-compile app.wlt dist

if [ $? != 0 ]; then
  printf "Compile failed"
  exit 1
fi

browserify main.js -o dist/bundle.js
