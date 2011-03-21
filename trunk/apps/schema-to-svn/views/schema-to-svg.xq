import module namespace style = "http://danmccreary.com/style" at "../../../modules/style.xqm";
import module namespace st='http://danmccreary.com/schema-typeswitch' at "../modules/schema-typeswitch.xqm";
import module namespace schema-to-svg='http://danmccreary.com/schema-to-svg' at "../modules/schema-to-svg.xqm";
declare namespace xs="http://www.w3.org/2001/XMLSchema";

let $node := doc(concat($style:db-path-to-app-data, '/', request:get-parameter('file', '')))/*

return
   st:schema($node)
