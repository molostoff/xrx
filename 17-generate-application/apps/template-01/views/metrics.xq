xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare function local:max-length($string-seq as xs:string*) as xs:string* {
  let $max := max (for $s in  $string-seq  return string-length($s))
  return $string-seq[string-length(.) = $max]
};
 
let $app-collection := style:app-base-uri()
let $data-collection := concat($app-collection, '/data')
let $code-table-file := concat($app-collection, '/code-tables/item-category-codes.xml')

return

<html>
   <head>
      <title>Item Metrics</title>
     {style:import-css()}
   </head>
   <body>
      {style:header()}
      {style:breadcrumb()}
       <h1>Item Metrics</h1>
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
               <td>{count(collection($data-collection)/item)}</td>
            </tr>
             <tr>
               <td  align="right">Count of FAQ Categories:</td>
               <td>{count( doc($code-table-file)/code-table/items/item )}</td>
            </tr>
             <tr>
               <td  align="right">Longest name:</td>
               <td>{local:max-length(collection($data-collection)/item/name/text())}</td>
            </tr>
             <tr>
               <td  align="right">Longest description:</td>
               <td>{local:max-length(collection($data-collection)/item/description/text())}</td>
            </tr>
          </tbody>
       </table>
       {style:footer()}
   </body>
</html>