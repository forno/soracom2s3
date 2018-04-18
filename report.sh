#!/bin/sh
set -eu

if [ "$#" -ne 2 ]
then
  echo 'Usage: report.sh <tag-name> <tag-value>'
  exit 1
fi

soracom lora-devices list --tag-name=$1 --tag-value=$2 | grep deviceId | sed -e 's/^[^:]*//' -e 's/^.*"\(.*\)".*$/\1/' | while read x
do
  lasttime=`date +%s%3N -d yesterday`
  nowtime=`date +%s%3N`
  data=`soracom lora-devices get-data --device-id="$x" --coverage-type=jp --from="$lasttime" --to="$nowtime" --limit=1`
  if [ "$data" = '[]' ]
  then
    echo $x,0
  else
    echo $x,1
  fi
done
