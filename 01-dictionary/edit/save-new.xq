xquery version "1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace request="http://exist-db.org/xquery/request";
 
(: save-new.xq :)
 
let $collection := '/db/dictionary/data'
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $term := request:get-data()
 
(: get the next ID from the next-id.xml file :)
let $next-id-file-path := '/db/dictionary/edit/next-id.xml'
let $id := doc($next-id-file-path)/data/next-id/text() 
let $file := concat($id, '.xml')

(: this logs you into the collection :)
let $login := xmldb:login($collection, 'username', 'password')

(: this creates the new file with a still-empty id element :)
let $store := xmldb:store($collection, $file, $term)

(: this adds the correct ID to the new document :)
let $update-id :=  update replace doc(concat($collection, '/', $file))/Term/id with <id>{$id}</id>

(: this updates the next-id.xml file :)
let $new-next-id :=  update replace doc($next-id-file-path)/data/next-id/text() with ($id + 1)

(: we need to return the original ID number in our results, but $id has already been increased by 1 :)
let $original-id := ($id - 1)

return
<results>
    <message>{$term/TermName/text(), $original-id} has been saved.</message>
</results>
