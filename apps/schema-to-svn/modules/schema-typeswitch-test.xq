import module namespace style = "http://danmccreary.com/style" at "../../../modules/style.xqm";
import module namespace st='http://danmccreary.com/schema-typeswitch' at "schema-typeswitch.xqm";

declare namespace xs="http://www.w3.org/2001/XMLSchema";

let $input := request:get-parameter('schema', '01-person.xsd')
let $data-collection := $style:db-path-to-app-data
let $file-path := concat($data-collection, '/', $input)
let $schema-doc := doc($file-path)/xs:schema

return st:dispatch($schema-doc)

