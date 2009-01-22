module namespace app='http://code.google.com/p/xrx/app';
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(: returns the Application base collection in /exist/rest/db format :)
declare function app:app-base-uri() as xs:string {
   let $prefix := substring-before(request:get-uri(), '/apps/')
   let $suffix := substring-after(request:get-uri(), '/apps/')
   let $base1 := substring-before($suffix, '/')
   return concat($prefix, '/apps/', $base1)
};

(: returns the Application base collection in /db format such as /db/ORG/apps :)
declare function app:app-base-db() as xs:string {
   substring-after(app:app-base-uri(), '/exist/rest')
};

(: returns /db/ORG where /db/ORG/apps is the home of the applications :)
declare function app:get-org() as xs:string {
   (: FIXME substring-before(substring-after(request:get-uri(), '/exist/rest'), '/apps/') :)
   '/db/app-info'
};

(: returns /db/ORG/apps  :)
declare function app:get-apps-collection() as xs:string {
   concat(app:get-org(), '/apps')
};

(: returns /db/ORG/apps  :)
declare function app:get-apps-uri() as xs:string {
   concat('/exist/rest', app:get-org(), '/apps')
};

(: many of the following are designed to be used within the application context :)
(: returns the Application id (the string after '/apps/' ) :)
declare function app:app-id() as xs:string {
   substring-after(app:app-base-uri(), '/apps/')
};

(: returns the Application data collection :)
declare function app:app-data-uri() {
   concat(app:app-base-uri(), '/data')
};

(: returns the Application base collection in /db format :)
declare function app:app-data-db() as xs:string {
   substring-after(app:app-data-uri(), '/exist/rest')
};

(: get the application information file for the current application :)
declare function app:app-info-path() {
   concat(app:app-base-db(), '/app-info.xml')
 };

(: get the application information file for the current application :)
declare function app:app-info() as node(){
   doc(app:app-info-path())/app:app-info
 };
 
(: get the application information file for the named application :)
(: if the app-info.xml file does not exists in returns an empty node :)
declare function app:app-info($app-id as xs:string) as node()? {
   doc(concat(app:get-org(), '/apps/', $app-id))/app:app-info
 };

declare function app:app-name() as xs:string {
   string(app:app-info()/app:app-name/text())
};

declare function app:breadcrumb-label() as xs:string{
   string(app:app-info()/app:breadcrumb-label/text())
};

(: tells you if the current application is searchable :)
declare function app:include-in-search-indicator() as xs:boolean {
   if (app:app-info()/app:include-in-search-indicator/text() != 'false')
      then true()
      else false()
};

(: tells you if a given application is searchable :)
declare function app:app-searchable-indicator($app-id as xs:string) as xs:boolean {
   let $app-info := app:app-info($app-id)
   return
   if ($app-info/app:include-in-search-indicator/text() != 'false')
      then true()
      else false()
};

declare function app:doc-viewer-path() as xs:string {
   let $doc-viewer-path := string(app:app-info()/app:doc-viewer-path/text())
   return
   if (exists($doc-viewer-path))
      then $doc-viewer-path
      else 'views/view-item.xq?id='
};

(: returns a listing of all applications in the /db/ORG/apps/ collection as a
sequence of zero or strings :)
declare function app:get-apps() as xs:string* {
   for $app in xmldb:get-child-collections(app:get-apps-collection())
      return $app
};

(: the above as a single node :)
declare function app:get-apps-node() as node() {
<apps>{
   for $app in app:get-apps()
      return <app>{$app}</app>
}</apps>
};

(: the above as a single node :)
declare function app:get-searchable-apps() as node() {
<apps>{
   for $app in xmldb:get-child-collections(app:get-apps-collection())
     return
     if (app:app-info($app)/app:include-in-search-indicator/text() != 'false')
        then ()
        else <app>{$app}</app>
}</apps>
};

(: taken from http://www.xqueryfunctions.com/xq/functx_escape-for-regex.html :)
declare function app:escape-for-regex($arg as xs:string?) as xs:string {
   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
};

(: taken from http://www.xqueryfunctions.com/xq/functx_substring-after-last.html :)
declare function app:substring-after-last($arg as xs:string?, $delim as xs:string) as xs:string {
   replace ($arg,concat('^.*', app:escape-for-regex($delim)),'')
};

declare function app:query-base() {
   app:substring-after-last(request:get-uri(), '/')
};

declare function app:schema-collection() {
   '/db/app-info/apps/schemas/data'
};