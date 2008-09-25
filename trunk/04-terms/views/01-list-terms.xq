xquery version "1.0";

(: Example of report  that list all the XML terms in a collection.  This takes a long time if you have many terms. :)

let $get-uri := request:get-uri()
let $app-base := substring-before(substring-after($get-uri, '/exist/rest'), '/views/')
let $collection := concat($app-base, '/data')

return
<terms>{
   for $term in collection($collection)/term
   return
         $term
   }
</terms>