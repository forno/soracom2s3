#!/bin/sh
cd `dirname $0`
soracom lora-devices list | grep deviceId | sed -e 's/^[^:]*//' -e 's/^.*"\(.*\)".*$/\1/' | while read x
do
  sh save_lora.sh "$x"
done
