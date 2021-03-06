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

modulum('MySessionEndWidget', ['WidgetBase', 'WidgetFactory'],
  /**
   * @param {gbc} context
   * @param {classes} cls
   */
  function(context, cls) {

    /**
     * @class classes.MySessionEndWidget
     * @extends classes.WidgetBase
     */
    cls.MySessionEndWidget = context.oo.Class(cls.SessionEndWidget, function($super) {
      /** @lends classes.MySessionEndWidget.prototype */
      return {
        __name: "MySessionEndWidget",

        setHeader: function(message) {
          this._element.getElementsByClassName("myHeaderText")[0].innerHTML = message;
        },

        setSessionLinks: function(base, session) {
          $super.setSessionLinks.call(this, base, session);

          // update redirection link url of the template
          var redirectionLink = this._element.getElementsByClassName("redirectionLink")[0];
          redirectionLink.title = i18n.t("mycusto.session.redirectionText");
          var url = "http://www.4js.com";
          redirectionLink.href = url;

          // launch the redirection after a delay of 10 seconds
          // to remove the delay, remove the setTimeout
          //setTimeout(function () {
          //  window.location = url;
          //}, 10000); // 10000ms
        }
      };
    });

     cls.WidgetFactory.register('SessionEnd', cls.MySessionEndWidget);
  });
