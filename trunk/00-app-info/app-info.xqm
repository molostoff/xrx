module namespace app='http://code.google.com/p/xrx/app-info';
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace xrx='http://code.google.com/p/xrx';
declare namespace text="http://exist-db.org/xquery/text";
declare namespace util="http://exist-db.org/xquery/util";

(: XRX Application Information Module
Dan McCreary
Feb 2009
   A wrapper for getting the information in an the app-info.xml file for many application.
   
This module is designed to work with XRX application naming conventions:

/db/..../apps is the home collection of all applicaitons
/db/..../apps/APP-ID is the home collection for the current application
   
When this module is run in the context of an application it will search the URI for the
apps collection and return the collection of the apps home.  Note that this is designed
to work on sites that have multiple application collections.  For example the URIs may
be specific to each hosted organization, each that have their own apps home collection.

Note on function suffix naming conventions.
If the suffix of the function is:
   url: the full URL such as http://localhost:8080/exist/rest/db/foobar
   uri: return a uri to the web root such as /exist/rest
   db: return a path starting from '/db' such as '/db/foobar'
  
Note that "apps" is the plural and is the context collection of all applications for this organization.
Note that "app" is singular and is the context of this specific application.

The prefix "get-" has been removed from all function names.  It should be assumed that
all functions get information from one or more app-info.xml files in the /apps/ collection. :)


(: returns /db/ORG where /db/ORG/apps is the home of the applications :)
declare function app:org-db() as xs:string {
   (: FIXME Get this from a site.xml file :)
   '/db/xrx'
};

(: returns /db/ORG where /db/ORG/apps is the home of the applications :)
declare function app:org-uri() as xs:string {
   (: FIXME Get this from a site.xml file :)
   '/exist/rest/db/xrx'
};


(: returns the db path to the deepest '/apps/' collection in the URI  :)
declare function app:apps-uri() as xs:string {
   concat(app:substring-before-last(request:get-uri(), '/apps/'), '/apps')
};
(: returns the uri to the deepest '/apps/' collection in the URI  :)
declare function app:apps-db() as xs:string {
   substring-after(app:apps-uri(), '/exist/rest')
};
(: returns the path after the 'apps' in the URI :)
declare function app:after-apps() as xs:string {
   app:substring-after-last(request:get-uri(), '/apps/')
};

(: returns the application collection path :)
declare function app:app-uri() as xs:string {
   concat(app:apps-uri(), '/', substring-before(app:after-apps(), '/'))
};
(: returns the Application base collection in /db format such as /db/ORG/apps :)
declare function app:app-db() as xs:string {
   substring-after(app:app-uri(), '/exist/rest')
};

(: many of the following are designed to be used within the application context :)
(: returns the Application id (the string after '/apps/' ) :)
declare function app:app-id() as xs:string {
   substring-after(app:app-uri(), '/apps/')
};

(: returns the Application data collection :)
declare function app:app-data-uri() {
   concat(app:app-uri(), '/data')
};

(: returns the Application base collection in /db format :)
declare function app:app-data-db() as xs:string {
   substring-after(app:app-data-uri(), '/exist/rest')
};

(: get the application information file for the current application :)
declare function app:app-info-db() {
   concat(app:app-db(), '/app-info.xml')
 };

(: get the application information file for the current application :)
declare function app:app-info() as node(){
   doc(app:app-info-db())/xrx:app-info
 };
 
 (: get the application information file for a given application id :)
declare function app:app-info($app-id as xs:string?) as node()? {
   doc(concat(app:apps(), '/', app-id, '/app-info.xml'))/xrx:app-info
 };
 
(: get the application information file for the named application :)
(: if the app-info.xml file does not exists in returns an empty node :)
declare function app:app-info($app-id as xs:string) as node()? {
   doc(concat(app:apps-db(), '/', $app-id, '/app-info.xml'))/xrx:app-info
 };

declare function app:app-name() as xs:string {
   string(app:app-info()/xrx:app-name/text())
};

declare function app:app-name($app-id as xs:string) as xs:string {
   string(app:app-info($app-id)/xrx:app-name/text())
};

declare function app:breadcrumb-label() as xs:string{
   string(app:app-info()/xrx:breadcrumb-label/text())
};

(: tells you if the current application is searchable :)
declare function app:include-in-search-indicator() as xs:boolean {
   if (app:app-info()/xrx:include-in-search-indicator/text() != 'false')
      then true()
      else false()
};

(: tells you if the a given application is searchable :)
declare function app:include-in-search-indicator($app-id as xs:string?) as xs:boolean {
   if (string(app:app-info($app-id)/xrx:include-in-search-indicator/text()) != 'false')
      then true()
      else false()
};

(: return a list of all searchable apps sequence of strings :)
declare function app:searchable-apps() as xs:string* {
   for $app-id in app:apps()
     return
     if (app:include-in-search-indicator($app-id))
        then (string($app-id))
        else ()
};

declare function app:doc-viewer-path() as xs:string {
   let $doc-viewer-path := string(app:app-info()/xrx:doc-viewer-path/text())
   return
   if (exists($doc-viewer-path))
      then $doc-viewer-path
      else 'views/view-item.xq?id='
};

(: Returns a listing of all applications in the lowest /apps/ collection as a
sequence of zero or more strings that have an app-info.xml file in the app collection.:)
declare function app:apps() as xs:string* {
   for $app in xmldb:get-child-collections(app:apps-db())
      return
         if (util:document-name(concat(app:app-db(), '/app-info.xml')))
           then ($app)
           else ()
};

(: the above as a single node :)
declare function app:apps-node() as node() {
<apps>{
   for $app in app:apps()
      return
      <app>{$app}</app>
}</apps>
};



(: taken from http://www.xqueryfunctions.com/xq/functx_escape-for-regex.html :)
declare function app:escape-for-regex($arg as xs:string?) as xs:string {
   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
};

(: Return the string after the last occurance of the delim.
taken from http://www.xqueryfunctions.com/xq/functx_substring-after-last.html :)
declare function app:substring-after-last($arg as xs:string?, $delim as xs:string) as xs:string {
   replace ($arg,concat('^.*', app:escape-for-regex($delim)),'')
};

(: Return the string before the last occurance of the delim.
taken from http://www.xqueryfunctions.com/xq/functx_substring-before-last.html :)
declare function app:substring-before-last($arg as xs:string?, $delim as xs:string ) as xs:string {
   if (matches($arg, app:escape-for-regex($delim)))
   then replace($arg,
            concat('^(.*)', app:escape-for-regex($delim),'.*'),
            '$1')
   else ''
 } ;

declare function app:query-base() {
   app:substring-after-last(request:get-uri(), '/')
};

declare function app:schema-collection() {
   '/db/syntactica/apps/schemas/data'
};