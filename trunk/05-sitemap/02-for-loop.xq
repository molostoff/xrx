xquery version "1.0";

<results>{
for $child in xmldb:get-child-collections('/db/webroot')
return
   <child>{$child}</child>
}</results>
