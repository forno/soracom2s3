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
echo "id       : $1"
echo "lasttime : $lasttime"
echo "nowtime  : $nowtime"
set +e
if ! soracom lora-devices get-data --device-id "$1" --coverage-type jp --from "$lasttime" --to "$nowtime" --limit 200 > "$tmpfile"
then
  set -e
  echo "failed!"
  rm "$lasttimefile"
  rm "$tmpfile"
  exit 0
fi
set -e
content=`cat "$tmpfile"`
echo "content  : $content"
if [ -s "$tmpfile" -a '[]' != "$content" ]
then
  echo "$nowtime" > "$lasttimefile"
  aws s3 cp "$tmpfile" "s3://$bucket/soracom/$1/$nowtime"
  aws s3 cp "$lasttimefile" "s3://$bucket/soracom/$1/lasttime"
fi
rm "$tmpfile"
rm "$lasttimefile"
