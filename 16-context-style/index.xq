xquery version "1.0";
declare namespace style = "http://org-a.com/style";

(: sample HTML page that has a different module loaded based on content :)

(: import module namespace style = "http://org-a.com/style" at  "/db/cust/org-a/modules/style.xqm"; :)

declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";

(: util:import-module($a as xs:anyURI, $b as xs:string, $c as xs:anyURI) empty()
Dynamically imports an XQuery module into the current context. The namespace URI of the module is specified in argument $a, $b is the prefix that will be assigned to that namespace, $c is the location of the module. The parameters have the same meaning as in an 'import module ...' expression in the query prolog.
:)

let $org-style-dbpath := concat(xrx:org-collection(), 'modules/sytle.xqm'))


(: this code does not work yet.....:)
let $import-result := if (xrx:document-exists($org-style-dbpath)
   then (util:import-module("http://org-a.com/style", "style", $org-style-dbpath))
   else (util:import-module("http://code.google.com/p/xrx/style", "style", "/db/xrx/modules/style.xqm"))
   
(: Right now I have to uncomment one of of the following two lines to get this to get it to work :)

(: import module namespace style='http://org-a.com/style' at '/db/cust/org-a/modules/style.xqm'; :)
(: import module namespace style='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm'; :)
   
return 
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Style Test</title>
        {style:import-css()}
    </head>
    <body>
        {style:header()}
        {style:breadcrumb()}
        <h1>Style Test</h1>
        {style:footer()}
    </body>
</html>

