#!/bin/bash

for file in wpeframework-*.service; do
  echo "Processing $file..."
  callsign=$(sed -n '/ExecStart=/ s/.*org\.rdk\.\(.*\)/\1/p' $file)
  sed -i "/ExecStart=.*/a ExecStop=/lib/rdk/deactivate_plugin.sh org.rdk.$callsign" $file
done
