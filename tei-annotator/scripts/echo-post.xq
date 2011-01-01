xquery version "1.0";

let $incomming-post-data := request:get-data()
return
<results>
  {$incomming-post-data}
</results>
