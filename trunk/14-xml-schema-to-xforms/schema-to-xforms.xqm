

module namespace s2f='http://code.google.com/p/xrx/s2f';



(: XQuery module for transforming an XML Schema to an XForms application :)


(: if you what to change the styling you can put in your own module here.  It must have the following functions:
   style:import-css(),
   style:breadcrumb(),
   style:header(),
   style:footer()
:)
import module namespace style='http://code.google.com/p/xrx/style' at '/db/xrx/modules/style.xqm';

(: Note that many of these functions have the entire XML Schema $schema as the first argument.  We need
this whenever we can not predict where in the XML Schema the information is coming from :)

declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(: functions that are used to transform and XML Schema to XForms :)
(: note that this assumes an intance has been generated in {$schemas}/gen-xforms/{myform}-instance.xml :)

(: to use this point the $schema to the target XML Schema like this:
   let $schema := doc($path-to-schema-dir/my-schema.xsd)/xs:schema 
   
Known issues
   No support for include files yet
   Does not handle all typed elements
   Does not handle read-only (CSS file)
   Does not handle repitition
   Data types not complete
   Does not use ISO names and Representation Terms to guess the form type
   No support for metadata registry label lookups
   :)

(: Stub for given a element name, look up a the screen label from the metadata registry :)
declare function s2f:get-label-for-element-name($element-name as xs:string) {
(: if (exists(xrx:get-label-from-registry($element-name)) :)
  $element-name
};

declare function s2f:get-element-for-name($schema as node(), $element-name as xs:string) {
(: if (exists(xrx:get-label-from-registry($element-name)) :)
   $schema//xs:element[@name=$element-name]
};

declare function s2f:element-name-to-xforms-control($schema as node(), $element-name as xs:string) as node() {
(: FIXME: put in a lookup into a metadata registry to get a nice-looking data element label :)
(: xrx:get-label-for-element({$element-name}) :)
if (ends-with(lower-case($element-name), 'code'))
    then (
       let $element := s2f:get-element-for-name($schema, $element-name)
       return
          s2f:element-to-select1($element)
       )
    else
        <xf:input ref="{$element-name}" class="{$element-name}">
                 <xf:label>{$element-name} : </xf:label>
        </xf:input>
};

(: just a test function for testing XPath expressions - not used in the actual tranformation :)
declare function s2f:get-all-simple-elements($schema as node()) as item()* {
for $element in $schema//xs:element[not(*)]
   let $element-name := string($element/@name)
   let $type := string($element/@type)
return
<xf:input ref="{$element-name}" class="{$type}">
         <xf:label>{s2f:get-label-for-element-name(string($element/@name))} : </xf:label>
</xf:input>
};

(: recursive test function to process all complex elements in an XML Schema :)
declare function s2f:process-complex-element($complex-element as node()) as node() {
   let $element-name := concat(string($complex-element/@name), string($complex-element/@ref))
   return
    element {$element-name}
       {
       if ($complex-element/xs:complexType)
          then
             for $sub-element in $complex-element/xs:complexType/*/xs:element
               return
                  s2f:process-complex-element($sub-element)
          else ()
        }
};

(: Recursive function to process all complex elements in an XML Schema :)
(: this uses the fact that any XForms must set the context of the instance :)
(: Schema must be passed to allow ref lookups :)
(: complex-element is the current place we are looking up :)
declare function s2f:group-hier($schema as node(), $complex-element as node(), $base as xs:string) as node() {
   let $element-name := concat(string($complex-element/@name), string($complex-element/@ref))
   return
       (: if there are any complex types under this complex type - recurse:)
       if ($complex-element/xs:complexType)
          then
            if ($complex-element[@maxOccurs])
               then (
                  s2f:repeat($schema, $complex-element)
                  )
               else (
                  <xf:group ref="{concat($base, '/', $element-name)}">
                  <xf:label class="group-label">{$element-name}</xf:label>
                  {
                     for $sub-element in $complex-element/xs:complexType/*/xs:element
                       return
                          (s2f:group-hier($schema, $sub-element, concat($base, '/', $element-name))
                          )
                   }</xf:group>
               )
          else (s2f:element-name-to-xforms-control($schema, $element-name))
};


declare function s2f:required-binds($schema as node()) as node()* {
if (exists($schema//xs:element[not(@minOccurs='0') and not(xs:complexType)]))
  then (
      <!-- required fields -->,
      (: binds for required fields: any element that does NOT have a minOccurs = 0 or HAS a minOccurs over 1 :)
      for $element in $schema//xs:element[not(@minOccurs='0') and not(xs:complexType)]
          return
             <xf:bind nodeset="//{string($element/@name)}" required="true()"/>
     )
     else ()
};

(: If the element has a type="xs:date" or if the element name ends in "date" or "Date" or "DATE" then we bind
it to the date calendar selector. Note that dateTimes are never bound to a calendar selector.  :)
declare function s2f:date-binds($schema as node()) as node()*{
if (exists($schema//xs:element[@type="xs:date" or ends-with(lower-case(@name), 'date')]))
then (
   <!-- bindings for dates -->,
   for $element in $schema//xs:element[@type="xs:date" or ends-with(lower-case(@name), 'date')]
          return
             <xf:bind nodeset="//{string($element/@name)}" type="xs:date"/>
             )
   else ()
};

(: If the element has a type="xs:boolean" or if the element name ends in "indicator" or "Indicator" or "INDICATOR" then we bind
it to the input checkbox. Note that dateTimes are never bound to a calendar selector.  :)
declare function s2f:indicator-binds($schema as node()) as node()*{
if (exists($schema//xs:element[@type="xs:boolean" or ends-with(lower-case(@name), 'indicator')]))
then (
   <!-- bindings for dates -->,
   for $element in $schema//xs:element[@type="xs:boolean" or ends-with(lower-case(@name), 'indicator')]
          return
             <xf:bind nodeset="//{string($element/@name)}" type="xs:boolean"/>
    )
  else ()
};


(: Transform the element with enumerations to a select1 control :)
(: FIXME: lookup the value from the metadata registry to get a nice-looking label :)
declare function s2f:element-to-select1($element as node()) as node(){
   <xf:select1>
      <xf:label>{s2f:get-label-for-element-name(string($element/@name))}</xf:label>{
         for $enum in $element/xs:simpleType/xs:restriction/xs:enumeration
         return
            <xf:item>
               <xf:label>{string($enum/@value)}</xf:label>
               <xf:value>{string($enum/@value)}</xf:value>
            </xf:item>
   }</xf:select1>
};

(: create a list of conditional views instance for binding delete triggers :)
declare function s2f:conditional-views($schema as node()) as node()* {
if (exists($schema//xs:element[exists(@maxOccurs) and @maxOccurs != '1']))
  then (
        <!-- Instance to hold conditional view bindings. -->,
        <xf:instance id="views"  xmlns="" >
          <data>
           {(: Delete triggers we want to include if there are any @maxOccurs attributes and @maxOccurs != '1' :)
           for $element in $schema//xs:element[exists(@maxOccurs) and @maxOccurs != '1']
              return
                 element {concat(string($element/@name), '-delete-trigger')} {''}
           }
           
           {(: Add triggers we want to include if there are any @maxOccurs attributes @maxOccurs != 'unbounded' :)
           for $element in $schema//xs:element[exists(@maxOccurs) and @maxOccurs != 'unbounded']
              return
                 element {concat(string($element/@name), '-add-trigger')} {''}
           }
          </data>
        </xf:instance>
    )
    else ()
};

(: create a list of conditional views instance for binding delete triggers :)
declare function s2f:trigger-visability-bind-rules($schema as node()) as node()* {
if (exists($schema//xs:element[exists(@maxOccurs) and @maxOccurs != '1']))
then (
   (: conditionally put in some comment here :)
   <!-- binds for add/delete trigger visability -->,
   for $element in $schema//xs:element[exists(@maxOccurs) and @maxOccurs != '1']
      let $name := string($element/@name)
      let $min := string($element/@minOccurs)
      let $max := string($element/@maxOccurs)
      return
         <xf:bind
            id="{concat($name, '-delete-trigger')}"
            nodeset="instance('views')/{$name}-delete-trigger"
            relevent="instance('save-data')//{$name}[{$min}]" />
    (:,
   for $element in $schema//xs:element[exists(@maxOccurs) and @maxOccurs != '1']
      let $name := string($element/@name)
      let $min := string($element/@minOccurs)
      let $max := string($element/@maxOccurs)
      return
         <xf:bind id="{concat('bind-', $element, '-add-trigger')}" 
         nodeset="instance('views')/{$name}-add-trigger" 
         relevent="count(instance('save-data')//{$name} &gt $max" />
         :)
  ) 
  else ()
};

(: Generate a single XForms repeat structure for adding and deleting items from a sequence.
Should be called by the XForms driver every time it encounters an element with cardinality greater than one :)
declare function s2f:repeat($schema as node(), $element as node()) as node()* {
let $name := string($element/@name)
return
   <div class="repeat">
       <xf:repeat nodeset="instance('save-data')//{$name}" id="{$name}-repeat">
           {for $sub-element in $schema//xs:element[@name=$name]/xs:complexType/*/xs:element
             let $sub-element-name := string($sub-element/@name)
             return
             s2f:element-name-to-xforms-control($schema, $sub-element-name)
           }
           <xf:trigger bind="{$name}-delete-trigger">
               <xf:label>Delete</xf:label>
               <xf:delete nodeset="instance('save-data')//{$name}[index('{$name}-repeat')]" ev:event="DOMActivate"/>
           </xf:trigger>
       </xf:repeat>
       <!-- TODO put in rule for using the add trigger bind when maxOccurs is not unbounded bind="{$name}-add-trigger" -->
       <xf:trigger >
           <xf:label>Add {$name}</xf:label>
           <xf:action ev:event="DOMActivate">
              <xf:insert nodeset="instance('save-data')/{$name}" at="last()" position="after"/>
              <!-- this initialized the values of the phone number to null.  Can also use an origin attribute.   -->
              <xf:setvalue ref="/PersonPhones/Phone[index('{$name}-repeat')]/PhoneDescriptionText" value=""/>
              <xf:setvalue ref="/PersonPhones/Phone[index('{$name}-repeat')]/PhoneNumber" value=""/>
              <!-- this puts the cursor in the first field of the new row we just added -->
              <xf:setfocus control="PhoneDescriptionText"/>
           </xf:action>
       </xf:trigger>
    </div>
};

(: generate an XForms application using XRX app-info conventions from an XML Schema :)
declare function s2f:schema-to-xforms($schema as node(), $schema-name as xs:string) as node(){
  let $my-form := substring-before($schema-name, '.xsd')
  (: Using NIEM conventions we look for a first-level representation term with a suffix "Document" :)
  let $form-name := $schema/xs:schema/xs:element[ends-with(@name, 'Document')]/xs:annotation/xs:documentation/text()
  (: newline with to two or three tabs :)
  let $nl2ttt := '

            '
  let $nltt := '
        '
  let $nlttt := '
            '
return
<html
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xf="http://www.w3.org/2002/xforms"
   xmlns:ev="http://www.w3.org/2001/xml-events"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
>
 <head>
    <title>XForms application generated from constraint schema.</title>
    {style:import-css()}
    <xf:model>
         <!-- this instance holds the data we save -->
         <xf:instance xmlns="" id="save-data" src="/exist/rest/db/xrx/modules/test-input-instances/{$my-form}.xml"/>
         {$nl2ttt}
         {s2f:conditional-views($schema)}
         {$nl2ttt}
         {s2f:required-binds($schema)}
         {$nl2ttt}
         {s2f:date-binds($schema)}
         {$nl2ttt}
         {s2f:indicator-binds($schema)}
         {$nl2ttt}
         {s2f:trigger-visability-bind-rules($schema)}
         {$nlttt}
          
          <!-- <run xq="import-code-tables"/> -->
          <!-- put the server-side call to save your form data here using -->
         <xf:submission id="save" method="post" action="save-new.xq" instance="save-data"/>
      </xf:model>
 </head>
  <body>
     {style:header()}
     {style:breadcrumb()}
     <!-- start at the base and schema and generate all groups.  The second is the starting point. -->
     {s2f:group-hier($schema, $schema, '')}
   
      <xf:submit submission="save">
         <xf:label>Save</xf:label>
      </xf:submit>
      {style:footer()}
  </body>
</html>
 };