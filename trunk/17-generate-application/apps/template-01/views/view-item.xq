xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $id := request:get-parameter('id', '')

(: check for required parameters :)
return

if (not($id))
    then (
    <error>
        <message>Parameter "id" is missing.  This argument is required for this web service.</message>
    </error>)
    else
      let $app-collection := style:app-base-uri()
      let $data-collection := concat($app-collection, '/data')
return
<html>
   <head>
      <title>View Item</title>
      {style:import-css()}
   </head>
   <body>
      {style:header()}
      {style:breadcrumb()} &gt; <a href="list-items.xq">List all Items</a>
   <h1>View Item</h1>
   {let $item := collection($data-collection)/item[id = $id]
      return
         <table>
            <tbody>
             <tr><th class="field-label">ID:</th><td>{$item/id/text()}</td></tr>
             <tr><th class="field-label">Name:</th><td>{$item/faq-category-id/text()}</td></tr>
             <tr><th class="field-label">Description:</th><td>{$item/description/text()}</td></tr>
             <tr><th class="field-label">Category:</th><td>{$item/category/text()}</td></tr>
             <tr><th class="field-label">Status:</th><td>{$item/status/text()}</td></tr>
             <tr><th class="field-label">Tag:</th><td>{$item/tag/text()}</td></tr>
             </tbody>
          </table>
   }
   <a href="../edit/edit.xq?id={$id}">Edit Item</a>
             <a href="../edit/delete-confirm.xq?id={$id}">Delete Item</a>
   {style:footer()}
   </body>
</html>