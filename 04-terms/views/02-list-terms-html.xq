xquery version "1.0";
declare option exist:serialize "method=html media-type=text/html omit-xml-declaration=yes indent=yes";

(: Example of report  that list all terms in a collection :)

let $get-uri := request:get-uri()
let $app-base := substring-before(substring-after($get-uri, '/exist/rest'), '/views/')
let $collection := concat($app-base, '/data')

return
<html>
   <head>
      <title>Terms</title>
   </head>
   <body>
      <ol>{
       for $term in collection($collection)/term
       return
             <li>{$term/name/text()}</li>
       }</ol>
    </body>
</html>

