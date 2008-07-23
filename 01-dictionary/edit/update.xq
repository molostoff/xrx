xquery version "1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
 
(: update.xq :)
 
let $collection := '/db/dictionary/data'
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $term := request:get-data()
 
(: this logs you into the collection :)
let $collection := xmldb:collection('/db/dictionary/data', 'mylogin', 'mypassword')
 
(: get the id out of the posted document :)
let id := $term/id/text()
let $file := concat(next-id, '.xml')
 
(: this saves the new file and overwrites the old one :)
let $store := store($collection, $file, $term)
 
<results>
    <message>{$term/TermName/text(), $term/id/text()} has been updated.</message>
</results>
