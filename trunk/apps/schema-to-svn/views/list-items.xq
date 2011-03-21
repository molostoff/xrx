xquery version "1.0";

import module namespace style = "http://danmccreary.com/style" at "../../../modules/style.xqm";

let $title := 'List XML Schemas'

let $data-collection := $style:db-path-to-app-data

let $files := xmldb:get-child-resources($data-collection)

let $content :=
<div class="content">
<p>The following is a list of XML Schemas used to test the XML Schema to SVG module.</p>
<table class="span-23 last">
   <thead>
      <tr>
         <th class="span-4">File Name</th>
         
         <th class="span-2">SVG</th>
      </tr>
   </thead>
   <tbody>
    {
    for $file in $files
    order by $file
    return
       <tr>
          <td>{$file}</td>
          <td>
           <a href="schema-to-svg.xq?file={$file}">{$file}</a>
          </td>
          
       </tr>
       
    }
   </tbody>
</table>
</div>

     
return
    style:assemble-page($title, $content)