xquery version "1.0";

(: List of all Annotators in the  :)

import module namespace style = "http://danmccreary.com/style" at "../modules/style.xqm";

let $title := 'List of all TEI Annotators in Config File'

let $config-file := concat($style:db-path-to-app, '/utils/ckeditor/plugins/tei-ann/config/Annotator-Specifications.xml')
let $annotators := doc($config-file)//Annotator

let $content := 
<div class="content">
      <style type="text/css"><![CDATA[
         thead tr {color: blue; background-color: lightblue;}
         .pass, .fail, .unknown {font-weight: bold;}
         .pass {color: green;}
         .fail {color: red;}
         .unknown {color: purple;}
         td {padding: 5px;}
      ]]></style>
      Count = {count($annotators)}
      <table class="span-23 last">
         <thead>
            <tr>
               <th class="span-1">Name</th>
               <th class="span-5">Description</th>
               <th class="span-1">TEI Element</th>
               <th class="span-1">Type</th>
               <th class="span-1">Parents</th>
               <th class="span-1 last">Dialog</th>
            </tr>
            
         </thead>
         <tbody>
      {
      for $annotator in $annotators
         let $id := string($annotator/@id)
         let $label := substring-before(substring-after($id, 'teiann'), 'Btn')
         order by $label
         return  
            <tr>
               <td><a 
                     href="view-annotator.xq?id={$id}"
                     >{$label}</a></td>
               <td>{$annotator/AnnotatorDescriptionText/text()}</td>
               <td>{string($annotator/@name)}</td>
               <td>{string($annotator/@typeCode)}</td>
               <td>{string($annotator/AnnotatorPossibleParentElementNames/text())}</td>
               <td>{if ($annotator/AnnotatorPanel)
                   then <a href="view-panel.xq?id={$id}">View</a>
                   else ()
                   }</td>
            </tr>
      }
      </tbody>
      </table>
</div>

return 
    style:assemble-page($title, $content)
