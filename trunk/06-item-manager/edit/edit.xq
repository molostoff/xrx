xquery version "1.0";

(: XQuery to construct an XForm for either a new or update :)

(: media-type  for Firefox plugin to render :)
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
      let $server-port := substring-before(request:get-url(), '/exist/rest/db/') 
      let $collection := '/db/apps/item-manager/data'
 
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
       <title>Edit Item</title>
                    <style language="text/css">
          <![CDATA[
            @namespace xf url("http://www.w3.org/2002/xforms");
            body {font-family: Arial, Helvetica; sans-serif;}
            
            /* This line ensures all the separate input controls appear on their own lines */
            xf|output, xf|input, xf|select, xf|select1, xf|textarea {display:block; margin:5px 0;}

        /* Makes the labels right aligned in a column that floats to the left of the input controls. */
        xf|output > xf|label,
        xf|input > xf|label,
        xf|secret > xf|label,
        xf|select > xf|label,
        xf|select1 > xf|label,
        xf|textarea > xf|label
        {text-align:right; padding-right:10px; width:160px; float:left;}

            /* the input values are left aligned */
            xf|value {
               text-align: left;
            }
            
          .description textarea { 
                 height: 4em; /* a bit less than four lines to demonstrate scrolling */
                 width: 500px;
           }

           ]]>
      </style>
       <xf:model>
           <!-- this line loads either the new instance or the current data file into the form model -->
           <xf:instance xmlns="" src="{$file}" id="my-faq"/>
           
           <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" instance="my-task" replace="all"/>
       </xf:model>
    </head>
    <body>
    <a href="../index.xhtml">Item Home</a> &gt; <a href="../views/list-items.xq">List all Items</a>
    <h2>Edit Item</h2>
    
     {if ($id)
           then (
           <xf:output ref="id" class="id">
               <xf:label>ID:</xf:label>
           </xf:output>
           ) else ()}
       
       <xf:input ref="name">
           <xf:label>Name:</xf:label>
       </xf:input>
       
       <xf:textarea ref="description" class="description">
           <xf:label>Question:</xf:label>
       </xf:textarea>
       
       <xf:select1 ref="category"  class="category">
       <xf:label>Category:</xf:label>
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
       <xf:label>Status:</xf:label>
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
           <xf:label>Tag:</xf:label>
       </xf:input>
       
       <xf:submit submission="save">
           <xf:label>Save</xf:label>
       </xf:submit>
    </body>
</html>
