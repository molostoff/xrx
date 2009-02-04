xquery version "1.0";
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(: Create the collection application collections one at a time. :)

(: This program has been replaced by a copy of the entire template :)

declare function local:sitemap($collection as xs:string) as node()* {
   if (empty(xmldb:get-child-collections($collection)))
      then ()
      else
         <ol>{
            for $child in xmldb:get-child-collections($collection)
            return
               <li>
                  <a href="{concat('/exist/rest', $collection, '/', $child)}">{$child}</a>
                  {local:sitemap(concat($collection, '/', $child))}
               </li>
        }</ol>
};

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

(: XQuery to generate an XRX appliction from and XML Schema :)

(: read in the site paramters :)
let $site := doc('/db/xrx/apps/app-gen/site.xml')/site

(: The collection that all applications will be generted into like /db/xrx/apps :)
let $apps-db-path := string(request:get-parameter('apps-db-path', $site/apps-db-path/text()))

(: login :)
let $login := $site/app-gen-login/text()
let $password := $site/app-gen-login/text()
let $login-result := xmldb:login($apps-db-path, $login, $password)

(: The id of the app which should be only lowercase and dashes :)
let $app-id := string(request:get-parameter('app-id', 'gen-test'))

let $style-module-uri := $site/style-module-uri/text()

let $template-db-path := concat($apps-db-path, '/template-01')
let $app-db-path := concat($apps-db-path, '/', $app-id)



let $app-db-path := xmldb:create-collection($apps-db-path, $app-id)

let $data-db-path := xmldb:create-collection($app-db-path, 'data')
let $views-db-path := xmldb:create-collection($app-db-path, 'views')
let $search-db-path := xmldb:create-collection($app-db-path, 'search')
let $edit-db-path := xmldb:create-collection($app-db-path, 'edit')
let $code-tables-db-path := xmldb:create-collection($app-db-path, 'code-tables')
let $images-db-path := xmldb:create-collection($app-db-path, 'images')

return
<html>
   <head>
      <title>Results of Application Generation for {$app-id}</title>
      {style:import-css()}
   </head>
   <body>
      {style:header()}
      {style:breadcrumb()}
      <h4>Input Parameters</h4>
      apps-db-path={$apps-db-path}<br/>
      app-id={$app-id}<br/>
      <h4>Output</h4>
      App DB Path = {$app-db-path}
      <h5>The following collections have been created:</h5>
      {local:sitemap($app-db-path)}
      <h5>Delete</h5>
      {$app-db-path} - <a href="remove-app.xq?app-id={$app-id}"> Remove This Application</a>
      {style:footer()}
   </body>
</html>
