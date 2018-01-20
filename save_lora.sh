#!/bin/sh
set -eu
bucket='sozolab'

if [ "$#" -ne 1 ]
then
  echo "need the device ID"
  exit 1
fi
lasttimefile=`mktemp`
set +e
aws s3 cp "s3://$bucket/soracom/$1/lasttime" "$lasttimefile"
if [ $? -ne 0 ]
then
  set -e
  date +%s > "$lasttimefile"
  aws s3 cp "$lasttimefile" "s3://$bucket/soracom/$1/lasttime"
  rm "$lasttimefile"
  exit 0
fi
set -e
lasttime=`cat "$lasttimefile"`
tmpfile=`mktemp`
nowtime=`date +%s`
soracom lora-devices get-data --device-id "$1" --coverage-type jp --from "$lasttime" --to "$nowtime" > "$tmpfile"
if [ -s "$tmpfile" ]
then
  echo "$nowtime" > "$lasttimefile"
  aws s3 cp "$tmpfile" "s3://$bucket/soracom/$1/$nowtime"
  aws s3 cp "$lasttimefile" "s3://$bucket/soracom/$1/lasttime"
fi
rm "$tmpfile"
rm "$lasttimefile"
