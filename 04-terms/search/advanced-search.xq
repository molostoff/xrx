xquery version "1.0";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

(: Search all glossary terms by passing this xquery an string paramter on the URL:
   $hostname/db/apps/terms/search/advanced-search.xq?q=mystr&option=prefix&not=filter
   Author: Dan McCreary
   Date: 1-28-200
:)

let $collection :=  concat(substring-before(substring-after(request:get-uri(), '/exist/rest'), '/search/'), '/data')
let $string := request:get-parameter('q', "")
let $option := request:get-parameter('option', "")
let $not := request:get-parameter('not', "")

(: put the search results into memory :)
let $search-results := 
<terms>{ if ($option='exact')
   then
      collection($collection)/term[name=$string]
   else if ($option='prefix')
      then
          collection($collection)//term[starts-with(name, $string)]
      else
         collection($collection)//term[contains(name, $string)]
         }</terms>
 
let $filtered-search-results := if ($not) then $search-results/term[not(contains(name, $not))] else()
         
let $count := count($search-results/term)
let $count2 := count($filtered-search-results)

return
<html>
    <head>
       <title>AdvancedTerms Search Results - Advanced Search</title>
     </head>
     <body>
        <a class="breadcrumb" href="../../index.xhtml">Apps Home</a> &gt;
        <a class="breadcrumb" href="../index.xhtml">Terms</a>
        <h1>Terms Advanced Search Results</h1>
        <p><b>Search results for:</b>q=&quot;{$string}&quot;  option=&quot;{$option}&quot;  not=&quot;{$not}&quot; <b> In Collection: </b>{$collection}</p>
        <p><b>PreFilter Terms Found: </b>{$count} <b> Post Filter Terms Found: </b>{$count2}</p>
     <ol>{

if ($not)
then
      (: return all the terms in the post filtered results that match this query :)
         for $term in $filtered-search-results
            let $id := $term/name/@id
            let $name := $term/name/text()
            order by upper-case($name)
      return
         <li><a href="../views/view-item.xq?id={$id}">{$name}</a></li>
else
      (: find terms that in the pre-filter that mach this query  :)
         for $term in $search-results/term
            let $id := $term/name/@id
            let $name := $term/name/text()
            order by upper-case($name)
      return
         <li><a href="../views/view-item.xq?id={$id}">{$name}</a></li>

      }</ol>
      <a href="search.xhtml">New Simple Seach</a><a href="advanced-search.xhtml">New Advanced Seach</a>
   </body>
</html>