module namespace schema-to-svg='http://danmccreary.com/schema-to-svg';

declare function schema-to-svg:draw-element($x as xs:integer, $y as xs:integer, $name as xs:string, $optional as xs:boolean, 
   $cardinality as xs:string, $annotation as xs:string) as node() {
<g  transform="translate({$x} {$y})">
    <line x1="0" x2="10" y1="14" y2="14" stroke="black" stroke-width="2"/>
    <rect x="10" y="0" rx="5" ry="5" width="250" height="28" class="xsd-required"/>
    <text x="15" y="20" class="xsd-text">{$name}</text>
    <text x="15" y="45" class="annotation-text" fill="gray">{$cardinality}</text>
    <text x="20" y="60" class="annotation-text" fill="gray">{$annotation}</text>
</g>
};