GBC Customization(sic)
=====================
                                                                                                                                                              
## Files / Folders:                                                                                                                                       

* custom.json : this is the configuration file for the GBC customizations.
* gbc_custom_setup.sh : GBC dev environment setup script
* get.sh : script I'm using to copy the customizations file from the FGLASDIR folder to my git repo location.
* njm_demo.html : File I place in my <webroot>/gbc/ folder on my web service - it's the page redirected to on application close.
* packit.sh : script to pack the customization files into a tgz for easy coping to my GBC dev environment.
* njm_cust/ : Core folder for my GBC customization files
* njm_cust/js : Javascript files ( see below )
* njm_cust/locales : Copy of default - nothing here has be changed.
* njm_cust/resources/img : Customer gbc_logo and my app logo
* njm_cust/sass : SCSS files ( see below )
* theme.scss.json : My default 'red' theme.
* theme.scss.json.teal : An alernative 'Teal' theme.

## Installing for development

The way I setup my development environment for GBC is I copy the gbc_custom_setup.sh script to my $FGLASDIR folder and run it. 
It should create the njm-js folder, extract the gbc source from $FGLASDIR/tpl/<source>.zip then try and run the commands to
install and configure the default tools ( npm / bower / grunt ). It also creates the symbolic link $FGLASDIR/web to for the 
customized dist path, ie  njm-js -> ../njm-js/gwc-js-1.00.20/dist/web/
I then use the packit.sh script to pack up my files and copy the .tgz it produces to the $FGLASDIR/njm-js/gwc-js-<ver>/ 
I then just extract that tgz into that folder ( tar xvzf njm_gbc.tgz ) and type: grunt.
For example from the cloned repo folder I can do:
```
cd gbc
./packit.sh
cp gbc_custom_setup.sh $FGLASDIR/
cd $FGLASDIR
gbc_custom_setup.sh  ( this taks a while! )
cd njm-js/*/
tar xvzf <repo folder>/gbc/njm_gbc.tgz
grunt
```

## GWC-JS Customizations - CSS

### Customized the colours ( theme.scss.json & theme.scss.json.teal )

details go here

### Removed the sidebar ( theme.scss.json )

details go here

### Fixed issue with images on a button not getting correct size ( ButtonWidget.scss )

details go here

### Removed the applicationHostMenu ( ApplicationHostWidget.scss )

details go here

### Removed the next/previous images from the folder tab headings ( MyFolderWidget.scss )

details go here

### Re-styled the window title bar for modal windows and removed the icon ( MyDialogWindowHeading.scss )

details go here

### Table headers to use gbc-primary-light-color for color ( MyTableWidget.scss )

details go here

## GWC-JS Customizations - Javascript

### Header text / logo ( MyHeaderBarWidget )

details go here

### Footer to be on bottom page rather than bottom window ( MyFormWidget )

details go here

### Change the redirect on end of application to a demos page. ( RedirectApplicationEnd )

details go here

### Created a custom toolbar to show data from two custom labels, ie welcome: user and basket values ( MyLabelWidget_stat, MyToolBarWidget )

details go here

### Changed toolbar items to be img and text on same line ( MyToolBarItemWidget )

details go here

### CSS based layouter - this allows the product tiles in the weboe program to be tiled according to the size of the window. ( CssLayoutEngine, CustCssBoxWidget )

details go here

