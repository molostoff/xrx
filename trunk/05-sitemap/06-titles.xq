xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare function local:sitemap($collection as xs:string) as node()* {
   for $child in xmldb:get-child-collections($collection)
      let $path := concat( $collection, '/', $child)
   return
        <ul>
           <li><a href="{concat('/exist/rest', $collection, '/', $child)}">
              {doc('/db/apps/sitemap/06-collection-titles.xml')/code-table/item[$path=path]/title/text()}</a>
           </li>
           {local:sitemap(concat($collection, '/', $child))}
        </ul>
};
 
<html>
   <head>
      <title>Sitemap</title>
   </head>
   <body>
      {local:sitemap('/db/webroot')}
   </body>
</html>

