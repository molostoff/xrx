xquery version "1.0";

module namespace xsd-util="http://danmccreary.com/xsd-util";

(: this module contains a set of utility functions that work on a single XML Schema file :)

(:import module namespace sch-sev="http://danmccreary.com/xsd-util" at "../modules/xml-schema-utilities.xqm";:)

(: the main application that we store all our apps :)
declare variable $xsd-util:app-collection := '/db/dma/apps/schemas';
declare variable $xsd-util:data-collection := concat($xsd-util:app-collection, '/data');

declare function xsd-util:list-named-simple-types () as xs:string* {
  for $item in collection($xsd-util:data-collection)//xs:simpleType[@name and xs:restriction/xs:enumeration]
  order by $item/@name/string()
  return
     $item/@name/string()
};

(: In the general case we should add functions to deal with 2 simple types with the same name coming from different schemas:)
declare function xsd-util:enumerations ($name as xs:string) as xs:string* {
  let $simpletype := collection($xsd-util:data-collection)//xs:simpleType[@name = $name]
  return
    for $enum in $simpletype//xs:enumeration/@value
    order by $enum
    return $enum
};

declare function xsd-util:enumeration-code-table ($name as xs:string) as node() {
  let $simpletype := collection($xsd-util:data-collection)//xs:simpleType[@name = $name]
  return
    <code-table>
        <name>{$name}</name>
            <items>
                <item>
                    <label>Select An Item...</label>
                    <value/>
                </item>
                 {
                   for $enum in $simpletype//xs:enumeration/@value/string()
                   order by $enum
                   return 
                    <item>
                        <label>{$enum}</label>
                        <value>{$enum}</value>
                    </item>}
        </items>
    </code-table>
};