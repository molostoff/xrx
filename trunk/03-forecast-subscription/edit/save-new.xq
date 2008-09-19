xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
(: save-new.xq :)
 
let $app-collection := '/db/apps/faqs'
let $data-collection := concat($app-collection , '/data')
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $item := request:get-data()
 
(: get the next ID from the next-id.xml file :)
let $next-id-file-path := concat($app-collection,'/edit/next-id.xml')
let $id := doc($next-id-file-path)/data/next-id/text() 
let $file := concat($id, '.xml')

(: this logs you into the collection :)
let $login := xmldb:login($app-collection, 'mdr', 'mdr123')

(: this creates the new file with a still-empty id element :)
let $store := xmldb:store($data-collection, $file, $item)

(: this adds the correct ID to the new document we just saved :)
let $update-id :=  update replace doc(concat($data-collection, '/', $file))/faq/id with <id>{$id}</id>

(: this updates the next-id.xml file :)
let $new-next-id :=  update replace doc($next-id-file-path)/data/next-id/text() with ($id + 1)

(: we need to return the original ID number in our results, but $id has already been increased by 1 :)
let $original-id := ($id - 1)

return
<html>
    <head>
       <title>Save Conformation</title>
    </head>
    <body>
    <a href="../index.xhtml">FAQ Home</a>
    <p>FAQ {$original-id} has been saved.</p>
    <a href="../views/list-items.xq">List all FAQ</a> 
    </body>
</html>
