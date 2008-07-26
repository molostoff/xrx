This example demonstrates the Create/Read/Update/Delete (CRUD) cycle for an XRX application.

This is a minimal example designed to show the overall structure of the application.
It is designed to be uncluttered to show the essential features of the CRUD cycle.
This does not have all the niceties of a full application.

Here are the relevant files and folders.

index.xhtml - the hope page for the dictionary application

data/1.xml - first record
data/2.xml - second record

edit/edit.xq - the main XForms editor that calls  both the new and update
edit/new-instance.xml = the initial values for the XForms
edit/next-id.xml

views/list-terms.xq - lists all the terms in the dictionary
