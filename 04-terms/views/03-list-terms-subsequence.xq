xquery version "1.0";
declare option exist:serialize "method=html media-type=text/html omit-xml-declaration=yes indent=yes";

(: Example of a subsequence of all terms :)

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
             <li>{$term/name/text()}</li>
       }</ol>
    </body>
</html>

