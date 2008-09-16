xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";
 
let $collection := '/db/apps/faq'

return
let $collection := '/db/dictionary/data'
<html>
   <head>
      <title>FAQs</title>
   </head>
   <body>
   <h1>FAQs</h1>
   <ol>{
      for $term in collection($collection)/faq
         let $id := $term/id/text()
         return
   <ol>{for $item in collection($collection)/faq
      let $id := $term/id
      return
         <li>{$item/question/text()}:
             [<a href="view-item.xq?id={$id}">View</a>
             <a href="../edit/edit.xq?id={$id}">Edit</a>
             <a href="../edit/delete.xq?id={$id}">Delete</a>] 
         </li> 
   }</ol>
   </body>
</html>