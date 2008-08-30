xquery version "1.0";
declare namespace exist="http://exist.sourceforge.net/NS/exist"; 

declare option exist:serialize "method=xhtml media-type=text/html";

return
let $collection := '/db/dictionary/data'
<html>
   <head>
      <title>Listing of Dictionary Terms</title>
   </head>
   <body>
   <h1>Dictionary Terms</h1>
   <ol>{for $term in collection($collection)/Term
      let $id := $term/id
      return
         <li>{$term/TermName/text()}: {$term/TermDefinition/text()} 
             [<a href="view-term.xq?id={$id}">View</a>
             <a href="../edit/edit.xq?id={$id}">Edit</a>
             <a href="../edit/delete.xq?id={$id}">Delete</a>] 
         </li> 
   }</ol>
   </body>
</html>