xquery version "1.0";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=html media-type=text/html indent=yes";

let $start := xs:integer(request:get-parameter("start", "1"))
let $records := xs:integer(request:get-parameter("records", "20"))
let $query-base := request:get-url()

let $collection :=  concat(substring-before(substring-after(request:get-uri(), '/exist/rest'), '/views/'), '/data')

(: Getting N more items :)

return
<html>
   <head>
      <title>HTML Table</title>
   </head>
   <body>
   <h1>Terms and Defintions</h1>
   <input type="button"
       onClick="parent.location='{$query-base}?start={$start - $records}&amp;records={$records}'" value="Previous"/>
    <input type="button"
       onClick="parent.location='{$query-base}?start={$start + $records}&amp;records={$records}'" value="Next"/>
      <table border="1">
         <thead>
            <th>Term</th>
            <th>Definition</th>
        </thead>
            <tbody>{
            (: note the 'at $count' has been added to the line below :)
                for $term at $count in subsequence(collection($collection)/term, $start, $records)
                return
                <tr> {if ($count mod 2) then (attribute {'bgcolor'} {'Lavender'}) else ()}
                    <td><a href="view-item.xq?id={$term/name/@id}">{$term/name/text()}</a></td>
                    <td>{$term/definition[1]/text()}</td>
                </tr>
              }</tbody>
      </table>
      <input type="button"
       onClick="parent.location='{$query-base}?start={$start - $records}&amp;records={$records}'" value="Previous"/>
    <input type="button"
       onClick="parent.location='{$query-base}?start={$start + $records}&amp;records={$records}'" value="Next"/>
    </body>
</html>

