import module namespace m='http://www.tei-c.org/tei-simple/models/beamer.odd/fo' at '/db/apps/tei-simple/transform/beamer-print.xql';

declare variable $xml external;

declare variable $parameters external;

let $options := map {
    "styles": ["../transform/beamer.css"],
    "collection": "/db/apps/tei-simple/transform",
    "parameters": if (exists($parameters)) then $parameters else map {}
}
return m:transform($options, $xml)