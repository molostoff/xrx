xquery version "1.0";

declare option exist:serialize "method=html media-type=text/html indent=yes";

declare function local:max-length($string-seq as xs:string*) as xs:string+ {
  let $max := max (for $s in  $string-seq  return string-length($s))
  return $string-seq[string-length(.) = $max]
};
 
let $app-collection := '/db/apps/faqs'
let $data-collection := concat($app-collection, '/data')
let $code-table-file := concat($app-collection, '/code-tables/faq-category-codes.xml')

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
   <h1>FAQ Metrics</h1>
   <b>Collection: </b>{$app-collection}<br/>
   <b>Code Table: </b>{$code-table-file}
   <table border="1">
       <thead>
       <tr>
          <th>Metric</th>
          <th>Value</th>
       </tr>
    </thead>
    <tbody>
        <tr>
           <td align="right">Count of FAQs: </td>
           <td>{count(collection($data-collection)/faq)}</td>
        </tr>
         <tr>
           <td  align="right">Count of FAQ Categories:</td>
           <td>{count( doc($code-table-file)/code-table/items/item )}</td>
        </tr>
         <tr>
           <td  align="right">Longest Question:</td>
           <td>{local:max-length(collection($data-collection)/faq/question)}</td>
        </tr>
         <tr>
           <td  align="right">Longest Answer:</td>
           <td>{local:max-length(collection($data-collection)/faq/answer)}</td>
        </tr>
      </tbody>
   </table>
   </body>
</html>