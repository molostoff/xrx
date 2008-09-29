xquery version "1.0";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

(: Search all terms by passing this xquery an query paramter q on the URL:
   $hostname/db/apps/terms/search/search.xq?q=mystr
:)

let $collection :=  concat(substring-before(substring-after(request:get-uri(), '/exist/rest'), '/search/'), '/data')
let $search-string := request:get-parameter('q', "")

(: put the search results into memory :)
let $search-results := collection($collection)//term[*/text() &= $search-string]
let $count := count($search-results)

return
<html>
    <head>
       <title>Term Search Results</title>
     </head>
     <body>
        <a class="breadcrumb" href="../../index.xhtml">Home</a> &gt;
        <a class="breadcrumb" href="../index.xhtml">Terms</a>  &gt;
        <a href="search.xhtml">New Seach</a>
        <br/>

        <h3>Term Search Results</h3>
        <p><b>Search results for:</b>&quot;{$search-string}&quot; <b> In Collection: </b>{$collection}</p>
        <p><b>Terms Found: </b>{$count}</p>
     <ol>{

   for $term in $search-results
      let $id := $term/name/@id
      let $term-name := $term/name/text()
      order by upper-case($term-name)
return
   <li><a href="../views/view-item.xq?id={$id}">{$term-name}</a></li>

      }</ol>
      <a href="search.xhtml">New Seach</a>

   </body>
</html>