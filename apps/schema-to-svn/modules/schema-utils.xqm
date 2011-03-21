xquery version "1.0";
module namespace sch-util='http://code.google.com/p/xrx/schema-util';

declare namespace xs="http://www.w3.org/2001/XMLSchema";

(: XML Schema Utilities :)

(: return a true if the element is complex :)
(: Algorithm
   1) if there is a complexType name="$name" that has this name return true
   2) if there is a nameType that is a complexType then return true
   3) if there is an element with this name that has a child element of complexType return true
   
   else return false

:)
declare function sch-util:isComplexName($schema as node(), $name as xs:string) as xs:boolean {
let $elements := $schema//xs:element[@name=$name]
let $types := for $element in $elements return string($element/@type)

return
      if ($schema//xs:complexType[@name=$name])
         then true()
         else if ($schema//xs:complexType[@name = concat($name, 'Type')])
            then true()
            else if ($schema//xs:element[@name=$name]/xs:complexType)
               then true ()
               else false()
};

(: return a true if the element is complex :)
(: return true if an element is a complex element :)
declare function sch-util:isComplexElement($schema as node(), $element as node()) as xs:boolean {

      if ($schema//xs:element[@name=$element-name]/xs:complexType)
         then true()
         else false()
};

declare function sch-util:debug($schema as node(), $element-name as xs:string) as xs:string {
let $element := $schema//xs:element[@name=$element-name]
return
      string(count($element))
};

declare function sch-util:count-nodes($schema as node()) as xs:integer {
count($schema//node())
};

declare function sch-util:count-named-items($schema as node()) as xs:integer {
count($schema//node()[@name])
};

declare function sch-util:types-for-name($schema as node(), $element-name as xs:string) as xs:string {
let $elements := $schema//xs:element[@name=$element-name]
return
      string-join(distinct-values(for $element in $elements return string($element/@type)), ', ')
};

(: compare named objects :)
declare function sch-util:compare($one as node()*, $two as node()*) as node() {

(: calculate the MD5 Has on the nodes :)
let $md5-1 := util:hash(<nodes>{$one}</nodes>, 'MD5')
let $md5-2 := util:hash(<nodes>{$two}</nodes>, 'MD5')
return 
  if ($md5-1 = $md5-2) then <comparison>Same</comparison>
  else
  <different>
    <file1>
         {for $element in $elements1
         return
             $element
         }
    </file1>
    <file2>
         
         {for $element in $elements2
         return
             $element
         }
    </file2>
  </different>
};


declare function sch-util:schema-id-from-file-name($file-name as xs:string) as xs:string {
substring-before(substring-after($file-name, 'XML_'), '.xsd')
};

(: you must pass in an XML Schema complexType here :)
declare function sch-util:element-names-for-complex-type($complexType as node()?) as node() {
<element-names>{
for $element in $complexType/xs:choice/xs:element/@name
   order by $element
   return
   <element>{string($element)}</element>
}</element-names>
};


(: given two sequences of sorted items, create a sequence of table rows that shows which items
are in the first list, both lists or the second list.
this diff assumes that the inputs are in alphabetical order :)
declare function sch-util:diff-sequences-to-table-rows($a, $b  as item()*  )  as item()* {
if (empty($a) and empty ($b)) 
   then ()
   else
     if (empty ($b) or $a[1] lt $b[1])
        then
           (<tr class="left"><td>{$a[1]/text()}</td><td/><td/></tr>,
            sch-util:diff-sequences-to-table-rows(subsequence($a, 2), $b)
           )
        else
          if (empty ($a) or $a[1] gt $b[1])
              then
                (<tr class="right">
                   <td/><td/><td>{$b[1]/text()}</td>
                 </tr>,
                 sch-util:diff-sequences-to-table-rows($a, subsequence($b,2))
                )  
              else
                 (<tr class="both">
                    <td/><td>{$a[1]/text()}</td><td/>
                  </tr>,
                  sch-util:diff-sequences-to-table-rows(subsequence($a,2), subsequence($b,2))
                 )
};