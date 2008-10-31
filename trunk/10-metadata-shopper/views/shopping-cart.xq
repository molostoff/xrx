xquery version "1.0";
declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $title := 'Basic Metadata Shopper Version 1'

return
<html
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xf="http://www.w3.org/2002/xforms" 
   xmlns:ev="http://www.w3.org/2001/xml-events">
    <head>
        <title>{$title}</title>
        <link rel="stylesheet" type="text/css" href="shopping-cart.css"/>
        <xf:model>
            <!-- here is where you store the search query before you hit the "search button". -->
            <xf:instance xmlns="" id="search-criteria">
                <data>
                    <q/>
                </data>
            </xf:instance>
            <xf:instance xmlns="" id="shopping-cart">
                <data>
                    <FileName>test.xml</FileName>
                    <!-- Thing from the OWN namespace -->
                    <DataElement>
                        <DataElementName>Thing</DataElementName>
                        <NamespaceURI>http://www.w3.org/2002/07/owl</NamespaceURI>
                        <definition>The root of all data elements.</definition>
                    </DataElement>
                </data>
            </xf:instance>
            <xf:instance xmlns="" id="search-response">
                <data/>
            </xf:instance>
            <xf:instance xmlns="" id="save-wantlist-response">
                <data/>
            </xf:instance>
            <xf:submission id="search" ref="instance('search-criteria')" method="get" action="search-elements.xq" replace="instance" instance="search-response" separator="&amp;">
                <xf:toggle case="case-busy" ev:event="xforms-submit"/>
                <xf:toggle case="case-submit-error" ev:event="xforms-submit-error"/>
                <xf:toggle case="case-done" ev:event="xforms-submit-done"/>
            </xf:submission>
            <xf:submission id="save-wantlist" ref="instance('shopping-cart')" method="post" action="../edit/save-new.xq" replace="instance" instance="save-wantlist-response" separator="&amp;">
                <xf:toggle case="save-wantlist-case-busy" ev:event="xforms-submit"/>
                <xf:toggle case="save-wantlist-case-submit-error" ev:event="xforms-submit-error"/>
                <xf:toggle case="save-wantlist-case-done" ev:event="xforms-submit-done"/>
            </xf:submission>
            <!-- just for testing if you don't have an instance inspector in the browser like XForms buddy -->
            <xf:submission id="echo-search-criteria" ref="instance('search-criteria')" method="post" action="../xqueries/echo-test.xq" replace="all"/>
            <xf:submission id="echo-wantlist" ref="instance('shopping-cart')" method="post" action="../xqueries/echo-test.xq" replace="all"/>
        </xf:model>
    </head>
    <body>
        <a class="breadcrumb" href="../index.xhtml">Metadata Registry Home</a> &gt;
        <a class="breadcrumb" href="index.xhtml">Shopping Cart Home</a>
      
        <div class="search">
            <h1>Metadata Shopper</h1>
            <xf:input ref="instance('search-criteria')/string" incremental="true">
                <xf:label>Search:</xf:label>
            </xf:input>
            <xf:submit submission="search">
                <xf:label>Search</xf:label>
            </xf:submit>
            <xf:switch>
                <xf:case id="ready">
                    <!-- <xf:submit submission="echo-search-criteria">
                        <xf:label>Echo Search Criteria</xf:label>
                    </xf:submit> -->
                </xf:case>
                <xf:case id="case-busy">
                    <p>Waiting for response...</p>
                </xf:case>
                <xf:case id="case-submit-error">
                    <p>The server has returned a submit error event.</p>
                </xf:case>
                <xf:case id="case-done">
                
                    <div class="search-results">
                    <h3>Search Results:</h3>
                        <xf:repeat id="search-results-repeat" nodeset="instance('search-response')/DataElement">
                        <div class="result">
                             <xf:trigger>
                                <xf:label>Add</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:insert nodeset="instance('shopping-cart')/DataElement" at="last()" position="after"/>

                                    
                                    <!-- the nth one selected -->
                                    <xf:setvalue ref="instance('debug')/search-index" value="index('search-results-repeat')"/>
                                    <xf:setvalue ref="instance('debug')/item-to-add" value="instance('search-response')/DataElement[index('search-results-repeat')=position()]/DataElementName"/>
                                    
                                    
                                    <!-- set the last element in the cart to the selected item -->
                                    <xf:setvalue ref="instance('shopping-cart')/DataElement[last()]/DataElementName" value="instance('search-response')/DataElement[index('search-results-repeat')=position()]/DataElementName"/>
                                </xf:action>
                            </xf:trigger>
                            <div class="result-text">
                            <b>
                                <xf:output ref="DataElementName"/>
                            </b>
                            <i>
                                <xf:output ref="DataElementDefinitionText/text()"/>
                            </i>
                           </div>
                           </div>
                        </xf:repeat>
                    </div>
                </xf:case>
            </xf:switch>
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
        
          <div class="shopping-cart-sidebar">
            <img src="shopping-cart.jpg" height="50"/>
            <h3>Shopping Cart Contents:</h3>
            <ul>
                <xf:repeat id="shopping-cart-repeat" nodeset="instance('shopping-cart')/DataElement">
                    <li>
                        <xf:output value="concat(prefix,':', DataElementName)" class="url"/>
                        <!-- TODO figure out how to bind an output to a URL&lt;xf:output
                            value="concat(
                            'http://dlficsb501:8080/exist/rest/db/mdr/data-elements/views/view-data-element.xq?id=',
                            DataElementName,
                            prefix,':', DataElementName
                            )"
                        class="url" /&gt; -->
                    </li>
                </xf:repeat>
                <br/>
                <xf:input ref="instance('shopping-cart')/FileName">
                    <xf:label><b>Wantlist name:</b></xf:label>
                </xf:input>
                <xf:submit submission="save-wantlist">
                    <xf:label>Save Wantlist</xf:label>
                </xf:submit>
                <!-- 
                <xf:submit submission="echo-wantlist">
                    <xf:label>Echo Wantlist</xf:label>
                </xf:submit>
                -->
            </ul>
        </div>
    </body>
</html>
