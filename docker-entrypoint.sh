#!/bin/sh

CONFIG_FILE=$1
# index.html includes config file, where app can reference these with window.env.VARNAME
rm -f $CONFIG_FILE
echo "Writing app environment variables to config file: $CONFIG_FILE"
echo "window.env = {} " > $CONFIG_FILE
printenv | grep "^REACT_APP_.*=.*" | sed "s/\(^REACT_APP_.*\)=\(.*$\)/window.env.\1=\"\2\"/g" >> $CONFIG_FILE
chmod 555 $CONFIG_FILE

echo "starting nginx"
nginx -g "daemon off;" &

wait $!