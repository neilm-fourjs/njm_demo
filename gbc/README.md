GBC Customization(sic)
=====================

Sections in this README


1. Files / Folders
2. Setting up GWC-JS dev prerequisites
	* CentOS
	* Debian
3. Installing Demo for development
4. GWC-JS Customizations - Javascript
  * Header text / logo
  * Footer to be at bottom of page rather than bottom of window
  * Change the redirect on end of application to a demos page.
  * Created a custom toolbar to show data from two custom labels
  * Changed toolbar items to be img and text on same line
  * CSS based layouter - tiled groups in a [VH]Box
5. GWC-JS Customizations - CSS
  * Customized the colours
  * Removed the sidebar
  * Fixed issue with images on a button not getting correct size
  * Removed the applicationHostMenu
  * Removed the next/previous images from the folder tab headings
  * Re-styled the window title bar for modal windows and removed the icon
  * Table headers colour change
  * Default toolbar colours


--------------------------------------------------------------------------------
## 1. Files / Folders:                                                                                                                                       

* custom.json : this is the configuration file for the GBC customizations.
* gbc_custom_setup.sh : Utility script to setup the GBC dev environment
* get.sh : script I'm using to copy the customization files from the FGLASDIR folder to my git repo location.
* njm_demo.html : File I place in my <webroot>/gbc/ folder on my web server - custom page redirected to on app close.
* packit.sh : script to pack the customization files into a tgz for easy coping to my GBC dev environment.
* njm_cust/ : Core folder for my GBC customization files
* njm_cust/js : Javascript files ( see below )
* njm_cust/locales : Copy of default - nothing here has be changed.
* njm_cust/resources/img : Customer gbc_logo and my app logo
* njm_cust/sass : SCSS files ( see below )
* theme.scss.json : My default 'Red' theme.
* theme.scss.json.teal : An alernative 'Teal' theme.


--------------------------------------------------------------------------------
## 2. Setting up GWC-JS dev prerequisites

Setting the development environment can be tricky because the default versions for
for most of the tools are too old on most LTS ( Long term support ) type distributions.

### CentOS 7 ( and probably 6 )

```bash
sudo curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
sudo yum install -y unzip git nodejs
sudo npm install -g grunt-cli
sudo npm install -g bower
```

### Debian

```bash
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y unzip git nodejs
sudo npm install -g grunt-cli
sudo npm install -g bower
```


--------------------------------------------------------------------------------
## 3. Installing the Demo for development

The way I setup the development environment for GBC is to copy the gbc_custom_setup.sh script to $FGLASDIR folder and run it. 
It should create the njm-js folder, extract the gbc source from $FGLASDIR/tpl/<source>.zip then try and run the commands to
install and configure the default tools ( nodejs ). It also creates the symbolic link $FGLASDIR/web to for the customized dist 
path, ie  njm-js -> ../njm-js/gwc-js-1.00.20/dist/web/
You can then use the packit.sh script to pack up the custom gbc files ready for extracting into the new custom folder. 
For example from the cloned repo folder you should be able to do this:
```bash
cd gbc
./packit.sh
cp gbc_custom_setup.sh $FGLASDIR/
cd $FGLASDIR
./gbc_custom_setup.sh  ( this takes a while! )
cd njm-js/*/
tar xvzf <repo folder>/gbc/njm_gbc.tgz
grunt
```

You should then be able to run the application using the njm-js custom GBC.


--------------------------------------------------------------------------------
## 4. GWC-JS Customizations - Javascript

### Header text / logo ( MyHeaderBarWidget )
The header title and the logo were done using the method outlined in the GAS manual.
The header MyHeaderBarWidget.tpl.html file was expended to have a table to align the logo/title/app counter


To make the image work I added these 2 lines of javascript to the MyHeaderBarWidget.js file
```javascript
          // find the img tag with a class of .njm-logo-top
          this.img = this.getElement().querySelector(".njm-logo-top");
          // replace the source for the img with our uri path and the image name
          this.img.src = context.bootstrapInfo.gbcPath+"/img/njm_demo_logo_256.png";
```

The image is in resources/img folder in the njm_cust folder and gets moved to the dist folder structure by grunt.

### Footer to be at bottom of page rather than bottom of window ( MyFormWidget )

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

The MyToolBarWidget.tpl.html is a copy of the default but with two additional 'span' elements, *mt-weboeUser* and *mt-weboeStat*
which will contain the content of the custom labels in the Genero form.
```html
  <div class="mt-tab-titles-bar">
    <div class="mt-tab-previous" style="display:none"><i class="zmdi zmdi-chevron-left"></i></div>
    <div class="mt-tab-titles">
        <span class="mt-weboeUser"></span>
        <span class="mt-weboeStat"></span>
        <div class="mt-tab-titles-container containerElement"></div>
      </div>
    <div class="mt-tab-next" style="display:none"><i class="zmdi zmdi-chevron-right"></i></div>
  </div>
```

The MyToolBarWidget.js is inheriting all the methods of the default ToolBarWidget and adding 2 new custom methods, 
one to set the *mt-weboeUser* 'span' element and the other to set the *mt-weboeStat* element.

```javascript
  // this function sets the weboeUser to the passed text value - called from custom label widget.
  setWebOEUser: function(text) {
    this._weboeUser = this._element.getElementsByClassName("mt-weboeUser")[0];
    this._weboeUser.innerHTML = text;
  },
  // this function sets the weboeStat to the passed text value - called from custom label widget.
  setWebOEStat: function(text) {
    this._weboeStat = this._element.getElementsByClassName("mt-weboeStat")[0];
    this._weboeStat.innerHTML = text;
  }
```
The custom toolbar is only used if the Genero toolbar has a style of 'gbc_weboe'.


The MyLabelWidget_stat.js is handling the label on the form, it's specifically not using a custom .tpl.html, this done
by using the'__templateName' entry to point to a default template. In the scss file I use a style of 'display: none;' so the label is not actually displayed in page.

```javascript
    cls.MyLabelWidget_stat = context.oo.Class(cls.LabelWidget, function($super) {
      /** @lends classes.MyLabelWidget_stat.prototype */
      return {
        __name: "MyLabelWidget_stat",
        // using default LabelWidget template!
        __templateName: "LabelWidget",
```


The MyLabelWidget_stat.js is inheriting the methods from the default LabelWidget but overriding the 'setValue' method.
The setValue function is finding the toobarnode in the AUI and getting the helper anchor node for the specific Label,
then getting the 'tag' attribute from the AUI for that label and using that to decide which MyToolBarWidget method to call.

```javascript
setValue: function(value) {
  // Call the parent class setValue function.
  $super.setValue.call(this,value);

  // Get the modelHelper.
  var modelhelper=new cls.ModelHelper( this );
  // Use the modelHelper to get the ToolBar node by first getting the Window Anchor node, then the form, then the toolbar
  var toolbarnode = modelhelper.getAnchorNode().getAncestor("Window").getFirstChild("Form").getFirstChild("ToolBar");

  // Get the tag attribute of the AUI object for this Label;
  var tag = modelhelper.getAnchorNode().getFirstChild("Label").attribute("tag");
  if ( tag == "user") {
    // now we get the controller for the toolbar node, then it's widget, then we can call our custom function.
    toolbarnode.getController().getWidget().setWebOEUser( value );
  };
  if ( tag == "status") {
    // now we get the controller for the toolbar node, then it's widget, then we can call our custom function.
    toolbarnode.getController().getWidget().setWebOEStat( value );
  };
}
```

### Changed toolbar items to be img and text on same line ( MyToolBarItemWidget )

In addition to the toolBar changes above I decided it would look better for the text to follow the image rather than be below it.
This was done in the SCSS file but I only wanted to override the look for my weboe program so I created an empty class of
MyToolBarItem that inherits the methods from the default and uses the default .tpl.html file.

### CSS based layouter - this allows the product tiles in the weboe program to be tiled according to the size of the window. ( CssLayoutEngine, CustCssBoxWidget )

I didn't do this one - it was done by Jean-Philippe from the Strasbourg GBC dev team.


--------------------------------------------------------------------------------
## 5. GWC-JS Customizations - CSS

### Customized the colours ( theme.scss.json & theme.scss.json.teal )

See: http://4js.com/online_documentation/fjs-gas-manual-html/#c_gwc_js_customize_theme_settings.html

### Removed the sidebar ( theme.scss.json )

See: http://4js.com/online_documentation/fjs-gas-manual-html/#t_gwc_js_custom_sidebar.html

### Fixed issue with images on a button not getting correct size ( ButtonWidget.scss )

The image on buttons doesn't honour the scaleIcon attribute for specific sizes, ie yes/no work and 24px doesn't.
Also the text colour was a pale pink with my theme so I changed it to use gbc-primary-light-color
```css
.gbc_ImageWidget.gbc_fixedSvg > svg {
  min-width: 24px;
  min-height: 24px;
}

[__ButtonWidget].mt-button {
  color: $gbc-primary-light-color;
  >.gbc_imageContainer {
    padding:  $gbc-margin-ratio*2px;
    > .gbc_ImageWidget {
      fill: $text-light-87;
      min-width: 24px;
      min-height: 24px;
      max-width: 64px;
      max-height: 64px;
      overflow: hidden;
    }
  }
}
```

### Removed the applicationHostMenu ( ApplicationHostWidget.scss )

This I simply wanted to turn off completely, so I created this style file containing:
```css
.gbc_ApplicationHostWidget {
  header.mt-toolbar {
      display: none;
  }
}
```

### Removed the next/previous images from the folder tab headings ( MyFolderWidget.scss )

My folders only have a couple of pages so the next/previous images are not required and don't look very nice.
```css
.mt-tab-next, .mt-tab-previous {
  display: none;
}
```

### Re-styled the window title bar for modal windows and removed the icon ( MyDialogWindowHeading.scss )

The icon used on modal windows is not scaled ( in the 1.00.20 ) so my icon appears far to big. I decided
actually no icon was needed so removed the icon. The actually window title was too subtle and didn't really
stand out as a title and was not using the matrial colours, so I restyled it.
```css
.gbc_ModalWindowDialog  .mt-dialog-header {
  color: $gbc-primary-light-color;
  background-color: $gbc-header-color;
  .gbc_ImageWidget {
    display: none;
  }
}
```

### Table headers to use gbc-primary-light-color for color ( MyTableWidget.scss )

The default table headers text were a bit 'pink' in my theme, so I changed them to use the matrial colour.
```css
.gbc_TableWidget .gbc_TableColumnHeader {
  color: $gbc-primary-light-color;
}
```

### Default toolbar colours ( ToolBarItemWidget.scss )

The text and icons colour were a little too pink with my theme so I changed them to use gbc-primary-light-color

```css
$gbc-ToolBar-hover-color: $gbc-primary-light-color;

.gbc_ToolBarItemWidget {
  &.mt-item {
    background-color: $gbc-primary-color;
    color: $gbc-primary-light-color;

    &:not(.disabled) {
      &:hover {
        background-color: $gbc-primary-medium-color;
        color: $gbc-primary-color;
      }
    }
  }

  .gbc_autoScale {
    svg {
      flex: 1 1 auto;
      fill: $gbc-primary-light-color;
    }
  }
}
```
