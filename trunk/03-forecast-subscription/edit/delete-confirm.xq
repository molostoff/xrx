xquery version "1.0";

declare namespace exist = "http://exist.sourceforge.net/NS/exist"; 
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace tmd="http://metadata.pace.thrivent.com/data-element";

declare option exist:serialize "method=xhtml media-type=text/xml indent=yes";

let $param := request:get-parameter("id", "")
let $collection := '/db/mdr/glossaries/data/pace/'
let $rest-collection := concat('/exist/rest', $collection)
let $file := concat($collection, $param, '.xml')
let $rest-file := concat($rest-collection, $param, '.xml')
let $path := request:get-url()
let $server-port := substring-before(request:get-url(), '/exist/rest/db/')
let $my-doc := concat($server-port, '/exist/rest/db/mdr/glossaries/data/pace/', $param, '.xml')
       let $my-term := doc($file)/Term
          let $id := $my-term/id/text()
          let $term-name := $my-term/TermName/text()
 return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Delete Confirmation</title>
        <link rel="stylesheet" type="text/css" href="../../resources/css/thrivent.css"/>
        <style>
  <![CDATA[
    a {background-color: silver; color: black; font-size: 16pt; line-height: 24pt; padding: 5pt; border:solid 2px black;}
  ]]>
  </style>
    </head>
    <body>
        <img src="../../resources/images/thrivent_logo.jpg" alt="logo"/>
        <hr class="thrivent-red"/>
        <hr class="thrivent-gold"/>
        <h1>Are you sure you want to delete this term?</h1>
        <b>Term: </b>{$term-name}
        <br/>
        <b>ID: </b>{$id}
        <br/><br/>
        <br/>
        <a href="../edit/delete.xq?id={$id}">Yes - Delete This Term</a>
        <br/><br/>
        <br/>
         <a href="../views/view-term.xq?id={$id}">Cancel (Back to View screen)</a>
    </body>
</html>
