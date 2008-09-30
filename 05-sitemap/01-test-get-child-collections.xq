xquery version "1.0";

let $children := xmldb:get-child-collections('/db/webroot')

return
<results>
   <children>{$children}</children>
</results>
