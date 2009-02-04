xquery version "1.0";
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

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

let $template-id := $site/default-app-template/text()
let $template-db-path := concat($apps-db-path, '/', $template-id)
let $app-db-path := concat($apps-db-path, '/', $app-id)

(: Create the new collection to hold the application in the apps collection. :)
let $app-db-path := xmldb:create-collection($apps-db-path, $app-id)

let $template-source-db-path := concat($apps-db-path, '/', $template-id)

(: This copies the template into the new application collection :)

(: first copy the individual files :)
let $copy-index-result := xmldb:copy($template-db-path, $app-db-path, 'index.xq')
let $copy-app-info-result := xmldb:copy($template-db-path, $app-db-path, 'app-info.xml')

(: now the subfolders :)
let $copy-data-result := xmldb:copy(concat($template-db-path, '/data'), $app-db-path)
let $copy-code-tables-result := xmldb:copy(concat($template-db-path, '/code-tables'), $app-db-path)
let $copy-edit-result := xmldb:copy(concat($template-db-path, '/edit'), $app-db-path)
let $copy-images-result := xmldb:copy(concat($template-db-path, '/images'), $app-db-path)
let $copy-search-result := xmldb:copy(concat($template-db-path, '/search'), $app-db-path)
let $copy-views-result := xmldb:copy(concat($template-db-path, '/views'), $app-db-path)

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