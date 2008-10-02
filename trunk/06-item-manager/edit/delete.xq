xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
 
let $collection := '/db/apps/manage-items/data'
 
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
        <title>Delete FAQ</title>
        <style>
  <![CDATA[
   .warn  {background-color: silver; color: black; font-size: 16pt; line-height: 24pt; padding: 5pt; border:solid 2px black;}
  ]]>
  </style>
    </head>
    <body>
        <a href="../index.xhtml">FAQ Home</a> &gt; <a href="../views/list-items.xq">List FAQs</a><br/>

    <h1>FAQ id {$id} has been removed.</h1>
</body>
</html>
