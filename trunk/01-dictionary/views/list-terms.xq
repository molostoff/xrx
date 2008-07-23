xquery version "1.0";
 
let $collection := '/db/dictionary'
return
<html>
   <head>
      <title>Listing of Dictionary Terms</title>
   </head>
   <body>
   <h1>Dictionary Terms</h1>
   <ol>{for $term in collection($collection)/Term
      return
         <li>{$term/TermName/text()} : {$term/Defintion/text()}
             <a href="view-term.xq?id={$id}">View</a>
             <a href="../edit/edit.xq?id={$id}">Edit</a>
         </li>
   }</ol>
   </body>
</html>
