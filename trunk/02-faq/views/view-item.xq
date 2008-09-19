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
      let $server-port := substring-before(request:get-url(), '/exist/rest/db/') 
      let $collection := '/db/apps/faqs/data'
return
<html>
   <head>
      <title>View FAQ</title>
       <style language="text/css">
          <![CDATA[
            body {font-family: Arial, Helvetica; sans-serif;}
           ]]>
      </style>
   </head>
   <body>
   <a href="../index.xhtml">FAQ Home</a>    &gt; <a href="list-items.xq">List all items</a>
   <h1>View FAQ</h1>
   {let $item := collection($collection)/faq[id = $id]
      return
         <table>
             <tr><td>ID:</td><td>{$item/id/text()}</td></tr>
              <tr><td>Category:</td><td>{$item/faq-category-id/text()}</td></tr>
             <tr><td>Question:</td><td>{$item/question}</td></tr>
             <tr><td>Answer:</td><td>{$item/answer}</td></tr>
          </table>
   }
   <a href="../edit/edit.xq?id={$id}">Edit Item</a>
             <a href="../edit/delete-confirm.xq?id={$id}">Delete Item</a>

   </body>
</html>