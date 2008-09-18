xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";
 
let $doc := '/db/apps/faqs/code-tables/faq-category-codes.xml'

return

<html>
   <head>
      <title>List FAQ Categories</title>
      <style language="text/css">
          <![CDATA[
            body {font-family: Arial, Helvetica; sans-serif;}
           ]]>
      </style>
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
   <a href="../index.xhtml">FAQ Home</a>
   </body>
</html>