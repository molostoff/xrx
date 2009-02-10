xquery version "1.0";
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
import module namespace app='http://code.google.com/p/xrx/app-info' at '/db/xrx/modules/app-info.xqm';
declare namespace xrx='http://code.google.com/p/xrx';

<results>
   <title>Test Driver for all the functions in the XRX app-info module</title>
   <get-url>{request:get-url()}</get-url>
   <get-uri>{request:get-uri()}</get-uri>
   <apps-uri>{app:apps-uri()}</apps-uri>
   <apps-db>{app:apps-db()}</apps-db>
   <app-uri>{app:app-uri()}</app-uri>
   <after-apps>{app:after-apps()}</after-apps>
   <after-apps-appid>{substring-before(app:after-apps(), '/')}</after-apps-appid>
   <app-db>{app:app-db()}</app-db>
   <app-data-db>{app:app-data-db()}</app-data-db>
   <app-id>{app:app-id()}</app-id>
   <app-info-db>{app:app-info-db()}</app-info-db>
   <app-name>{app:app-name()}</app-name>
   <breadcrumb-label>{app:breadcrumb-label()}</breadcrumb-label>
   
   <include-in-search-indicator>{app:include-in-search-indicator()}</include-in-search-indicator>
   <doc-viewer-path>{app:doc-viewer-path()}</doc-viewer-path>
   <apps>({string-join(app:apps(), ', ')})</apps>
   <!-- <apps-node>{app:apps-node()}</apps-node> -->
   <!-- listing of all searchable applications -->
   <!-- {  -->
   <searchable-apps>({string-join(app:searchable-apps(), ', ')})</searchable-apps>
   <debug>{
   for $app-id in app:apps()
     return
       <app>
       <app-id>{$app-id}</app-id>
       <app-name>{app:app-name($app-id)}</app-name>
       <searchable>{app:include-in-search-indicator($app-id)}</searchable>
       </app>
   }</debug>
</results>
