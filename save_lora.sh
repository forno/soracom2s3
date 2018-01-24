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
if ! aws s3 cp "s3://$bucket/soracom/$1/lasttime" "$lasttimefile"
then
  set -e
  date +%s%3N > "$lasttimefile"
  aws s3 cp "$lasttimefile" "s3://$bucket/soracom/$1/lasttime"
  rm "$lasttimefile"
  exit 0
fi
set -e
lasttime=`cat "$lasttimefile"`
tmpfile=`mktemp`
nowtime=`date +%s%3N`
set +e
if ! soracom lora-devices get-data --device-id "$1" --coverage-type jp --from "$lasttime" --to "$nowtime" > "$tmpfile"
then
  set -e
  rm "$lasttimefile"
  rm "$tmpfile"
  exit 0
fi
set -e
if [ -s "$tmpfile" ]
then
  echo "$nowtime" > "$lasttimefile"
  aws s3 cp "$tmpfile" "s3://$bucket/soracom/$1/$nowtime"
  aws s3 cp "$lasttimefile" "s3://$bucket/soracom/$1/lasttime"
fi
rm "$tmpfile"
rm "$lasttimefile"
