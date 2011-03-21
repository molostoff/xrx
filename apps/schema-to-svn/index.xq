xquery version "1.0";

(: List Items :)

import module namespace style = "http://danmccreary.com/style" at "../../modules/style.xqm";

let $title := 'XML Schema to SVG'

let $content := 
<div class="content">
      <p>Welcome to the {$title}.
      
      This application is a template application.</p>
      
      
      <a href="views/list-items.xq">List items</a> A listing of the XML Schemas in the test database.<br/>
      
      <a href="unit-tests/index.xq">Unit Tests</a> A listing of unit tests.<br/>

      
      
</div>

return 
    style:assemble-page($title, $content)
