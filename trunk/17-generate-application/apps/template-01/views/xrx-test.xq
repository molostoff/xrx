import module namespace xrx ='http://code.google.com/p/xrx' at '/db/xrx/modules/xrx.xqm';
<results>
   <get-url>{request:get-url()}</get-url>
   <get-uri>{request:get-uri()}</get-uri>
   <app-base-uri>{xrx:app-base-uri()}</app-base-uri>
   <app-base-db>{xrx:app-base-db()}</app-base-db>
   <app-data-uri>{xrx:app-data-uri()}</app-data-uri>
   <app-data-db>{xrx:app-data-db()}</app-data-db>
   <app-id>{xrx:app-id()}</app-id>
   <app-info-path>{xrx:app-info-path()}</app-info-path>
   
   <!-- full dumps of the app-info.xml files.
   <app-info-inline>{doc('/db/crossflo/apps/template/app-info.xml')/xrx:app-info}</app-info-inline>
   <app-info>{xrx:app-info()}</app-info>
   -->
   <app-name>{xrx:app-name()}</app-name>
   <breadcrumb-label>{xrx:breadcrumb-label()}</breadcrumb-label>
   <xrx:include-in-search-indicator>{xrx:include-in-search-indicator()}</xrx:include-in-search-indicator>
   <xrx:doc-viewer-path>{xrx:doc-viewer-path()}</xrx:doc-viewer-path>
   <xrx:get-apps-node>{xrx:get-apps-node()}</xrx:get-apps-node>
   <xrx:get-searchable-apps>{xrx:get-searchable-apps()}</xrx:get-searchable-apps>
</results>
