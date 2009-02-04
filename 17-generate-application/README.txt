Place these files in the /db/xrx collection.

The structure should be:

/db/xrx/apps
/db/xrx/apps/app-gen
/db/xrx/apps/template-01

There is a file called site.xml that I have stated to put site-wide parameters in.

There is a file called app-info.xml that will have all the application-specific items that we derive from the XML Schema.  This is still static.

Inside the app-gen application you will find a script called

generate-application.xq.

This by default will create an application called "gen-test".

There is also a cleanup script that allows you to delete what you just created:

remove-app.xq

Just be careful with this one because it deletes an entire collection.

The next step is to parametrize each of the XQuery files in the template to read path expressions from the app-info.xml file.

- Dan