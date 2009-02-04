xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $id := request:get-parameter("id", "")

let $app-collection := style:app-base-uri()
let $data-collection := concat($app-collection, '/data')
let $doc := concat($data-collection, '/', $id, '.xml')

 return
<html>
   <head>
      <title>Delete Confirmation</title>
      {style:import-css()}
   </head>
   <body>
      {style:header()}
      {style:breadcrumb()} &gt; <a href="../views/list-items.xq">List Items</a>
        <h1>Are you sure you want to delete this Item?</h1>
        <b>Name: </b>{doc($doc)/item/name/text()}<br/>
        <b>Path: </b> {$doc}
        <br/>
        <br/>
        <a class="warn" href="delete.xq?id={$id}">Yes - Delete This Item</a>
        <br/><br/>
        <br/>
         <a  class="warn" href="../views/view-item.xq?id={$id}">Cancel (Back to View Item)</a>
     {style:footer()}
   </body>
</html>
