NJM Demo Application
====================

This is a self contained demo of a simple application with a login screen / menu and various programs.                                                        
It's currently compiled and tested with Genero 3.00 against Informix.                                                                                         
                                                                                                                                                              
## Structure of folders:                                                                                                                                       
* db: core source to create and populate the database - also contains an Informix dbexport and an imp.sh to load it.
* etc: genero styles / action defaults / top menus / toolbars / schema files etc
* gas300: gas .xcf files for running the main menu and the web base order entry.
* gbc: Contains the customized Genero Browser Client files.
* pics: images used by the demos
* src: Genero source code
* src/forms: Genero screen forms
* src/lib: Genero library source code
* utils: some utility scripts

## Building
The make file assume you have Genero Studio 3.00 installed and licensed.

* make - will use gsmake to build the project
* make packit - will us gsmake to build the project and produce a tgz file of the deployables.

or

* load the project in Genero Studio and choose build all.

## Running
The GAS xcf files assume you have a resource defined of res.path.isv - this should point to the base
directory. The expected path for the njm_demo application is: $(res.path.isv)/demos/njm_demo

## Using a GAR file
### Deploying Using GAR
The makefile can do this for you.
```
make deploy
```

### Undeploying Using GAR
The makefile can do this for you.
```
make undeploy
```

### Re-Deploying Using GAR
The makefile can also do a complete run of build, undeploy, deploy.
```
make redeploy
```

## Deploying Manually
So that folder is where to extract the njm_demo.tgz that the make packit will build, eg:
```bash
cd <your base directory>
mkdir -p demos/njm_demo
cd demos/njm_demo
tar xvzf <whereever>/njm_demo.tgz
```

Then either copy or symbolically link the gas300/ files to the folder you are using for your .xcf files.

## Database

### SQLite
The demo comes with an sqlite database in etc/njm_demo.db
This is used by default
NOTE: SQLite is single user only, if you to deploy this on a server for multiple people to try then use Informix

### Informix
A db export of the Informix database is provided in the db folder.
You'll need to change the etc/profile and commend out the driver line for Sqlite and uncomment the informix one. eg:
```
#dbi.default.driver = "dbmsqt3xx"
dbi.default.driver = "dbmifx9x"
```

To load the Informix database
```bash
$ cd db
$ tar xzf njm_demo.exp.tgz
$ export DBDATE=DMY4/
$ dbimport -d <whatever dbspace> njm_demo
```

## Running via the GAS
Once you have done the 'make deploy' you should be able to run the demos.

Web Ordering Program:
```
http://<your server>/gas/ua/r/gweboe    ( Custom GBC version )
http://<your server>/gas/ua/r/gweboe_def  ( Default GBC )
```

Full Application:

```
http://<your server>/gas/ua/r/gdemo     ( Custom GBC version )
http://<your server>/gas/ua/r/gdemo_def     ( Default GBC )
```

## GWC-JS Customizations

For details please see the README in the gbc folder in this repo.

### CSS
* Customized the colours ( theme.scss.json & theme.scss.json.teal )
* Removed the sidebar ( theme.scss.json )
* Fixed issue with images on a button not getting correct size ( ButtonWidget.scss )
* Removed the applicationHostMenu ( ApplicationHostWidget.scss )
* Removed the next/previous images from the folder tab headings ( MyFolderWidget.scss )
* Re-styled the window title bar for modal windows and removed the icon ( MyDialogWindowHeading.scss )
* Table headers to use gbc-primary-light-color for color ( MyTableWidget.scss )
* Toolbars and Buttomes to use gbc-primary-light-color for color ( ButtonWidget.scss / ToolBarItemWidget.scss )

### Javascript - with lots of help from GBC Dev team (Éric & Jean-Philippe)
* Header text / logo ( MyHeaderBarWidget )
* Footer to be on bottom page rather than bottom window ( MyFormWidget )
* Change the redirect on end of application to a demos page. ( RedirectApplicationEnd )
* Created a custom toolbar to show data from two custom labels, ie welcome: user and basket values ( MyLabelWidget_stat, MyToolBarWidget )
* Changed toolbar items to be img and text on same line ( MyToolBarItemWidget )

### Major feature done by GBC Dev team (Jean-Philippe)
* New CSS based layouter - this allows the product tiles in the weboe program to be tiled according to the size of the window. ( CssLayoutEngine, CustCssBoxWidget )

### What I'd like to do:
* Make page so when scroll up, the header scroll up to with the page, rather than staying fixed but have the toolbar get anchored at the top of the window, 


## Screenshots
Order Enter program in the GDC
![scr1](https://github.com/neilm-fourjs/njm_demo/raw/master/pics/screenshot_oe_gdc.jpg "Order Enter program in the GDC")

Customer Maint program in the GDC
![scr2](https://github.com/neilm-fourjs/njm_demo/raw/master/pics/screenshot_custmnt_gdc.jpg "Customer Maint program in the GDC")

Order Enter program in the GBC aka GWC-JS
![scr3](https://github.com/neilm-fourjs/njm_demo/raw/master/pics/screenshot_oe_gbc.jpg "Order Enter program in the GBC aka GWC-JS")

Customer Maint program in the GBC
![scr4](https://github.com/neilm-fourjs/njm_demo/raw/master/pics/screenshot_custmnt_gbc.jpg "Customer Maint program in the GBC aka GWC-JS")


