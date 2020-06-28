npm install

if [ $? != 0 ]; then
  printf "NPM install failed"
  exit 1
fi
