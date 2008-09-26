xquery version "1.0";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=html media-type=text/html indent=yes";

let $collection :=  concat(substring-before(substring-after(request:get-uri(), '/exist/rest'), '/views/'), '/data')

(: remove the [1] if you want to display more than one defintion :)
(: you can replace it with string-join($term/definition/text()) :)

return
<html>
   <head>
      <title>HTML Table</title>
      <link rel="stylesheet" href="06-table.css" type="text/css"/>
   </head>
   <body>
   <div id="wrapper">
   <div id="banner">
        <img src="../hobanner.gif" width="900" height="130" alt="Office of the Historian banner"/>
   </div>
   <div class="content">
   
   <h4>Terms and Defintions</h4>
      <table>
         <thead>
            <th>Term</th>
            <th>Definition</th>
         </thead>
         <tbody>{
            for $term in subsequence(collection($collection)/term, 1, 30)
            return
            <tr>
                <td class="term">{$term/name/text()}</td>
                <td class="definition">{$term/definition[1]/text()}</td>
            </tr>
        }</tbody>
      </table>
      
   </div>
   <div id="footer"><p>Office of the Historian, Bureau of Public Affairs, <a href="http://www.state.gov">United States Department of State</a></p></div>
   </div>
   </body>
</html>

