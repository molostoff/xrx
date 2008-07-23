xquery version "1.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
 
(: this is the collection where we store all the terms, one file per term :)
let $collection := '/db/dictionary/data'
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $term := request:get-data()
 
(: this logs you into the collection :)
let $collection := xmldb:collection('/db/dictionary/data', 'mylogin', 'mypassword')
 
(: get the next ID :)
let $next-id := doc(concat($collection, 'edit/next-id.xml'))/next-id/text()
let $file := concat($next-id, 'xml')
 
(: this creates a new file using the next-id and saves the term into the file :)
let $store := store($collection, $file, $term)
 
(: this updates the next-id :)
let $update := update insert doc("/db/dictionary/new/instance.xml")//id/text() ($next-id + 1)
 
(: this updates the next-id :)
let $update := update insert doc("/db/dictionary/new/instance.xml")//id/text() ($next-id + 1)
 
<results>
    <message>{$term/TermName/text(), $term/id/text()} has been saved.</message>
</results>
