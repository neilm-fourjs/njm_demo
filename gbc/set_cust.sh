
. ../../envas

CUSTNO=${1:-1}
CUSTNAME=${2:-njm}
VER=$( basename $PWD )

if [ ! -e custom$CUSTNO.json ]; then
	echo "No custom$CUSTNO.json aborting!"
	exit 1
fi


# If custom.json is not a link then save it
if [ ! -L custom.json ]; then
	mv custom.json custom.json.orig
else
	rm custom.json
fi

ln -s custom$CUSTNO.json custom.json

echo "Using Custom $CUSTNO grunt ..."
grunt

if [ ! -z $FGLASDIR ]; then
	if [ ! -L $FGLASDIR/web/$CUSTNAME$CUSTNO-js ]; then
		echo "Link created for $CUSTNAME$CUSTNO-js"
		ln -s $FGLASDIR/tpl/dev/current/dist/${CUSTNAME}_cust$CUSTNO $FGLASDIR/web/$CUSTNAME$CUSTNO-js
	else
		echo "Link for $CUSTNAME$CUSTNO-js exists."
	fi
else
	echo "NOTE: FGLASDIR is not set!"
fi

echo  "Built $CUSTNAME$CUSTNO-js"
