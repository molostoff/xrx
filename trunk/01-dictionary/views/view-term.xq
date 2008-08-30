xquery version "1.0";
declare namespace exist="http://exist.sourceforge.net/NS/exist"; 
declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xhtml media-type=text/html";

let $id := request:get-parameter('id', '')

return
(: check for required parameters :)
if (not($id))
    then (
    <error>
        <message>Parameter "id" is missing.  This argument is required for this web service.</message>
    </error>)
    else
      let $server-port := substring-before(request:get-url(), '/exist/rest/db/') 
      let $collection := '/db/dictionary/data'

return
<html>
   <head>
      <title>View Term</title>
   </head>
   <body>
   <h1>View Term</h1>
   {let $term := collection($collection)/Term[id = $id]
      return
         <p>Term: {$term/TermName/text()}<br/>
             Definition: {$term/TermDefinition/text()}<br/>
             [<a href="../edit/edit.xq?id={$id}">Edit</a>
             <a href="../edit/delete.xq?id={$id}">Delete</a>] 
             </p>
   }
   <p><a href="list-terms.xq">List all terms</a></p>
   </body>
</html>