#!/bin/bash
# Script to attempt to setup GBC development environment

# Arg1: custom folder name, default is njm-js
# Arg2: GBC version for base - default is gwc-js-1.00.20

CUSTDIR=${1:-njm-js}
VER=${2:-1.00.21}

which git
if [ $? -ne 0 ]; then
	echo "git is not installed!"
	echo "Do this ( on centos / redhat ):"
	echo "sudo yum install -y git"
	exit 1
fi

which unzip
if [ $? -ne 0 ]; then
	echo "unzip is not installed!"
	echo "Do this ( on centos / redhat ):"
	echo "sudo yum install -y unzip"
	exit 1
fi

GASDIR=$(pwd)
DTE=$( date +'%Y%m%d%H%M%S')

if [ ! -e $CUSTDIR ]; then
	echo $( date +'%Y%m%d%H%M%S') "mkdir $CUSTDIR"
	mkdir $CUSTDIR
fi

cd $CUSTDIR

if [ ! -e gwc-js-$VER ]; then
	echo $( date +'%Y%m%d%H%M%S') " unzip $VER ..."
	unzip ../tpl/fjs-gwc-js-$VER*
	if [ $? -ne 0 ]; then
		exit 1
	fi
fi

cd gwc-js-$VER

# Assuming this is already done now.
#echo "Install 4.2.2 ..."
#nvm install 4.2.2
#if [ $? -ne 0 ]; then
#	echo "Failed !"
#	exit 1
#fi

# Assuming this is already done now.
#echo "Setting nvm to 4.2.2 ..."
#nvm use 4.2.2
#if [ $? -ne 0 ]; then
#	echo "Failed !"
#	exit 1
#fi

NODEJS_MJVER=$(node --version | cut -c2)
if [ $? -ne 0 ]; then
	echo "Failed to get node version!"
	exit 1
fi
if [ $NODEJS_MJVER -lt 4 ]; then
	echo "node js major version is too low: $NODEJS_MJVER must be => 4"
	exit 1
fi
NODEJS_MNVER=$(node --version | cut -c4)
if [ $NODEJS_MNVER -lt 2 ]; then
	echo "node js minor version is too low:  $NODEJS_MNVER must be => 2"
	exit 1
fi
echo "Node JS major versions is " $NODEJS_MJVER.$NODEJS_MNVER

if [ -e npm_install.ok ]; then
	echo $( date +'%Y%m%d%H%M%S') " npm install already done."
else
	echo $( date +'%Y%m%d%H%M%S') " npm install ..."
	npm install 2>&1 > npm_install.$DTE.out
	if [ $? -ne 0 ]; then
		cat npm_install.$DTE.out
		echo "Failed!"
		#Ignoring this because it seems to fail a lot!	
		#exit 1
	else
		touch npm_install.ok
	fi
fi

# Done with sudo before running this script now
#if [ ! -e npm_install_grunt_cli.ok ]; then
#	echo $( date +'%Y%m%d%H%M%S') " npm install -g grunt-cli ..."
#	npm install -g grunt-cli 2>&1 > npm_install_grunt_cli.$DTE.out
#	if [ $? -ne 0 ]; then
#		cat npm_install_grunt_cli.$DTE.out
#		echo "Failed!"
#		exit 1
#	else
#		touch npm_install_grunt_cli.ok
#	fi
#fi

# Done with sudo before running this script now
#if [ ! -e npm_install_bower.ok ]; then
#	echo $( date +'%Y%m%d%H%M%S') " npm install -g bower ..."
#	npm install -g bower 2>&1 > npm_install_bower.$DTE.out
#	if [ $? -ne 0 ]; then
#		cat npm_install_bower.$DTE.out
#		echo "Failed!"
#		exit 1
#	else
#		touch npm_install_bower.ok
#	fi
#fi

if [ -e grunt_deps.ok ]; then
	echo $( date +'%Y%m%d%H%M%S') " grunt deps already done."
else
	echo $( date +'%Y%m%d%H%M%S') " grunt deps ..."
	grunt deps 2>&1 > grunt_deps.$DTE.out
	if [ $? -ne 0 ]; then
		cat grunt_deps.$DTE.out
		echo "Failed!"
		exit 1
	else
		touch grunt_deps.ok
	fi
fi

echo $( date +'%Y%m%d%H%M%S') " grunt ..."
grunt 2>&1 > grunt.$DTE.out
if [ $? -ne 0 ]; then
	cat grunt.$DTE.out
	echo "Failed!"
	exit 1
fi

cd $GASDIR/web
if [ ! -e $CUSTDIR ]; then
	echo $( date +'%Y%m%d%H%M%S') " Adding symbolic link for $CUSTDIR in $GAS/web ..."
	ln -s ../$CUSTDIR/gwc-js-$VER/dist/$CUSTDIR $CUSTDIR
fi

echo $( date +'%Y%m%d%H%M%S') "Finished Okay"
