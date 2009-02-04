xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $id := request:get-parameter("id", "")

let $app-collection := style:app-base-uri()
let $data-collection := concat($app-collection, '/data')
let $doc := concat($data-collection, '/', $id, '.xml')
 
(: this script takes the integer value of the id parameter passed via get :)
let $id := xs:integer(request:get-parameter('id', ''))

(: this logs you into the collection :)
let $login := xmldb:login($data-collection, 'admin', 'admin123')

(: this constructs the filename from the id :)
let $file := concat($id, '.xml')

(: this deletes the file :)
let $store := xmldb:remove($data-collection, $file)

return
<html>
    <head>
       <title>Delete Item</title>
       {style:import-css()}
    </head>
    <body>
      {style:header()}
      {style:breadcrumb()} &gt; <a href="../views/list-items.xq">List Items</a>
      <h1>Item id {$id} has been removed.</h1>
      {style:footer()}
</body>
</html>
