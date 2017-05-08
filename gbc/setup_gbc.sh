
# Simple script, assumes you are in a subfolder under $FGLASDIR/tpl ie $FGLASDIR/tpl/dev
# you then pass the script the VER and BUILD info and it extracts the project and sets up
# the folder ready for customizations.
# ./setup_gbc.sh 1.00.28 build201612141618

if [ $# -eq 0 ]; then
	echo "Pass version to GBC to setup."
	echo "eg: $0 1.00.30 build201702091156"
	ls -1 ../fjs-g*project.zip
	exit -1
fi

VER=$1
BUILD=$2
PRD=gbc

if [ ! -e ../fjs-${PRD}-${VER}-${BUILD}-project.zip ]; then
	echo "../fjs-${PRD}-${VER}-${BUILD}-project.zip Doesn't Exist!"
	exit -1
fi

unzip ../fjs-${PRD}-${VER}-${BUILD}-project.zip

if [ ! -d ${PRD}-$VER ]; then
	echo "${PRD}-$VER Doesn't Exist!"
	exit -1
fi

cd ${PRD}-$VER

# Setup the GBC ready for development.
npm install
npm install grunt-cli
npm install bower
grunt deps
grunt

# Setup My symbolic links for My customizations
cd customization
MYGPAAS=/opt/users/neilm/all/gCloud_dev/GC-243-Genero-3.00-support
MYGIT=/opt/users/neilm/all/my_github
ln -s $MYGIT/survey/gbc_mrh/
ln -s $MYGIT/njm_demo/gbc/njm_cust1/
ln -s $MYGIT/njm_demo/gbc/njm_cust2/
ln -s $MYGIT/njm_demo/gbc/njm_cust3/
ln -s $MYGPAAS/node/infrastructure/gpaas_core_genero_programs/gbc/gbc-gc
cd ..

# Build all customizations
grunt --customization=ALL
