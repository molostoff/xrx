xquery version "1.0";

let $get-uri := request:get-uri()
let $app-base := substring-before(substring-after($get-uri, '/exist/rest'), '/views/')
let $data-collection := concat($app-base, '/data')

return
<results>
   <get-uri>{$get-uri}</get-uri>
   <app-base>{$app-base}</app-base>
   <data-collection>{$data-collection}</data-collection>
</results>