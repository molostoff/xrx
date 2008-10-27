xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $collection := '/db/apps/item-manager/data'

(: the search query string :)
let $q := request:get-parameter('q', '')

return
<html>
    <head>
       <title>Seach Results</title>       
     </head>
     <body>
        <h1>Search Results</h1>
        <p><b>Search results for: </b>{$q} <b> In collection: </b>{$collection}</p>
     <ol>{
        (: search any column that matchs this string :)
        for $hit in collection($collection)/item[*/text() &= $q]
        return
           <li><a href="../views/view-item.xq?id={$hit/id/text()}">{$hit/name/text()}</a></li>
      }</ol>
      
      <a href="search.xhtml">New Search</a>
      <a href="../edit/edit.xq?new=true">New Item</a>
      <a href="../views/list-items.xq">List Items</a>
   </body>
</html>
