xquery version "1.0";

(: this takes the list of boundaries and converts it to a selection list for the form :)

let $doc := 'http://www.cems.uwe.ac.uk/xmlwiki/Met/shippingareas.xml'

return
<codes>
    <itemset name="area">{
       for $item in doc($doc)/boundaries/boundary/@area
          order by $item
       return
       <item>
          <label>{string($item)}</label>
          <value>{string($item)}</value>
       </item>
    }</itemset>
</codes>
