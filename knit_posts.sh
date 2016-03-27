#!/bin/bash

set -e
set -x

SCRIPTDIR=`dirname $0`
POSTDIR="$SCRIPTDIR/_posts/"
ROPTS="--quiet --slave --no-save"

cd $POSTDIR
RMDFILES=`find . -name "*.Rmd"`
for RMDFILE in $RMDFILES
do
  RMDMOD=`stat -f%c $RMDFILE`
  PREFIX="${RMDFILE%.*}"
  MDFILE="$PREFIX.md"
  echo "knitr::knit('$RMDFILE')" | R $ROPTS
  if [[ -d "figure/" ]]
  then
    PNGFILES=`find . -name '*.png'`
    for PNGFILE in $PNGFILES
    do
      PNGMOD=`stat -f%c $PNGFILE`
      if [[ $PNGMOD > $RMDMOD ]]
      then
        mv $PNGFILE ../assets/
      fi  
    done
  fi
  sed -i "s/figure\//\{\{site\.url\}\}\/assets\//g" $MDFILE
done
