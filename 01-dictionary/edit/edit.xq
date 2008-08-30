xquery version "1.0";
declare namespace exist="http://exist.sourceforge.net/NS/exist"; 
declare namespace system="http://exist-db.org/xquery/system";
declare namespace request="http://exist-db.org/xquery/request";

(: media-type of application/xhtml+xml is necessary for Firefox plugin to render
 : xforms, as per ibm.com/developerwords/xml/library/x-xformsfirefox/ :)
declare option exist:serialize "method=xhtml media-type=application/xhtml+xml indent=yes"; 

let $new := request:get-parameter('new', '')
let $id := request:get-parameter('id', '')
 
return
(: check for required parameters :)
if (not($new or $id))
    then (
    <error>
        <message>Parameter "new" and "id" are both missing.  One of these two arguments is required for this web service.</message>
    </error>)
    else
      let $server-port := substring-before(request:get-url(), '/exist/rest/db/') 
      let $collection := '/db/dictionary/data'
 
     (: put in the appropriate file name :)
     let $file := if ($new)
        then ('new-instance.xml')
        else ( concat( $server-port, '/exist/rest', $collection, '/', $id, '.xml'))
return
<html xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xf="http://www.w3.org/2002/xforms" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ev="http://www.w3.org/2001/xml-events" >
    <head>
       <title>Edit Term</title>
       <xf:model>
           <!-- this line loads either the new instance or the current data file into the form model -->
           <xf:instance xmlns="" src="{$file}" id="my-task"/>
           <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" instance="my-task" replace="all"/>
       </xf:model>
    </head>
    <body>
       <xf:output ref="id" class="id">
           <xf:label>ID:</xf:label>
       </xf:output>
       <xf:input ref="TermName" class="TermName">
           <xf:label>Term:</xf:label>
       </xf:input>
       <xf:textarea ref="TermDefinition" class="TermDefinition">
           <xf:label>Definition:</xf:label>
       </xf:textarea>
       <xf:submit submission="save">
           <xf:label>Submit</xf:label>
       </xf:submit>
    </body>
</html>
