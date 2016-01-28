# Introduction #
Many web content management systems have "software modules" to edit specific data sets such as news items, faqs, glossary of terms, blog entries, photos and other web content.  It is our goal to build an simple application architecture to facilitate the easy creation and distribution of a large library of web content management modules that work semalessly with site-wide functions such as search.

= Architecture -
Beyond using XRX, our architecture is to use a single XML file for each application that describe how it operates with the site.  We call this file the "app-info.xml" file.  All app-info files are dynamically searched when site-wide services are used.  This file indicates if the application subscribes to a site-wide service and where to find its resources.

We attempt to follow the "convention over configuration" concepts of the Rails system.  If a configuration file is not present, a standard file structure is assumed.  Configuration files are only needed when you desire to override standard behavior.

# Goals #
The goals of the app-info module are the following.

  * Allow drag-and-drop deployment using the WebDAV interface
  * All applications are self-contained in a collection
  * As soon as applications are added the main menu of the content management system is modified
  * The **New Item** will include new application data types
  * The **Search** will include new application data
  * Linking of items will be enabled (you can link a "Requirement" item into a "Project" item


# Details #

See the following file for a description of some of the parameters of the app-info file:

http://xrx.googlecode.com/svn/trunk/00-app-info/README.xhtml