xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $collection := '/db/apps/faqs/data'

(: the search query string :)
let $q := request:get-parameter('q', '')

return
<html>
    <head>
       <title>Seach Results</title>
       
     </head>
     <body>
      <a href="../index.xhtml">FAQ Home</a> &gt; <a href="../views/list-items.xq">List FAQs</a> &gt; <a href="search.xhtml">New Search</a><br/>
        <h2>FAQ Search Results</h2>
        <p><b>Search results for: </b>{$q} <b> In collection: </b>{$collection}</p>
     <ol>{

(: search any column that matchs this string :)
for $hit in collection($collection)/faq
   let $id := $hit/id/text()
   where contains($hit/*/text(), $q)
return
   <li><a href="../views/view-item.xq?id={ $hit/id/text()}"> {$hit/question/text()} </a></li>

      }</ol>
   </body>
</html>