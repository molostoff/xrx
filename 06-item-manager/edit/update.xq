xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
(: update.xq :)
 
let $collection := '/db/apps/item-manager/data'
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $item := request:get-data()
 
(: this logs you into the collection :)
let $login := xmldb:login($collection, 'mdr', 'mdr123')

(: get the id out of the posted document :)
let $id := $item/id/text() 

let $file := concat($id, '.xml') 
 
(: this saves the new file and overwrites the old one :)
let $store := xmldb:store($collection, $file, $item)

return
<html>
    <head>
       <title>Update Conformation</title>
    </head>
    <body>
       <a href="../index.xhtml">Item Home</a> &gt; <a href="../views/list-items.xq">List all Items</a> &gt; <a href="../views/view-item.xq?id={$id}">View Item</a>
       <p>Item {$id} has been updated.</p>
    </body>
</html>