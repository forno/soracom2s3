#!/bin/sh
set -eu

if [ "$#" -ne 3 ]
then
  echo 'Usage: register_device.sh <device-id> <tag-name> <tag-value>'
  exit 1
fi

echo $1 $2 $3
soracom lora-devices put-tags --device-id=$1 --body="[{\"tagName\":\"$2\",\"tagValue\":\"$3\"}]"
