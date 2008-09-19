xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

let $id := request:get-parameter("id", "")

let $app-collection := '/db/apps/faqs'
let $doc := concat($app-collection, '/data/', $id, '.xml')

 return
<html>
    <head>
        <title>Delete Confirmation</title>
        <style>
  <![CDATA[
   .warn  {background-color: silver; color: black; font-size: 16pt; line-height: 24pt; padding: 5pt; border:solid 2px black;}
  ]]>
  </style>
    </head>
    <body>
        <a href="../index.xhtml">FAQ Home</a> &gt; <a href="../views/list-items.xq">List FAQs</a>
        <h1>Are you sure you want to delete this FAQ?</h1>
        <b>Question: </b>{doc($doc)/faq/question/text()}<br/>
        <b>Path: </b> {$doc}
        <br/>
        <br/>
        <a class="warn" href="delete.xq?id={$id}">Yes - Delete This Question</a>
        <br/><br/>
        <br/>
         <a  class="warn" href="../views/view-item.xq?id={$id}">Cancel (Back to View FAQ)</a>
    </body>
</html>
