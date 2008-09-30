xquery version "1.0";

declare function local:sitemap($collection as xs:string) as node()* {
   for $child in xmldb:get-child-collections($collection)
   return
        <ul>
           <li>{$child}</li>
           {local:sitemap(concat($collection, '/', $child))}
        </ul>
};
 
<site>{local:sitemap('/db/webroot')}</site>

