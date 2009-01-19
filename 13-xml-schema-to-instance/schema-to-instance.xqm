module namespace s2i='http://code.google.com/p/s2i';

declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(: XQuery module that converts an XML Schema into an instance :)

(: Todo
  Enumerations
  References
  Root Element Detection
  Root Element Parameter Passing
  Required and Optional
  Cardinality
  Add Paramters for min/max
  Add Parameter for required-only=true
:)

(: add n padding characters :)
declare function s2i:pad($string as xs:string, $char as xs:string, $max as xs:integer) as xs:string {
   concat(string-pad($char, $max - string-length($string)), $string)
};

(: add 2 padding characters :)
declare function s2i:pad2($string) {
   s2i:pad($string,"0",2)
};
 
declare function s2i:process-type($name)   {
(: just simple types - xs namespace :)
   if ($name = ("xs:string","xs:NMTOKEN","xs:NCName"))
   then 'string'
   
   else if ($name="xs:integer")
   then '5'
   
   else if ($name="xs:decimal")
   then '5.5'
   
   else  if ($name="xs:boolean")
   then 'true'
   
   else if ($name="xs:date")
   then '2009-01-01'
   
   else if ($name="xs:time")
   then '24:12:60'
   
   else if ($name="xs:dateTime")
   then '2009-01-01T24:12:60'
   
   else ('no type found')
};

(: $r is the count for repeated items :)
declare function s2i:process-element($element as node()*, $r as xs:positiveInteger) as node()*{
if (exists($element))
   then
     typeswitch ($element)
        case  element(xs:complexType) return 
              for $sub-element in  $element/*
                 return  s2i:process-element($sub-element, $r)
 
        case element(xs:annotation) return
            ()
                
        case element(xs:element) return
             if ($element/@ref)  
                then 
                  s2i:process-element(root($element)/xs:schema/xs:element[@name=$element/@ref], $r)
             else 
                if (root($element)/xs:schema/xs:complexType[@name=$element/@type]) 
                   then 
                       element {$element/@name} {                           
                       s2i:process-element(root($element)/xs:schema/xs:complexType[@name=$element/@type], $r)
                    }
                    else 
                        element {$element/@name} {                      
                         if  ($element/*)
                         then for $sub-element in $element/*
                                 return s2i:process-element($sub-element, $r)
                         else  s2i:process-type(($element/@type,"xs:string")[1])  
                    }
                    
           case element(xs:attribute) return
                 if ($element/@use="required")
                 then 
                     attribute {$element/@name} {
                         s2i:process-type($element/@type) 
                      }
                  else ()
 
           case element(xs:sequence) return
                 for $sub-element in $element/*
                       return s2i:process-element($sub-element, $r)
 
           case element(xs:all) return
                 for $sub-element  in $element/*
                 order by .5
                 return s2i:process-element($sub-element, $r)
 
           case element(xs:choice) return
                    let $first-choice := $element/*[1]
                    return s2i:process-element($first-choice, $r)
                    
          default return
                   ()
      else ()
};

(: recursive test function to process all complex elements in an XML Schema :)
declare function s2i:process-complex-element($complex-element as node()) as node() {
   let $element-name := concat(string($complex-element/@name), string($complex-element/@ref))
   return
    element {$complex-element/@name}
       {
       if ($complex-element/xs:complexType)
          then
             for $sub-element in $complex-element/xs:complexType/*/xs:element
               return
                    s2i:process-complex-element($sub-element)
          else ()
         }
};


(: return a the path to the root element of the document.

   Algorithm:
      If you get a path paramert, use that,
      else find the first element name that end with 'Document'
      else return the first element.  :)
declare function s2i:find-document-root($schema as node()) as node() {
  if (exists($schema/xs:schema/xs:element[ends-with(@name, 'Document')][1]))
    then ($schema/xs:schema/xs:element[ends-with(@name, 'Document')][1])
    else ($schema/xs:schema/xs:element[1])
};