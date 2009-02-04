xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $app-collection := style:app-base-uri()
let $data-collection := concat($app-collection, '/data')

return

<html>
   <head>
      <title>List Items</title>
      {style:import-css()}
   </head>
   <body>
      {style:header()}
      {style:breadcrumb()}
      <h1>List Items</h1>
       <table>
           <thead>
           <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Status</th>
              <th>Tag</th>
              <th>View</th>
              <th>Edit</th>
              <th>Delete</th>
           </tr>
        </thead>
        <tbody>{
          for $item in collection($data-collection)/item
             let $id := $item/id/text()
          return
             <tr>
                 <td>{$id}</td>
                 <td>{$item/name/text()}</td>
                 <td>{$item/category/text()}</td>
                 <td>{$item/status/text()}</td>
                 <td>{$item/tag/text()}</td>
                 <td><a href="view-item.xq?id={$id}">View</a></td>
                 <td><a href="../edit/edit.xq?id={$id}">Edit</a></td>
                 <td><a href="../edit/delete-confirm.xq?id={$id}">Delete</a></td>
             </tr> 
       }</tbody></table>
  
   </body>
</html>