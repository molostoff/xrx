xquery version "1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace request="http://exist-db.org/xquery/request";
 
(: update.xq :)
 
let $collection := '/db/apps/forecast-subscriptions/data'
 
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
    <p>Item {$item/id/text()} has been updated.</p>
    <a href="list-items.xq">List all items</a>
    </body>
</html>