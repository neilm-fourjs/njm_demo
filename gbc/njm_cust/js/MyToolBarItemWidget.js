
"use strict";

// Declare the dependency to inheritedWidget (here ToolBarItemWidget) module
modulum('MyToolBarItemWidget', ['ToolBarItemWidget', 'WidgetFactory'],
  function(context, cls) {
    cls.MyToolBarItemWidget = context.oo.Class(cls.ToolBarItemWidget, function($super) {
      return {
        __name: "MyToolBarItemWidget",
      };
    });
    cls.WidgetFactory.register('ToolBarItem','gbc_weboe', cls.MyToolBarItemWidget);
  });
