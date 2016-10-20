#!/bin/bash

# This script copies the GBC customizations into this folder structure for git.

VER=24
CUSTNAME=${1:-njm}
if [ -z $FGLASDIR ]; then
	FGLASDIR=/opt/fourjs/gas300
fi

for f in $FGLASDIR/$CUSTNAME-js/gwc-js-1.00.$VER/${CUSTNAME}_cust?
do
	echo cp -r $f ./
	cp -r $f ./
done

cp $FGLASDIR/$CUSTNAME-js/gwc-js-1.00.$VER/set_cust.sh .
cp $FGLASDIR/$CUSTNAME-js/gwc-js-1.00.$VER/custom?.json .

echo "Done."
