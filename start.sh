#!/bin/sh
#
# Replace the path placeholders below
# with the proper paths

sleep 20

rm <path to dbloader directory>/dataload.lock 2> /dev/null
<path to coin daemon executable>  --daemon 2> /dev/null &
