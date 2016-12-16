
# Simple script, assumes you are in a subfolder under $FGLASDIR/tpl ie $FGLASDIR/tpl/dev
# you then pass the script the VER and BUILD info and it extracts the project and sets up
# the folder ready for customizations.
# ./setup_gbc.sh 1.00.28 build201612141618

if [ $# -eq 0 ]; then
	echo "Pass version to GBC to setup."
	ls -1 ../fjs-gwc*project.zip
	exit -1
fi

VER=$1
BUILD=$2

if [ ! -e ../fjs-gwcjs-${VER}-${BUILD}-project.zip ]; then
	echo "../fjs-gwcjs-${VER}-${BUILD}-project.zip Doesn't Exist!"
	exit -1
fi

unzip ../fjs-gwcjs-${VER}-${BUILD}-project.zip

if [ ! -d gwc-js-$VER ]; then
	echo "gwc-js-$VER Doesn't Exist!"
	exit -1
fi

cd gwc-js-$VER

# Setup the GBC ready for development.
npm install
npm install grunt-cli
npm install bower
grunt deps
grunt

# Setup My symbolic links for My customizations
ln -s /opt/users/neilm/all/njm_demo/gbc/custom1.json
ln -s /opt/users/neilm/all/njm_demo/gbc/custom2.json
ln -s /opt/users/neilm/all/njm_demo/gbc/custom3.json
ln -s /opt/users/neilm/all/survey/gbc_mrh/
ln -s /opt/users/neilm/all/njm_demo/gbc/njm_cust1/
ln -s /opt/users/neilm/all/njm_demo/gbc/njm_cust2
ln -s /opt/users/neilm/all/njm_demo/gbc/njm_cust3
ln -s /opt/users/neilm/all/njm_demo/gbc/set_cust.sh

