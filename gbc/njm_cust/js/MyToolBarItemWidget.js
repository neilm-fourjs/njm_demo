/// FOURJS_START_COPYRIGHT(D,2015)
/// Property of Four Js*
/// (c) Copyright Four Js 2015, 2016. All Rights Reserved.
/// * Trademark of Four Js Development Tools Europe Ltd
///   in the United States and elsewhere
/// 
/// This file can be modified by licensees according to the
/// product manual.
/// FOURJS_END_COPYRIGHT

"use strict";

modulum('MyToolBarItemWidget', ['TextWidgetBase', 'WidgetFactory'],
  /**
   * @param {gbc} context
   * @param {classes} cls
   */
  function(context, cls) {

    /**
     * ToolBarItem widget.
     * @class classes.ToolBarItemWidget
     * @extends classes.TextWidgetBase
     */
    cls.MyToolBarItemWidget = context.oo.Class(cls.TextWidgetBase, function($super) {
      /** @lends classes.ToolBarItemWidget.prototype */
      return {
        __name: "MyToolBarItemWidget",

        /** @type {Element} */
        _textElement: null,
        /** @type {classes.ImageWidget} */
        _image: null,
        /** @type {Element} */
        _imageContainer: null,
        /** @type {boolean} */
        _autoScale: false,

        _initElement: function(initialInformation) {
          $super._initElement.call(this, initialInformation);
          this._textElement = this._element.getElementsByTagName("span")[0];
          this._imageContainer = this._element.getElementsByClassName("gbc_imageContainer")[0];
          this._element.on('click.ToolBarItemWidget', this._onClick.bind(this));
        },

        destroy: function() {
          this._element.off('click.ToolBarItemWidget');
          if (this._image) {
            this._image.destroy();
            this._image = null;
          }
          $super.destroy.call(this);
        },

        _onClick: function(event) {
          context.WidgetService.cursorX = event.clientX;
          context.WidgetService.cursorY = event.clientY;

          this.emit(context.constants.widgetEvents.click);
        },
        setText: function(text) {
          this._textElement.textContent = text;
        },

        getText: function() {
          return this._textElement.textContent;
        },

        setImage: function(image) {
          if (image.length !== 0) {
            if (!this._image) {
              this._image = cls.WidgetFactory.create("Image");
              this._imageContainer.appendChild(this._image.getElement());
              this.setAutoScale(this._autoScale);
            }
            this._image.setSrc(image);
          } else if (this._image) {
            this._image.getElement().remove();
            this._image = null;
          }
        },

        getImage: function() {
          if (this._image) {
            return this._image.getSrc();
          }
          return null;
        },

        setAutoScale: function(enabled) {
          this._autoScale = enabled;
          if (this._image) {
            this._image.setAutoScale(this._autoScale);
          }
          this._imageContainer.toggleClass("gbc_autoScale", this._autoScale);
        },

        /**
         * @param {string} title the tooltip text
         */
        setTitle: function(title) {
          this._element.setAttribute("title", title);
        },

        /**
         * @returns {string} the tooltip text
         */
        getTitle: function() {
          return this._element.getAttribute("title");
        }

      };
    });
    cls.WidgetFactory.register('ToolBarItem','gbc_weboe', cls.MyToolBarItemWidget);
  });
