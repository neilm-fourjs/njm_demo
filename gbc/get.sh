#!/bin/bash

# This script copies the GBC customizations into this folder structure for git.

VER=20
CUSTOM=${1:-njm-js}
if [ -z $FGLASDIR ]; then
	FGLASDIR=/opt/fourjs/gas300
fi
CUSTFOLDER=njm_cust

echo "Getting customizations from $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/$CUSTFOLDER ..." 
cp $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/$CUSTFOLDER/resources/img/* $CUSTFOLDER/resources/img/
cp $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/$CUSTFOLDER/js/* $CUSTFOLDER/js/
cp $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/$CUSTFOLDER/sass/* $CUSTFOLDER/sass/
cp $FGLASDIR/$CUSTOM/gwc-js-1.00.$VER/$CUSTFOLDER/theme.scss.json $CUSTFOLDER/.

echo "Done."
