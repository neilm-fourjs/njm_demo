
CUST=${1:-1}

if [ ! -e dist$CUST ]; then
	mkdir dist$CUST
fi

rm dist
rm custom.json

ln -s custom$CUST.json custom.json
ln -s dist$CUST dist

echo "Using Custom $CUST grunt ..."
grunt
echo  "Done $CUST"
