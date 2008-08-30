xquery version "1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace request="http://exist-db.org/xquery/request";
 
(: update.xq :)
 
let $collection := '/db/dictionary/data'
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $term := request:get-data()
 
(: this logs you into the collection :)
let $login := xmldb:login('/db/dictionary/data', 'username', 'password')

(: get the id out of the posted document :)
let $id := $term/id/text() 
    (: Joe - this was: let id, not let $id :)
let $file := concat($id, '.xml') 
    (: Joe - changed from concat(next-id, '.xml') :)
 
(: this saves the new file and overwrites the old one :)
let $store := xmldb:store($collection, $file, $term)

return
<results>
    <message>{$term/TermName/text(), $term/id/text()} has been updated.</message>
</results>