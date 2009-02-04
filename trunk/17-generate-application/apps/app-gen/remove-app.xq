xquery version "1.0";
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

let $app-id := string(request:get-parameter('app-id', ''))

return
   if (string-length($app-id) > 0)
then (

    (: get site-specific preferences :)
    let $site := doc('/db/xrx/apps/app-gen/site.xml')/site
    (: login :)
    
    let $site := doc('/db/xrx/apps/app-gen/site.xml')/site
    let $apps-db-path := string(request:get-parameter('apps-db-path', $site/apps-db-path/text()))
    let $app-db-path := concat($apps-db-path, '/', $app-id)
    let $login := $site/app-gen-login/text()
    let $password := $site/app-gen-login/text()
    let $login-result := xmldb:login($apps-db-path, $login, $password)

    return
      if (xmldb:collection-available($app-db-path))
       then (
          xmldb:remove($app-db-path),
          <result>
             <message>Application at {$app-db-path} has been removed.</message>
          </result>
          )
       else (
       <error>
            <message>Error: {$app-db-path} does not exist.  No action taken.</message>
       </error>
       )
       
)
else (
   <error>
      <message>Error: app-id is a required parameter.</message>
   </error>
)

