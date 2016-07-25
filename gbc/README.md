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
The header title and the logo were done using the method outlined in the GAS manual.
The header tpl.html file was expended to have a table to align the logo/title/app counter
To make the image work I added these 2 lines of javascript to the MyHeaderBarWidget.js file
```javascript
          // find the img tag with a class of .njm-logo-top
          this.img = this.getElement().querySelector(".njm-logo-top");
          // replace the source for the img with our uri path and the image name
          this.img.src = context.bootstrapInfo.gbcPath+"/img/njm_demo_logo_256.png";
```

### Footer to be on bottom page rather than bottom window ( MyFormWidget )

Here the goal was a footer that was at the bottom of the web page rather then anchored to the bottom of the browser window.
So I only wanted to see the footer when I scroll all the way down.
To make this work the footer has to be part of the 'form'. I created a MyFormWidget.tpl.html of this:
```html
<div>
  <div class="scroller">
    <div class="containerElement"></div>
        <footer>
      This is my customized GBC Demo - by neilm@4js.com
        </footer>
  </div>
</div>
```
So the Genero 'form' will replace the 'containerElement' and below that will be the 'footer'.
Next we need to create the MyFormWidget.js file to use this tpl.html file.
```javascript
modulum('MyFormWidget', ['FormWidget', 'WidgetFactory'],
  function(context, cls) {
    cls.MyFormWidget = context.oo.Class(cls.FormWidget, function($super) {
      return {
        __name: "MyFormWidget"
      };
    });
    // register the class so only forms with a style of 'gbc_footer' use this widget.
    cls.WidgetFactory.register('Form', 'gbc_footer', cls.MyFormWidget);
});
```
You can see the MyFormWidget.js doesn't actually 'do' anything - so it's inheriting all the methods
from the default 'FormWidget' and overriding nothing. The class is registered with a style though
so only a Form with a style of 'gbc_footer' will get the footer - otherwise all windows would get
the footer.
**NOTE:** There was an issue with this that required a fix to the base code - so this will fail in the current 1.00.20 GBC
but should fine in the next maintenance release.

### Change the redirect on end of application to a demos page. ( RedirectApplicationEnd )

As documented here: http://4js.com/online_documentation/fjs-gas-manual-html/#t_gwc_js_custom_redirect.html

### Created a custom toolbar to show data from two custom labels, ie welcome: user and basket values ( MyLabelWidget_stat, MyToolBarWidget )

The idea was that we have a bar at the top of the page with the current user, order totals and default buttons.
This bar should stay at the top of the screen when scrolled.
To do this we created a custom toolBar widget and a custom Label widget. The custom Label widget is used for the information text,
so when I display a value to the custom label it appears in a specific area in the toolBar.

NOTE: MORE INFO COMING.

### Changed toolbar items to be img and text on same line ( MyToolBarItemWidget )

In addition to the toolBar changes above I decided it would look better for the text to follow the image rather than be below it.
This was done in the SCSS file but I only wanted to override the look for my weboe program so I created an empty class of
MyToolBarItem that inherits the methods from the default.

### CSS based layouter - this allows the product tiles in the weboe program to be tiled according to the size of the window. ( CssLayoutEngine, CustCssBoxWidget )

I didn't do this one - it was done by Jean-Philippe from the Strasbourg GBC dev team.

