xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";

let $app-collection := style:app-base-uri()
let $code-table-collection := concat($app-collection, '/code-tables')

let $doc := concat($code-table-collection, 'category-codes.xml')

return

<html>
   <head>
      <title>List Categories</title>
      {style:import-css()}
   </head>
   <body>
   <h1>List FAQ Categories</h1>
   <table>
       <thead>
       <tr>
          <th>ID</th>
          <th>Label</th>
       </tr>
    </thead>
    <tbody>{
      for $item in doc($doc)/code-table/items/item
         let $id := $item/id/text()
      return
         <tr>
            <td>{$item/value/text()}</td>
            <td>{$item/label/text()}</td>
         </tr> 
   }</tbody></table>
   
   </body>
</html>