xquery version "1.0";
import module namespace style='http://mdr.crossflow.com/style' at '/db/crossflo/modules/style.xq';
declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Application Template</title>
        {style:import-css()}
    </head>
    <body>
       {style:header()}
       {style:breadcrumb()}
       <h1>Appliction Template</h1>
       <p>Under Construction</p>
       <ol>
          <li>
             <a href="views/list-items.xq">List</a> List of Items
          </li>
          <li>
             <a href="edit/edit.xq?new=true">New</a> Create New Item
          </li>
          <li>
             <a href="search/search-form.xq">Search</a> Search Items
          </li>
          <li>
             <a href="views/metrics.xq">Metrics</a> Counts of various Items
          </li>
       </ol>
       {style:footer()}
    </body>
</html>