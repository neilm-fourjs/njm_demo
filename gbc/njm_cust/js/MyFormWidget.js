"use strict";

// Declare the dependency to inheritedWidget (here FormWidget) module
modulum('MyFormWidget', ['FormWidget', 'WidgetFactory'],
  function(context, cls) {

    cls.MyFormWidget = context.oo.Class(cls.FormWidget, function($super) {
      return {
        __name: "MyFormWidget"

        /* your custom code */
      };
    });
    cls.WidgetFactory.register('Form', 'gbc_footer', cls.MyFormWidget);
});
