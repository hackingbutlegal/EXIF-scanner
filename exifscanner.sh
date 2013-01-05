#!/bin/bash
# exifscanner.sh
# Jackie Singh, 2012
#

echo
echo "-----------------------------------------"
echo "EXIFscanner v1.0"
echo "Script to crawl through web pages or directories using wget and exiftool and search for hidden GPS data."
echo "-----------------------------------------"
echo

mkdir /tmp/exifscanner; 

wget -r --no-parent --directory-prefix=/tmp/exifscanner -A.jpg -A.jpeg -A.tif -A.tiff -U '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.6) Gecko/20050405 Firefox/1.0 (Ubuntu package 1.0.2)\"' --wait=2 --random-wait -nd -nv $1;

IMAGES=/tmp/exifscanner/*
echo
for i in $IMAGES
do
  exiftool -a -gps:all -u -g1 -w .log $i;
done

LOGS=/tmp/exifscanner/*.log
echo
for l in $LOGS
do
  cat $l | grep GPS;
  export OUT=$?
  if [ $OUT -eq 0 ]; then
    echo; echo "[WOOT] Found some GPS coordinates. Logging to corresponding .log file"
      else
      rm $l; rm $i
  fi
done

echo
echo "-----------------------------------------"
echo "All done. Here are the files you need to review:"
echo "-----------------------------------------"

ls -al /tmp/exifscanner/*.log

echo
