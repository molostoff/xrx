xquery version "1.0";
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $app-collection := style:app-base-url()
let $file := 'Metadata Shopper'

return
<html xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>{$file}</title>
        {style:import-css()}
        <link rel="stylesheet" type="text/css" href="shopping-cart.css"/>
        <xf:model>
            <xf:instance xmlns="" id="search-criteria">
                <data>
                    <q/>
                </data>
            </xf:instance>
            <xf:instance xmlns="" id="shopping-cart">
                <data>
                    <!-- this is the file name that the shopping cart contents will be stored -->
                    <filename>test.xml</filename>
                    <element>
                        <name>Super</name>
                        <prefix>uc</prefix>
                        <definition>The root of all data elements.</definition>
                    </element>
                </data>
            </xf:instance>
            
            <xf:instance xmlns="" id="search-response">
                <data/>
            </xf:instance>
            
            <xf:instance xmlns="" id="list-files-response">
                <data/>
            </xf:instance>
            
            <xf:instance xmlns="" id="save-wantlist-response">
                <data/>
            </xf:instance>
            
            <xf:submission id="search" ref="instance('search-criteria')" method="get" 
            action="{$app-collection}/search.xq" replace="instance" instance="search-response" separator="&amp;">
                <xf:toggle case="case-busy" ev:event="xforms-submit"/>
                <xf:toggle case="case-submit-error" ev:event="xforms-submit-error"/>
                <xf:toggle case="case-done" ev:event="xforms-submit-done"/>
            </xf:submission>
            
            <!-- Gets the list of current files in the server-side collection and puts them in the model -->
            <xf:submission id="list-files" method="post" action="list-files.xq" replace="instance" instance="list-files-response"/>

            <xf:submission id="save-wantlist" ref="instance('shopping-cart')" method="post" 
            action="{$app-collection}/save.xq" replace="instance" instance="save-wantlist-response" separator="&amp;">
                <xf:toggle case="save-wantlist-case-busy" ev:event="xforms-submit"/>
                <xf:toggle case="save-wantlist-case-submit-error" ev:event="xforms-submit-error"/>
                <xf:toggle case="save-wantlist-case-done" ev:event="xforms-submit-done"/>
            </xf:submission>
            
            <xf:submission id="echo-search-criteria" ref="instance('search-criteria')" method="post" action="../xqueries/echo-test.xq" replace="all"/>
            <xf:submission id="echo-wantlist" ref="instance('shopping-cart')" method="post" action="../xqueries/echo-test.xq" replace="all"/>
           
           <xf:action ev:event="xforms-ready">
              <xf:setfocus control="search-field"/>
           </xf:action>

        </xf:model>
    </head>
    <body>
       {style:header()}
       {style:breadcrumb()}
       <h3>Metadata Shopper</h3>
      <div id="left-column">
          <div id="search-form">
                <xf:input ref="instance('search-criteria')/q" incremental="true" id="search-field">
                    <xf:label>Search:</xf:label>
                    <xf:action ev:event="DOMActivate">
                       <xf:send submission="search"/>
                    </xf:action>
                </xf:input>
                
                <xf:submit submission="search">
                    <xf:label>Search</xf:label>
                </xf:submit>
            </div>
    
        
        <div id="search-results">
            <xf:switch>
                <xf:case id="ready"/>
                <xf:case id="case-busy">
                    <p>Waiting for response...</p>
                </xf:case>
                <xf:case id="case-submit-error">
                    <p>The server has returned a submit error event.</p>
                </xf:case>
                <xf:case id="case-done">
                    <h3>Search Results:</h3>
                    <xf:repeat id="search-results-repeat" nodeset="instance('search-response')/element">
                        <div class="result">
                             <xf:trigger>
                                <xf:label>Add</xf:label>
                                <xf:action ev:event="DOMActivate">
                                <!-- copy the element from the selected item to the destination -->
                                    <xf:insert
                                    origin="instance('search-response')/element[index('search-results-repeat')=position()]" 
                                    nodeset="instance('shopping-cart')/element" at="last()" position="after"/>
                                </xf:action>
                            </xf:trigger>
                            <div class="result-text">
                                <b>
                                    <xf:output ref="name/text()"/>
                                </b>
                                <i>
                                    <xf:output ref="definition/text()"/>
                                </i>
                           </div>
                       </div>
                    </xf:repeat>
                </xf:case>
            </xf:switch>
                
                <!-- the save results switch -->
                <xf:switch>
                    <xf:case id="ready"/>
                    <xf:case id="save-wantlist-case-busy">
                        <p>Waiting for response...</p>
                    </xf:case>
                    <xf:case id="save-wantlist-case-submit-error">
                        <p>The server has returned a submit error event.</p>
                    </xf:case>
                    <xf:case id="save-wantlist-case-done">
                        <div class="search-results">
                            <xf:repeat id="search-results-repeat" nodeset="instance('save-wantlist-response')/results">
                                <xf:output ref="Message/text()"/>
                            </xf:repeat>
                        </div>
                    </xf:case>
                </xf:switch>
           </div>
       </div>
       
     <div id="right-column">
        <div id="shopping-cart-save">
             <!-- the save wantlist -->
             <xf:switch>
                <xf:case id="default">
                   <xf:trigger>
                       <xf:label>Save Wantlist As...</xf:label>
                       <xf:toggle case="save-dialog" ev:event="DOMActivate"/>
                    </xf:trigger>
                </xf:case>
                <xf:case id="save-dialog">
                
                    <!-- go to the server and get the files in the save collection -->
                    <xf:action ev:event="xforms-select">
                        <xf:send submission="list-files"/>
                    </xf:action>
                    
                    <!-- this turns all the files into buttons that can be selected to select a specific file -->
                    <xf:repeat nodeset="instance('list-files-response')/file" class="list-files" id="list-files-repeat">
                        <xf:trigger appearance="minimal">
                            <xf:label>
                                <xf:output ref="."/>
                            </xf:label>
                            <!-- when the user clicks on a file name we copy it to the file name in the shopping cart -->
                            <xf:action ev:event="DOMActivate">
                                <!-- set the filename that we will save to to the value under the selected item -->
                                <xf:setvalue
                                    ref="instance('shopping-cart')/filename"                        
                                    value="instance('list-files-response')/file[index('list-files-repeat')]"/>
                            </xf:action>
                        </xf:trigger>
                    </xf:repeat>
                    
                    
                    <xf:input ref="instance('shopping-cart')/filename">
                        <xf:label>File Name:</xf:label>
                    </xf:input>
                    <br/>
                    
                    <xf:submit submission="list-files">
                        <xf:label>Refresh</xf:label>
                    </xf:submit>
                    
                    <xf:submit submission="save-wantlist">
                        <xf:label>Save Wantlist</xf:label>
                         <xf:toggle case="default" ev:event="DOMActivate"/>
                    </xf:submit>
 
                </xf:case>
            </xf:switch>
            <xf:output ref="instance('save-wantlist-response')/message">
                <xf:label>Save Status:</xf:label>
            </xf:output>
      </div>
      
         <div id="shopping-cart-sidebar">
            <img src="shopping-cart.jpg" height="50"/>
            <h3>Shopping Cart Contents:</h3>
           <xf:repeat id="shopping-cart-repeat" nodeset="instance('shopping-cart')/element">
                <xf:trigger>
                    <xf:label>Delete</xf:label>
                    <xf:delete ev:event="DOMActivate" 
                    nodeset="instance('shopping-cart')/element[index('shopping-cart-repeat')]"/>
                </xf:trigger>
                <xf:output value="concat(prefix,':', name)" class="url"/>
            </xf:repeat>

        </div>
       </div>
    </body>
</html>