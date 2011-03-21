module namespace st='http://danmccreary.com/schema-typeswitch';

(: XML Schema Typeswitch Module :)
declare namespace xs = "http://www.w3.org/2001/XMLSchema";
declare default element namespace "http://www.w3.org/2001/XMLSchema";


declare function st:dispatch($node as node()) as item()* {
typeswitch($node)
    case text() return $node
    case element(element) return st:element($node)
    case element(schema) return st:schema($node)
    case element(complexType) return st:complexType($node)
    case element(sequence) return st:sequence($node)
    case element(choice) return st:choice($node)
    case element(any) return st:any($node)
    default return st:passthru($node)
};

declare function st:passthru($nodes as node()*) as item()* {
    for $node in $nodes/node() return st:dispatch($node)
};


declare function st:schema($node) as node() {
<svg width="100%" height="100%" version="1.1"
    xmlns="http://www.w3.org/2000/svg">
    <style type="text/css"><![CDATA[
        .xsd-text {font-size: 14pt;
              font-family: Arial, Helvetica, sans-serif;
         }
         
         .xsd-required, .xsd-optional {
              fill:yellow;
              stroke:black;
              stroke-width:2;
              opacity:0.8;
          }
          
          .xsd-required {
          }
          
          /* five pixels on and five off */
          .xsd-optional {
            stroke-dasharray: 10, 10;
            stroke-width:2;
          }
          
          .card-text {
            font-size: 10pt;
            font-family: Arial, Helvetica, sans-serif;
          }
          
          .annotation-text {
            font-size: 10pt;
            font-family: Arial, Helvetica, sans-serif;
          }
          
          
    ]]></style>
    {st:passthru($node/*)}
</svg>
};

declare function st:element($node as node()) as node() {
   st:element($node, 10, 0, $node/@name/string(), true(), '0..N', 'Annotation')
};

declare function st:element($node as node(), $x as xs:integer, $y as xs:integer, $name as xs:string, $optional as xs:boolean, 
   $cardinality as xs:string, $annotation as xs:string) as node() {
<g class="element" transform="translate({$x} {$y})">
    <line x1="0" x2="20" y1="14" y2="14" stroke="black" stroke-width="2"/>
    <rect x="10" y="0" rx="5" ry="5" width="250" height="28" class="xsd-required"/>
    <text x="15" y="20" class="xsd-text">{$name}</text>
    <text x="15" y="45" class="annotation-text" fill="gray">{$cardinality}</text>
    <text x="20" y="60" class="annotation-text" fill="gray">{$annotation}</text>
</g>
};

declare function st:complexType($node) as node() {
let $height := count($node/*/*) * 70
return
<g class="complexType" transform="translate(50, 0)"> 
   <line class="hline" x1="0" x2="20" y1="{$height div 2}" y2="{$height div 2}" stroke="black" stroke-width="2"/>
   <line class="hline" x1="80" x2="120" y1="{$height div 2}" y2="{$height div 2}" stroke="black" stroke-width="2"/> 
   
   <line class="vline" x1="120" x2="120" y1="0" y2="{$height}" stroke="black" stroke-width="2"/>
   <g transform="translate(100 0)">
      {st:dispatch($node/*)}
   </g>
</g>
};

declare function st:sequence($node as node()) as node() {
let $height := count($node/*) * 70
return
<g class="sequence">
    <g transform="translate(-80, {$height div 2 - 20})" class="sequence">
        <polygon points="0,10 10,0 50,0 60,10  60,40 50,50  10,50 0,40" fill="none" stroke="black" stroke-width="2"/>
        <circle fill="black" r="5" cx="15" cy="25"/>
        <circle fill="black" r="5" cx="30" cy="25"/>
        <circle fill="black" r="5" cx="45" cy="25"/>
        <line x1="2" y1="25" x2="58" y2="25" stroke="black"/>
    </g>
    <g transform="translate(40 0)">
    {for $ele at $count in $node/xs:element
          return
             st:element($ele, 20, $count * 70, $ele/@name/string(), true(), '0..N', 'Annotation')
     }
     </g>
</g>
};
    
declare function st:choice($node as node()) as node() {
<g transform="translate(50, 105)" class="choice">
    <polygon points="0,10 10,0 50,0 60,10  60,40 50,50  10,50 0,40" fill="none" stroke="black" stroke-width="2"/>
    <circle fill="black" r="5" cx="30" cy="12"/>
    <circle fill="black" r="5" cx="30" cy="25"/>
    <circle fill="black" r="5" cx="30" cy="38"/>
    <line x1="2" y1="25" x2="12" y2="25" stroke="black"/>
    <line x1="25" y1="25" x2="58" y2="25" stroke="black"/>
    <line x1="12" y1="25" x2="25" y2="12" stroke="black"/>
    <line x1="25" y1="12" x2="48" y2="12" stroke="black"/>
    <line x1="25" y1="38" x2="48" y2="38" stroke="black"/>
    <line x1="48" y1="12" x2="48" y2="38" stroke="black"/>
    {for $ele at $count in $node/xs:element
          return
             st:element($ele, 10, $count * 70, $ele/@name/string(), true(), '0..N', 'Annotation')
     }
</g>
};



declare function st:any($node as node()) as node() {
<g transform="translate(50, 190)" class="any">
    <polygon points="0,10 10,0 50,0 60,10  60,40 50,50  10,50 0,40"  fill="none" stroke="black" stroke-width="2"/>
    <circle fill="black" r="5" cx="30" cy="12"/>
    <circle fill="black" r="5" cx="30" cy="25"/>
    <circle fill="black" r="5" cx="30" cy="38"/>
    <line x1="2" y1="25" x2="58" y2="25" stroke="black"/>
    <line x1="12" y1="12" x2="48" y2="12" stroke="black"/>
    <line x1="12" y1="38" x2="48" y2="38" stroke="black"/>
    <line x1="12" y1="12" x2="12" y2="38" stroke="black"/>
    <line x1="48" y1="12" x2="48" y2="38" stroke="black"/>
    {for $ele at $count in $node/xs:element
          return
             st:element($ele, 10, $count * 70, $ele/@name/string(), true(), '0..N', 'Annotation')
     }
</g>
};

