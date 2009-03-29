import module namespace xrx ='http://code.google.com/p/xrx' at '/db/xrx/modules/xrx.xqm';
import module namespace style ='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';
import module namespace s2i='http://code.google.com/p/xrx/s2i' at '/db/xrx/modules/schema-to-instance.xqm';

declare namespace xdb="http://exist-db.org/xquery/xmldb";
declare namespace xs = "http://www.w3.org/2001/XMLSchema";

declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";

(: set this to be a collection that contains your test XML Schemas :)
let $schema-collection := '/db/xrx/modules/test-input-schemas'
let $input-xml-schema := request:get-parameter("schema", "")
let $schema-path := request:get-parameter("schema-path", concat($schema-collection, '/', $input-xml-schema))
return
<html>
   <head>
      <title>Test Driver for XML Schema to XForms XRX Module Repeats</title>
      {style:import-css()}
    </head>
    <body>
       {style:header()}
       {style:breadcrumb()}      
       <h3>XML Schema To XForms Test Driver for Repeats</h3>
       <p>Sort Latest Modified</p>
       <table>
        <thead>
           <tr>
              <th>File Name</th>
              <th>Created</th>
              <th>Modified</th>
              <th>Instance</th>
              <th>Find Root</th>
              <th>ComplexTypes</th>
              <th>Generate XForms</th>
              <th>XML Schema</th>
           </tr>
        </thead>
        <tbody>{
        for $child in xdb:get-child-resources($schema-collection)
          let $created := substring(string(xdb:created($schema-collection, $child)), 1, 10)
          let $modified := substring(string(xdb:last-modified($schema-collection, $child)), 1, 10)
          let $schema-path := concat($schema-collection,  '/', $child)
          let $schema-webroot-path := concat('/exist/rest', $schema-path)
          let $schema := doc($schema-path)/xs:schema
          order by $child
          return
            <tr>
                <td>{$child}</td>
                <td>{$created}</td>
                <td>{$modified}</td>
                <td><a href="schema-to-instance.xq?schema-path={$schema-path}">Instance</a></td>
                <td><a href="find-root-test.xq?schema-path={$schema-path}">Find Root</a></td>
                <td><a href="schema-recursion.xq?schema-path={$schema-path}">ComplexTypes</a></td>
                <td><a href="schema-to-xforms.xq?schema-path={$schema-path}">Generate XForms</a></td>
                <td><a href="{$schema-webroot-path}">XML Schema</a></td>
            </tr>
        }</tbody>
      </table>
      {style:footer()}
   </body>
</html>

