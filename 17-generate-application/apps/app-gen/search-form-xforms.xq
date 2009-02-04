xquery version "1.0";
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
declare option exist:serialize "method=xhtml media-type=text/xml indent=yes";
<html xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xf="http://www.w3.org/2002/xforms"
   xmlns:ev="http://www.w3.org/2001/xml-events">
    <head>
        <title>Seach Items</title>
        {style:import-css()}
    </head>
    <xf:model>
        <xf:instance xmlns="">
            <data>
                <q/>
            </data>
        </xf:instance>
       <!-- this puts the input in the search field -->
        <xf:action ev:event="xforms-ready">
            <xf:setfocus control="search-field"/>
        </xf:action>
        <xf:submission id="search" method="get" action="search.xq" replace="all"/>
    </xf:model>
    <body>
       {style:header()}
       {style:breadcrumb()}
        <h2>Search Items</h2>
        <xf:input ref="q" id="search-field" incremental="true">
            <xf:label>Search:</xf:label>
            <!-- this makes the return perform a search -->
            <xf:action ev:event="DOMActivate">
                <xf:send submission="search"/>
            </xf:action>
        </xf:input>
        <xf:submit submission="search">
            <xf:label>Search</xf:label>
        </xf:submit>
        {style:footer()}
    </body>
</html>
