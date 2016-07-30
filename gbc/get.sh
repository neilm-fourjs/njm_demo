#!/bin/bash

# This script copies the GBC customizations into this folder structure for git.

VER=20
CUSTOM=${1:-njm-js}
if [ -z $FGLASDIR ]; then
	FGLASDIR=/opt/fourjs/gas300
fi

cp -r $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/njm_cust1 ./
cp -r $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/njm_cust2 ./
cp -r $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/njm_cust3 ./

cp $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/set_cust.sh .
cp $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/custom?.json .

echo "Done."
