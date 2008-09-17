xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";
 
let $collection := '/db/apps/forecast-subscriptions/data'

return

<html>
   <head>
      <title>Subscriptions</title>
      <style language="text/css">
      <![CDATA[
         body {font-family: Arial, Helvetica; sans-serif;}
      ]]>
  </style>

   </head>
   <body>
   <h1>Forecast Subscriptions</h1>
   <table>{
      for $item in collection($collection)/subscription
         let $id := $item/id/text()
      return
         <tr>
            <td>{$item/username/text()}</td>
            <td>{$item/status/text()}</td>
             <td><a href="view-item.xq?id={$id}">View</a></td>
             <td><a href="../edit/edit.xq?id={$id}">Edit</a></td>
             <td><a href="../edit/delete.xq?id={$id}">Delete</a></td>
         </tr> 
   }</table>
   </body>
</html>