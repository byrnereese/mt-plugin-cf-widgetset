Widget Set Custom Field plugin
Author: Byrne Reese <byrne at majordojo dot com>

OVERVIEW

This plugin defines a new custom field type that allows users to select and associate with 
pages and entries a widget set installed in the current blog.

It also provides a template tag called <mt:IfWidgetSetExists> that will return true if a 
named WidgetSet exists and false otherwise.

REQUIREMENTS 

The WidgetManager plugin must be installed and enabled.

INSTALLATION

Install the WidgetSetCF.pl file into the following directory (create it if necessary):

   /path/to/your/mt/plugins/WidgetSetCF/

SUPPORT

This plugin is provided as-is. If you have a problem and would like to submit a fix,
please email the author.

TEMPLATE TAG EXAMPLE

   <MTIfNonEmpty tag="pagewidgetset">
     Sidebar: <MTpagewidgetset>
     <mt:setvarblock name="widgetset"><MTpagewidgetset></mt:setvarblock>
     <mt:ifwidgetsetexists widgetset="$widgetset">
       <mt:WidgetSet name="$widgetset">
     </mt:ifwidgetsetexists>
   </MTIfNonEmpty>
