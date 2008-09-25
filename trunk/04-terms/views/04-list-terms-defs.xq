xquery version "1.0";
declare option exist:serialize "method=html media-type=text/html omit-xml-declaration=yes indent=yes";

(: Example of report  that returns an ordered list all terms in a collection :)
let $collection :=  concat(substring-before(substring-after(request:get-uri(), '/exist/rest'), '/views/'), '/data')

return
<html>
   <head>
      <title>Terms</title>
   </head>
   <body>
      <ol>{
       for $term in subsequence(collection($collection)/term, 1, 30)
       return
             <li>{$term/name/text()} - {$term/definition[1]/text()}</li>
       }</ol>
    </body>
</html>

