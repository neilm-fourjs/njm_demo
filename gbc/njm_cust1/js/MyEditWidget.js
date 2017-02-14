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

modulum('MyEditWidget', ['EditWidget', 'WidgetFactory'],
    /**
     * @param {gbc} context
     * @param {classes} cls
     */
    function(context, cls) {

      cls.MyEditWidget = context.oo.Class(cls.EditWidget, function($super) {
        return {
          __name: "MyEditWidget",
          __templateName: "EditWidget",

          setTitle: function(title) {
          var elt = this._element.querySelector(".gwcjs-label-text-container")
          if (title === "") {
            elt.removeAttribute("placeholder");
          } else {
            elt.setAttribute("placeholder", title);
          }
        }
      };
    });
 
    cls.WidgetFactory.register('Edit', cls.MyEditWidget);
});
