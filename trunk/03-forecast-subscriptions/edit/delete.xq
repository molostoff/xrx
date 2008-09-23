xquery version "1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace request="http://exist-db.org/xquery/request";

(: delete.xq :)

let $collection := '/db/apps/forecast-subscriptions/data'
 
(: this script takes the integer value of the id parameter passed via get :)
let $id := xs:integer(request:get-parameter('id', ''))

(: this logs you into the collection :)
let $login := xmldb:login($collection, 'mdr', 'mdr123')

(: this constructs the filename from the id :)
let $file := concat($id, '.xml')

(: this deletes the file :)
let $store := xmldb:remove($collection, $file)

return
<html>
    <head>
       <title>Delete Conformation</title>
    </head>
    <body>
    <p>Item {$id} has been deleted.</p>
    <a href="../views/list-items.xq">List all items</a>
    </body>
</html>
