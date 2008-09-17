This example is a Weather Forecast Subscription Manager
Written by Dan McCreary to support Chris Wallace's Very Fine XQuery Example

http://en.wikibooks.org/wiki/XQuery/UK_shipping_forecast

Notes:

This application uses the following sub-collection convention.

data: The actual subscription data.  One file per person.  We do this so that two people do not overwrite the data fule and updates are lost.
views: Any read-only reports on the data.  A read-only file for each record is called view-record.xq
edit: The XQuery and XForms code to change the data.  People without write access should not be able to see this collection.
search: Search tools

Each record created is assigned an ID that we use to create the name of the XML file.
  The next-id is stored in the XML file next-id.xml in the edit folder.


The source of the Shipping Areas comes from here;

http://www.cems.uwe.ac.uk/xmlwiki/Met/shippingareas.xml

edit/edit.xq - the main XForms editor that takes new records and updates existing ones
edit/save-new.xq - takes submissions from edit.xq and saves the data as a new records
edit/update.xq - takes submissions from edit.xq and replaces old records with the form data
edit/new-instance.xml - the initial values for the XForms
edit/next-id.xml - stores the id number for the next new entry
edit/delete.xq - deletes records
