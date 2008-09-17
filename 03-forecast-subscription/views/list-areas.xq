xquery version "1.0";

(: this takes the list of boundaries and converts it to a selection list for the form :)

let $doc := 'http://www.cems.uwe.ac.uk/xmlwiki/Met/shippingareas.xml'

return
<itemset name="area">{
   for $item in doc($doc)/boundaries/boundary/@area
   return
   <item>
      <label>{$item}</label>
      <value>{$item}</value>
   </item>
}</itemset>
