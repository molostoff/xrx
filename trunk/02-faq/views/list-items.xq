xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";

declare function local:get-category-label($id as xs:integer) as xs:string {
    string(doc('/db/apps/faqs/code-tables/faq-category-codes.xml')/code-table/items/item[value=$id]/label/text())
};
 
let $collection := '/db/apps/faqs/data'

return

<html>
   <head>
      <title>List FAQs</title>
      <style language="text/css">
          <![CDATA[
            body {font-family: Arial, Helvetica; sans-serif;}
           ]]>
      </style>
   </head>
   <body>
   <a href="../index.xhtml">FAQ Home</a>
   <h1>List FAQs</h1>
   <table>
       <thead>
       <tr>
          <th>ID</th>
          <th>Category</th>
          <th>Question</th>
          <th>View</th>
          <th>Edit</th>
          <th>Delete</th>
       </tr>
    </thead>
    <tbody>{
      for $item in collection($collection)/faq
         let $id := $item/id/text()
      return
         <tr>
            <td>{$item/id/text()}</td>
            <td>{local:get-category-label($item/faq-category-id[1]/text())}</td>
            <td>{$item/question/text()}</td>            
             <td><a href="view-item.xq?id={$id}">View</a></td>
             <td><a href="../edit/edit.xq?id={$id}">Edit</a></td>
             <td><a href="../edit/delete-confirm.xq?id={$id}">Delete</a></td>
         </tr> 
   }</tbody></table>
   <a href="../edit/edit.xq?new=true">New</a>
   </body>
</html>