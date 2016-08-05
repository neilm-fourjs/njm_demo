
. ../../envas

VER=$( basename $PWD )

CUST=${1:-1}

if [ ! -e custom$CUST.json ]; then
	echo "No custom$CUST.json aborting!"
	exit 1
fi

if [ ! -e dist$CUST ]; then
	mkdir dist$CUST
fi

# If dist is not a link then remove it.
if [ ! -L dist ]; then
	rm -r dist
else
	rm f dist
fi

# If custom.json is not a link then save it
if [ ! -L custom.json ]; then
	mv custom.json custom.json.orig
else
	rm custom.json
fi

ln -s custom$CUST.json custom.json
ln -s dist$CUST dist

echo "Using Custom $CUST grunt ..."
grunt

if [ ! -z $FGLASDIR ]; then
	if [ ! -L $FGLASDIR/web/njm$CUST-js ]; then
		echo "Link created for njm$CUST-js"
		ln -s ../njm-js/$VER/dist$CUST/web $FGLASDIR/web/njm$CUST-js
	else
		echo "Link for njm$CUST-js exists."
	fi
else
	echo "NOTE: FGLASDIR is not set!"
fi

echo  "Done $CUST"
