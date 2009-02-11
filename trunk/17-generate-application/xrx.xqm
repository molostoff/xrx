module namespace xrx='http://code.google.com/p/xrx';
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(: returns the Application base collection in /exist/rest/db format :)
declare function xrx:app-base-uri() as xs:string {
   let $prefix := substring-before(request:get-uri(), '/apps/')
   let $suffix := substring-after(request:get-uri(), '/apps/')
   let $base1 := substring-before($suffix, '/')
   return concat($prefix, '/apps/', $base1)
};

(: returns the Application base collection in /db format such as /db/ORG/apps :)
declare function xrx:app-base-db() as xs:string {
   substring-after(xrx:app-base-uri(), '/exist/rest')
};

(: returns /db/ORG where /db/ORG/apps is the home of the applications :)
declare function xrx:get-org() as xs:string {
   (: FIXME substring-before(substring-after(request:get-uri(), '/exist/rest'), '/apps/') :)
   '/db/xrx'
};

(: returns /db/ORG/apps  :)
declare function xrx:get-apps-collection() as xs:string {
   concat(xrx:get-org(), '/apps')
};

(: returns /db/ORG/apps  :)
declare function xrx:get-apps-uri() as xs:string {
   concat('/exist/rest', xrx:get-org(), '/apps')
};

(: many of the following are designed to be used within the application context :)
(: returns the Application id (the string after '/apps/' ) :)
declare function xrx:app-id() as xs:string {
   substring-after(xrx:app-base-uri(), '/apps/')
};

(: returns the Application data collection :)
declare function xrx:app-data-uri() {
   concat(xrx:app-base-uri(), '/data')
};

(: returns the Application base collection in /db format :)
declare function xrx:app-data-db() as xs:string {
   substring-after(xrx:app-data-uri(), '/exist/rest')
};

(: get the application information file for the current application :)
declare function xrx:app-info-path() {
   concat(xrx:app-base-db(), '/app-info.xml')
 };

(: get the application information file for the current application :)
declare function xrx:app-info() as node(){
   doc(xrx:app-info-path())/xrx:app-info
 };
 
(: get the application information file for the named application :)
(: if the app-info.xml file does not exists in returns an empty node :)
declare function xrx:app-info($app-id as xs:string) as node()? {
   doc(concat(xrx:get-org(), '/apps/', $app-id))/xrx:app-info
 };

declare function xrx:app-name() as xs:string {
   string(xrx:app-info()/xrx:app-name/text())
};

declare function xrx:breadcrumb-label() as xs:string{
   string(xrx:app-info()/xrx:breadcrumb-label/text())
};

(: tells you if the current application is searchable :)
declare function xrx:include-in-search-indicator() as xs:boolean {
   if (xrx:app-info()/xrx:include-in-search-indicator/text() != 'false')
      then true()
      else false()
};

(: tells you if a given application is searchable :)
declare function xrx:app-searchable-indicator($app-id as xs:string) as xs:boolean {
   let $app-info := xrx:app-info($app-id)
   return
   if ($app-info/xrx:include-in-search-indicator/text() != 'false')
      then true()
      else false()
};

declare function xrx:doc-viewer-path() as xs:string {
   let $doc-viewer-path := string(xrx:app-info()/xrx:doc-viewer-path/text())
   return
   if (exists($doc-viewer-path))
      then $doc-viewer-path
      else 'views/view-item.xq?id='
};

(: returns a listing of all applications in the /db/ORG/apps/ collection as a
sequence of zero or strings :)
declare function xrx:get-apps() as xs:string* {
   for $app in xmldb:get-child-collections(xrx:get-apps-collection())
      return $app
};

(: the above as a single node :)
declare function xrx:get-apps-node() as node() {
<apps>{
   for $app in xrx:get-apps()
      return <app>{$app}</app>
}</apps>
};

(: the above as a single node :)
declare function xrx:get-searchable-apps() as node() {
<apps>{
   for $app in xmldb:get-child-collections(xrx:get-apps-collection())
     return
     if (xrx:app-info($app)/xrx:include-in-search-indicator/text() != 'false')
        then ()
        else <app>{$app}</app>
}</apps>
};

(: taken from http://www.xqueryfunctions.com/xq/functx_escape-for-regex.html :)
declare function xrx:escape-for-regex($arg as xs:string?) as xs:string {
   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
};

(: taken from http://www.xqueryfunctions.com/xq/functx_substring-after-last.html :)
declare function xrx:substring-after-last($arg as xs:string?, $delim as xs:string) as xs:string {
   replace ($arg,concat('^.*', xrx:escape-for-regex($delim)),'')
};

declare function xrx:query-base() {
   xrx:substring-after-last(request:get-uri(), '/')
};

declare function xrx:schema-collection() {
   '/db/xrx/apps/schemas/data'
};