#!/bin/bash

MODE=matrix
TIME=5
DPMS=5

TEXT="title=\"Warning:\", text=\"Screen locks in 10 seconds\", timeout=4"
LOCK="xlock -lockdelay 5 -delay 40000 -mode $MODE -dpmsoff $(($DPMS*60))"
WARN="echo 'require(\"naughty\").notify({ $TEXT })' | awesome-client"

xautolock -time $TIME -notify 10 -locker "$LOCK" -notifier "$WARN"
