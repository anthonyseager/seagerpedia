return_code=0; cat tsconfig.json | grep "something" || return_code=$?
if [ $return_code -eq 1 ]; then
  echo "couldn't find something!"
fi
