xquery version "1.0";
import module namespace db2html="http://danmccreary.com/docbook2xhtml" at '/db/docbook/docbook-to-html.xqm';
declare namespace db="http://docbook.org/ns/docbook";

let $input := doc('input.xml')/db:article
let $output := db2html:transform($input)
return
<results>
   <input>{$input}</input>
   <output>{$output}</output>
</results>
