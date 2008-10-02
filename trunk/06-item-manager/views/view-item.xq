xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html";

let $id := request:get-parameter('id', '')

(: check for required parameters :)
return

if (not($id))
    then (
    <error>
        <message>Parameter "id" is missing.  This argument is required for this web service.</message>
    </error>)
    else
      let $collection := '/db/apps/item-manager/data'
return
<html>
   <head>
      <title>View Item</title>
       <style language="text/css">
          <![CDATA[
            body {font-family: Arial, Helvetica; sans-serif;}
            tbody tr th {text-align: right;}
           ]]>
      </style>
   </head>
   <body>
   <a href="../index.xhtml">Item Home</a>    &gt; <a href="list-items.xq">List all Items</a>
   <h1>View Item</h1>
   {let $item := collection($collection)/item[id = $id]
      return
         <table>
            <tbody>
             <tr><th>ID:</th><td>{$item/id/text()}</td></tr>
             <tr><th>Name:</th><td>{$item/faq-category-id/text()}</td></tr>
             <tr><th>Description:</th><td>{$item/description/text()}</td></tr>
             <tr><th>Category:</th><td>{$item/category/text()}</td></tr>
             <tr><th>Status:</th><td>{$item/status/text()}</td></tr>
             <tr><th>Tag:</th><td>{$item/tag/text()}</td></tr>
             </tbody>
          </table>
   }
   <a href="../edit/edit.xq?id={$id}">Edit Item</a>
             <a href="../edit/delete-confirm.xq?id={$id}">Delete Item</a>

   </body>
</html>