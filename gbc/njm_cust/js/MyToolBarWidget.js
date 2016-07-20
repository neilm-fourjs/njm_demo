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

modulum('MyToolBarWidget', ['ToolBarWidget', 'WidgetFactory'],
  /**
   * @param {gbc} context
   * @param {classes} cls
   */
  function(context, cls) {

    /**
     * My ToolBar widget.
     * @class classes.MyToolBarWidget
     * @extends classes.ToolBarWidget
     */
    cls.MyToolBarWidget = context.oo.Class(cls.ToolBarWidget, function($super) {
      /** @lends classes.ToolBarWidget.prototype */
      return {
        __name: "MyToolBarWidget",
        _scroller: null,
        _weboeStat: null,
        _weboeUser: null,
          
        _initContainerElement: function() {
          $super._initContainerElement.call(this);
          /*this._scroller = new cls.ScrollTabDecorator(this);*/
        },
          
        setWebOEUser: function(text) {
            this._weboeUser = this._element.getElementsByClassName("weboeUser")[0];
            this._weboeUser.innerHTML = text;
        },
        setWebOEStat: function(text) {
            this._weboeStat = this._element.getElementsByClassName("weboeStat")[0];
            this._weboeStat.innerHTML = text;
        }

      };
    });
    cls.WidgetFactory.register('ToolBar', 'gbc_weboe', cls.MyToolBarWidget);
  });
