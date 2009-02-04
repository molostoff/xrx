xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
(: XQuery to construct an XForm for either a new item or update item :)
declare option exist:serialize "method=xhtml media-type=application/xhtml+xml indent=yes"; 

let $new := request:get-parameter('new', '')
let $id := request:get-parameter('id', '')
 
return
(: check for required parameters :)
if (not($new or $id))
    then (
    <error>
        <message>Parameter "new" and "id" are both missing.  One of these two arguments is required for form.</message>
    </error>)
    else
      let $app-collection := style:app-base-url()
      let $data-collection := concat($app-collection, '/data')

     (: put in the appropriate file name :)
     let $file := if ($new)
        then ('new-instance.xml')
        else (concat($data-collection, '/', $id, '.xml'))
return
<html xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xf="http://www.w3.org/2002/xforms" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ev="http://www.w3.org/2001/xml-events" >
    <head>
       <title>Edit Item</title>
       {style:import-css()}
       <link type="text/css" rel="stylesheet" href="edit.css"/>
       <xf:model>
           <!-- this line loads either the new instance or the current data file into the form model -->
           <xf:instance xmlns="" src="{$file}" id="my-item"/>
           <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" instance="my-task" replace="all"/>
       </xf:model>
    </head>
    <body>
    {style:header()}
    {style:breadcrumb()} &gt; <a href="../views/list-items.xq">List all Items</a>
    <h2>Edit Item</h2>
    
     {if ($id)
        then (
           <xf:output ref="id" class="id">
               <xf:label>ID:</xf:label>
           </xf:output>
        ) else ()}
       
       <xf:input ref="name">
           <xf:label>Item Name:</xf:label>
       </xf:input>
       
       <xf:textarea ref="description" class="description">
           <xf:label>Item Description:</xf:label>
       </xf:textarea>
       
       <xf:select1 ref="category"  class="category">
       <xf:label>Item Category:</xf:label>
               <xf:item>
                  <xf:label>Small</xf:label>
                  <xf:value>small</xf:value>
               </xf:item>
               <xf:item>
                  <xf:label>Medium</xf:label>
                  <xf:value>medium</xf:value>
               </xf:item>
               <xf:item>
                  <xf:label>Large</xf:label>
                  <xf:value>large</xf:value>
               </xf:item>
       </xf:select1>
       
       <xf:select1 ref="status"  class="status">
       <xf:label>Item Status:</xf:label>
               <xf:item>
                  <xf:label>Draft</xf:label>
                  <xf:value>draft</xf:value>
               </xf:item>
               <xf:item>
                  <xf:label>In Review</xf:label>
                  <xf:value>in-review</xf:value>
               </xf:item>
               <xf:item>
                  <xf:label>Approved for Publishing</xf:label>
                  <xf:value>published</xf:value>
               </xf:item>
       </xf:select1>
       
       <xf:input ref="tag">
           <xf:label>Item Tag:</xf:label>
       </xf:input>
       
       <xf:submit submission="save">
           <xf:label>Save</xf:label>
       </xf:submit>
    </body>
</html>
