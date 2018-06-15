#!/bin/sh
set -eu

if [ "$#" -lt 4 ]
then
  echo 'Usage: mail_report.sh <tag-name> <tag-value> <from-address> <to-address> [more to-addresses...]'
  exit 1
fi

cd `dirname $0`
tagname=$1
tagvalue=$2
fromaddress=$3
shift 3
toaddresses=`echo "$@" | tr ' ' ','`
sendmail -i -t <<EOF
From: $fromaddress
To: $toaddresses
Subject: Soracom data report

`sh report.sh $tagname $tagvalue`

0 mean: The device has no data on one day.
1 mean: The device has data on one day.
EOF
