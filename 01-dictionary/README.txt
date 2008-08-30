This example demonstrates the Create/Read/Update/Delete (CRUD) cycle for an XRX application.

This is a minimal example designed to show the overall structure of the application.
It is designed to be uncluttered to show the essential features of the CRUD cycle.
This does not have all the niceties of a full application.

Here are the relevant files and folders.

index.xhtml - the hope page for the dictionary application

data/1.xml - first record
data/2.xml - second record

edit/edit.xq - the main XForms editor that takes new records and updates existing ones
edit/save-new.xq - takes submissions from edit.xq and saves them as new records
edit/update.xq - takes submissions from edit.xq and replaces old records with the form data
edit/new-instance.xml - the initial values for the XForms
edit/next-id.xml - stores the id number for the next new entry
edit/delete.xq - deletes records

views/list-terms.xq - lists all the terms in the dictionary
views/view-term.xq - displays a single term