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
      let $collection :=  concat(substring-before(substring-after(request:get-uri(), '/exist/rest'), '/views/'), '/data')
return
<html>
   <head>
      <title>View Term</title>
       <style language="text/css">
          <![CDATA[
            body {font-family: Arial, Helvetica; sans-serif;}
           ]]>
      </style>
   </head>
   <body>
   <a href="../index.xhtml">App Home</a>    &gt; <a href="list-items.xq">List all items</a>
   <h1>View Item</h1>
   {let $item := collection($collection)/term[name/@id = $id]
      return
         <table border="1">
             <tr><th>ID:</th><td>{string($item/name/@id)}</td></tr>
              <tr><th>Term:</th><td>{$item/name/text()}</td></tr>
                  { for $def at $count in $item/definition
                      return
                      <tr>
                         <td>Definition {$count}:</td>
                         <td>{$def/text()} volume={string($def/@volume)}</td>
                      </tr>
                 }
          </table>
   }
   </body>
</html>