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
      let $collection := '/db/apps/forecast-subscriptions/data'
 
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
       <title>Edit Subscription</title>
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

           ]]>
      </style>
       <xf:model>
           <!-- this line loads either the new instance or the current data file into the form model -->
           <xf:instance xmlns="" src="{$file}" id="my-item"/>
           <xf:instance xmlns="" src="../views/list-areas.xq" id="code-tables"/>
           <xf:bind nodeset="instance('my-item')/status" type="xs:boolean"/>
           <xf:submission id="save" method="post" action="{if ($new='true') then ('save-new.xq') else ('update.xq')}" instance="my-task" replace="all"/>
       </xf:model>
    </head>
    <body>
    <h2>Edit Item</h2>
       <xf:group ref="instance('my-item')">
           {if ($id)
           then (
           <xf:output ref="id" class="id">
               <xf:label>ID:</xf:label>
           </xf:output>
           ) else ()}
           <xf:input ref="username" class="username">
               <xf:label>Username:</xf:label>
           </xf:input>
           <xf:secret ref="password" class="password">
               <xf:label>Password:</xf:label>
           </xf:secret>
            <xf:input ref="mobilenumber" class="mobilenumber">
               <xf:label>Mobile Number:</xf:label>
           </xf:input>
           
            <xf:select1 ref="area" class="area">
               <xf:label>Area:</xf:label>
               <xf:itemset nodeset="instance('code-tables')//itemset[@name='area']/item">
                  <xf:label ref="label"/>
                  <xf:value ref="value"/>
               </xf:itemset>
           </xf:select1>
           
            <xf:input ref="status" class="status">
               <xf:label>Enable Subscription:</xf:label>
           </xf:input>
           
       </xf:group>
       <xf:submit submission="save">
           <xf:label>Save</xf:label>
       </xf:submit><br/>
       <a href="../views/list-items.xq">List Items</a>
    </body>
</html>
