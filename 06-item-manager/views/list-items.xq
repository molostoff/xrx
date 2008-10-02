xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";
 
let $collection := '/db/apps/item-manager/data'

return

<html>
   <head>
      <title>List Items</title>
      <style language="text/css">
          <![CDATA[
            body {font-family: Arial, Helvetica; sans-serif;}
           ]]>
      </style>
   </head>
   <body>
   <a href="../index.xhtml">Items Home</a> &gt;
    <a href="../edit/edit.xq?new=true">New Item</a>
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
      for $item in collection($collection)/item
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