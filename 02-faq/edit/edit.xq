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
      let $collection := '/db/apps/faqs/data'
 
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
       <title>Edit FAQ</title>
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
            
          .question textarea { 
                 height: 2em; /* a bit less than four lines to demonstrate scrolling */
                 width: 700px;
           }
           
           .answer textarea { 
                 height: 20em; /* a bit less than four lines to demonstrate scrolling */
                 width: 700px;
           }

           ]]>
      </style>
       <xf:model>
           <!-- this line loads either the new instance or the current data file into the form model -->
           <xf:instance xmlns="" src="{$file}" id="my-faq"/>
           
           <xf:instance xmlns="" src="../code-tables/faq-category-codes.xml" id="code-tables"/>
           
           <xf:instance xmlns="" id="views">
           <data>
              <faq-category-id-delete-trigger/>
           </data>
           </xf:instance>
           
           <!-- only display the trigger if we have a second category -->
            <xf:bind id="faq-category-id-delete-trigger" 
            nodeset="instance('views')/faq-category-id-delete-trigger" 
            relevant="instance('my-faq')/faq-category-id[2]"/>

           <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" instance="my-task" replace="all"/>
       </xf:model>
    </head>
    <body>
    <a href="../index.xhtml">FAQ Home</a> &gt; <a href="../views/list-items.xq">List all FAQs</a> &gt; <a href="../views/list-items.xq">View FAQ</a>
    <h2>Edit FAQ</h2>
    
    
     {if ($id)
           then (
           <xf:output ref="id" class="id">
               <xf:label>ID:</xf:label>
           </xf:output>
           ) else ()}
           
           
      <xf:label class="group-label">Select one or more Categories</xf:label>
       <xf:repeat id="faq-category-id-repeat" nodeset="instance('my-faq')/faq-category-id">
          <xf:select1 ref="." class="faq-category-id inline-delete" id="faq-category-id-input">
               <xf:label>Classification:</xf:label>
               <xf:hint>A way to classify each FAQ.</xf:hint>
               <xf:itemset nodeset="instance('code-tables')//items//item">
                 <xf:label ref="label"/>
                 <xf:value ref="value"/>
              </xf:itemset>
           </xf:select1>
           
           <xf:trigger bind="faq-category-id-delete-trigger" class="inline-delete">
               <xf:label>Delete Classification</xf:label>
               <xf:delete nodeset="instance('my-faq')/faq-category-id[index('faq-category-id-repeat')]" ev:event="DOMActivate"/>
           </xf:trigger>
           
       </xf:repeat>
       <xf:trigger>
           <xf:label>Add New Category</xf:label>
           <xf:action ev:event="DOMActivate">
               <xf:insert nodeset="instance('my-faq')/faq-category-id" at="last()" position="after"/>
               <xf:setvalue ref="instance('my-faq')//faq-category-id[index('faq-category-repeat')]" value=""/>
               <xf:setfocus control="faq-category-input"/>
           </xf:action>
       </xf:trigger>


       <xf:textarea ref="question" class="question">
           <xf:label>Question:</xf:label>
       </xf:textarea>
       <xf:textarea ref="answer" class="answer">
           <xf:label>Answer:</xf:label>
       </xf:textarea>
       <xf:submit submission="save">
           <xf:label>Save</xf:label>
       </xf:submit>
    </body>
</html>