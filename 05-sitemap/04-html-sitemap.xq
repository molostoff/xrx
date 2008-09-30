xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare function local:sitemap($collection as xs:string) as node()* {
   for $child in xmldb:get-child-collections($collection)
   return
        <ul>
           <li><{$child}</li>
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

