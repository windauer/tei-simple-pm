(:~

    Transformation module generated from TEI ODD extensions for processing models.
    ODD: /db/apps/tei-simple/odd/compiled/teisimple.odd
 :)
xquery version "3.1";

module namespace model="http://www.tei-c.org/tei-simple/models/teisimple.odd/latex";

declare default element namespace "http://www.tei-c.org/ns/1.0";

declare namespace xhtml='http://www.w3.org/1999/xhtml';

declare namespace skos='http://www.w3.org/2004/02/skos/core#';

import module namespace css="http://www.tei-c.org/tei-simple/xquery/css" at "xmldb:exist://embedded-eXist-server/db/apps/tei-simple/content/css.xql";

import module namespace latex="http://www.tei-c.org/tei-simple/xquery/functions/latex" at "xmldb:exist://embedded-eXist-server/db/apps/tei-simple/content/latex-functions.xql";

import module namespace ext-latex="http://www.tei-c.org/tei-simple/xquery/ext-latex" at "xmldb:exist://embedded-eXist-server/db/apps/tei-simple/content/../modules/ext-latex.xql";

(:~

    Main entry point for the transformation.
    
 :)
declare function model:transform($options as map(*), $input as node()*) {
        
    let $config :=
        map:new(($options,
            map {
                "output": ["latex","print"],
                "odd": "/db/apps/tei-simple/odd/compiled/teisimple.odd",
                "apply": model:apply#2,
                "apply-children": model:apply-children#3
            }
        ))
    let $config := latex:init($config, $input)
    
    return (
        
        model:apply($config, $input)
    )
};

declare function model:apply($config as map(*), $input as node()*) {
    let $parameters := 
        if (exists($config?parameters)) then $config?parameters else map {}
    return
    $input !         (
            typeswitch(.)
                case element(ab) return
                    latex:paragraph($config, ., ("tei-ab"), .)
                case element(abbr) return
                    latex:inline($config, ., ("tei-abbr"), .)
                case element(actor) return
                    latex:inline($config, ., ("tei-actor"), .)
                case element(add) return
                    latex:inline($config, ., ("tei-add"), .)
                case element(address) return
                    latex:block($config, ., ("tei-address"), .)
                case element(addrLine) return
                    latex:block($config, ., ("tei-addrLine"), .)
                case element(addSpan) return
                    latex:anchor($config, ., ("tei-addSpan"), ., @xml:id)
                case element(am) return
                    latex:inline($config, ., ("tei-am"), .)
                case element(anchor) return
                    latex:anchor($config, ., ("tei-anchor"), ., @xml:id)
                case element(argument) return
                    latex:block($config, ., ("tei-argument"), .)
                case element(back) return
                    latex:block($config, ., ("tei-back"), .)
                case element(bibl) return
                    if (parent::listBibl) then
                        latex:listItem($config, ., ("tei-bibl1"), .)
                    else
                        latex:inline($config, ., ("tei-bibl2"), .)
                case element(body) return
                    (
                        latex:index($config, ., ("tei-body1"), ., 'toc'),
                        latex:block($config, ., ("tei-body2"), .)
                    )

                case element(byline) return
                    latex:block($config, ., ("tei-byline"), .)
                case element(c) return
                    latex:inline($config, ., ("tei-c"), .)
                case element(castGroup) return
                    if (child::*) then
                        (: Insert list. :)
                        latex:list($config, ., ("tei-castGroup"), castItem|castGroup)
                    else
                        $config?apply($config, ./node())
                case element(castItem) return
                    (: Insert item, rendered as described in parent list rendition. :)
                    latex:listItem($config, ., ("tei-castItem"), .)
                case element(castList) return
                    if (child::*) then
                        latex:list($config, ., css:get-rendition(., ("tei-castList")), castItem)
                    else
                        $config?apply($config, ./node())
                case element(cb) return
                    latex:break($config, ., ("tei-cb"), ., 'column', @n)
                case element(cell) return
                    (: Insert table cell. :)
                    latex:cell($config, ., ("tei-cell"), ., ())
                case element(choice) return
                    if (sic and corr) then
                        latex:alternate($config, ., ("tei-choice4"), ., corr[1], sic[1])
                    else
                        if (abbr and expan) then
                            latex:alternate($config, ., ("tei-choice5"), ., expan[1], abbr[1])
                        else
                            if (orig and reg) then
                                latex:alternate($config, ., ("tei-choice6"), ., reg[1], orig[1])
                            else
                                $config?apply($config, ./node())
                case element(cit) return
                    if (child::quote and child::bibl) then
                        (: Insert citation :)
                        latex:cit($config, ., ("tei-cit"), .)
                    else
                        $config?apply($config, ./node())
                case element(closer) return
                    latex:block($config, ., ("tei-closer"), .)
                case element(corr) return
                    if (parent::choice and count(parent::*/*) gt 1) then
                        (: simple inline, if in parent choice. :)
                        latex:inline($config, ., ("tei-corr1"), .)
                    else
                        latex:inline($config, ., ("tei-corr2"), .)
                case element(date) return
                    if (text()) then
                        latex:inline($config, ., ("tei-date1"), .)
                    else
                        if (@when and not(text())) then
                            latex:inline($config, ., ("tei-date2"), @when)
                        else
                            if (text()) then
                                latex:inline($config, ., ("tei-date4"), .)
                            else
                                $config?apply($config, ./node())
                case element(dateline) return
                    latex:block($config, ., ("tei-dateline"), .)
                case element(del) return
                    latex:inline($config, ., ("tei-del"), .)
                case element(desc) return
                    latex:inline($config, ., ("tei-desc"), .)
                case element(div) return
                    if (@type='title_page') then
                        latex:block($config, ., ("tei-div1"), .)
                    else
                        if (parent::body or parent::front or parent::back) then
                            latex:section($config, ., ("tei-div2"), .)
                        else
                            latex:block($config, ., ("tei-div3"), .)
                case element(docAuthor) return
                    if (ancestor::teiHeader) then
                        (: Omit if located in teiHeader. :)
                        latex:omit($config, ., ("tei-docAuthor1"), .)
                    else
                        latex:inline($config, ., ("tei-docAuthor2"), .)
                case element(docDate) return
                    if (ancestor::teiHeader) then
                        (: Omit if located in teiHeader. :)
                        latex:omit($config, ., ("tei-docDate1"), .)
                    else
                        latex:inline($config, ., ("tei-docDate2"), .)
                case element(docEdition) return
                    if (ancestor::teiHeader) then
                        (: Omit if located in teiHeader. :)
                        latex:omit($config, ., ("tei-docEdition1"), .)
                    else
                        latex:inline($config, ., ("tei-docEdition2"), .)
                case element(docImprint) return
                    if (ancestor::teiHeader) then
                        (: Omit if located in teiHeader. :)
                        latex:omit($config, ., ("tei-docImprint1"), .)
                    else
                        latex:inline($config, ., ("tei-docImprint2"), .)
                case element(docTitle) return
                    if (ancestor::teiHeader) then
                        (: Omit if located in teiHeader. :)
                        latex:omit($config, ., ("tei-docTitle1"), .)
                    else
                        latex:block($config, ., css:get-rendition(., ("tei-docTitle2")), .)
                case element(epigraph) return
                    latex:block($config, ., ("tei-epigraph"), .)
                case element(ex) return
                    latex:inline($config, ., ("tei-ex"), .)
                case element(expan) return
                    latex:inline($config, ., ("tei-expan"), .)
                case element(figDesc) return
                    latex:inline($config, ., ("tei-figDesc"), .)
                case element(figure) return
                    if (head) then
                        latex:figure($config, ., ("tei-figure1"), *[not(self::head)], head/node())
                    else
                        latex:block($config, ., ("tei-figure2"), .)
                case element(floatingText) return
                    latex:block($config, ., ("tei-floatingText"), .)
                case element(foreign) return
                    latex:inline($config, ., ("tei-foreign"), .)
                case element(formula) return
                    if (@rendition='simple:display') then
                        latex:block($config, ., ("tei-formula1"), .)
                    else
                        latex:inline($config, ., ("tei-formula2"), .)
                case element(front) return
                    latex:block($config, ., ("tei-front"), .)
                case element(fw) return
                    if (ancestor::p or ancestor::ab) then
                        latex:inline($config, ., ("tei-fw1"), .)
                    else
                        latex:block($config, ., ("tei-fw2"), .)
                case element(g) return
                    if (not(text())) then
                        latex:glyph($config, ., ("tei-g1"), .)
                    else
                        latex:inline($config, ., ("tei-g2"), .)
                case element(gap) return
                    if (desc) then
                        latex:inline($config, ., ("tei-gap1"), .)
                    else
                        if (@extent) then
                            latex:inline($config, ., ("tei-gap2"), @extent)
                        else
                            latex:inline($config, ., ("tei-gap3"), .)
                case element(gi) return
                    latex:inline($config, ., ("tei-gi"), .)
                case element(graphic) return
                    latex:graphic($config, ., ("tei-graphic"), ., @url, @width, @height, @scale, desc)
                case element(group) return
                    latex:block($config, ., ("tei-group"), .)
                case element(handShift) return
                    latex:inline($config, ., ("tei-handShift"), .)
                case element(head) return
                    if (parent::figure) then
                        latex:block($config, ., ("tei-head1"), .)
                    else
                        if (parent::table) then
                            latex:block($config, ., ("tei-head2"), .)
                        else
                            if (parent::lg) then
                                latex:block($config, ., ("tei-head3"), .)
                            else
                                if (parent::list) then
                                    latex:block($config, ., ("tei-head4"), .)
                                else
                                    if (parent::div) then
                                        latex:heading($config, ., ("tei-head5"), .)
                                    else
                                        latex:block($config, ., ("tei-head6"), .)
                case element(hi) return
                    if (@rendition) then
                        latex:inline($config, ., css:get-rendition(., ("tei-hi1")), .)
                    else
                        if (not(@rendition)) then
                            latex:inline($config, ., ("tei-hi2"), .)
                        else
                            $config?apply($config, ./node())
                case element(imprimatur) return
                    latex:block($config, ., ("tei-imprimatur"), .)
                case element(item) return
                    latex:listItem($config, ., ("tei-item"), .)
                case element(l) return
                    latex:block($config, ., css:get-rendition(., ("tei-l")), .)
                case element(label) return
                    latex:inline($config, ., ("tei-label"), .)
                case element(lb) return
                    latex:break($config, ., css:get-rendition(., ("tei-lb")), ., 'line', @n)
                case element(lg) return
                    latex:block($config, ., ("tei-lg"), .)
                case element(list) return
                    if (@rendition) then
                        latex:list($config, ., css:get-rendition(., ("tei-list1")), item)
                    else
                        if (not(@rendition)) then
                            latex:list($config, ., ("tei-list2"), item)
                        else
                            $config?apply($config, ./node())
                case element(listBibl) return
                    if (bibl) then
                        latex:list($config, ., ("tei-listBibl1"), bibl)
                    else
                        latex:block($config, ., ("tei-listBibl2"), .)
                case element(measure) return
                    latex:inline($config, ., ("tei-measure"), .)
                case element(milestone) return
                    latex:inline($config, ., ("tei-milestone"), .)
                case element(name) return
                    latex:inline($config, ., ("tei-name"), .)
                case element(note) return
                    if (@place) then
                        latex:note($config, ., ("tei-note1"), ., @place, @n)
                    else
                        if (parent::div and not(@place)) then
                            latex:block($config, ., ("tei-note2"), .)
                        else
                            if (not(@place)) then
                                latex:inline($config, ., ("tei-note3"), .)
                            else
                                $config?apply($config, ./node())
                case element(num) return
                    latex:inline($config, ., ("tei-num"), .)
                case element(opener) return
                    latex:block($config, ., ("tei-opener"), .)
                case element(orig) return
                    latex:inline($config, ., ("tei-orig"), .)
                case element(p) return
                    latex:paragraph($config, ., css:get-rendition(., ("tei-p")), .)
                case element(pb) return
                    latex:break($config, ., css:get-rendition(., ("tei-pb")), ., 'page', (concat(if(@n) then     concat(@n,' ') else '',if(@facs) then     concat('@',@facs) else '')))
                case element(pc) return
                    latex:inline($config, ., ("tei-pc"), .)
                case element(postscript) return
                    latex:block($config, ., ("tei-postscript"), .)
                case element(q) return
                    if (l) then
                        latex:block($config, ., css:get-rendition(., ("tei-q1")), .)
                    else
                        if (ancestor::p or ancestor::cell) then
                            latex:inline($config, ., css:get-rendition(., ("tei-q2")), .)
                        else
                            latex:block($config, ., css:get-rendition(., ("tei-q3")), .)
                case element(quote) return
                    if (ancestor::p) then
                        (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                        latex:inline($config, ., css:get-rendition(., ("tei-quote1")), .)
                    else
                        (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                        latex:block($config, ., css:get-rendition(., ("tei-quote2")), .)
                case element(ref) return
                    if (not(@target)) then
                        latex:inline($config, ., ("tei-ref1"), .)
                    else
                        if (not(text())) then
                            latex:link($config, ., ("tei-ref2"), @target, @target)
                        else
                            latex:link($config, ., ("tei-ref3"), ., @target)
                case element(reg) return
                    latex:inline($config, ., ("tei-reg"), .)
                case element(rhyme) return
                    latex:inline($config, ., ("tei-rhyme"), .)
                case element(role) return
                    latex:block($config, ., ("tei-role"), .)
                case element(roleDesc) return
                    latex:block($config, ., ("tei-roleDesc"), .)
                case element(row) return
                    if (@role='label') then
                        latex:row($config, ., ("tei-row1"), .)
                    else
                        (: Insert table row. :)
                        latex:row($config, ., ("tei-row2"), .)
                case element(rs) return
                    latex:inline($config, ., ("tei-rs"), .)
                case element(s) return
                    latex:inline($config, ., ("tei-s"), .)
                case element(salute) return
                    if (parent::closer) then
                        latex:inline($config, ., ("tei-salute1"), .)
                    else
                        latex:block($config, ., ("tei-salute2"), .)
                case element(seg) return
                    latex:inline($config, ., css:get-rendition(., ("tei-seg")), .)
                case element(sic) return
                    if (parent::choice and count(parent::*/*) gt 1) then
                        latex:inline($config, ., ("tei-sic1"), .)
                    else
                        latex:inline($config, ., ("tei-sic2"), .)
                case element(signed) return
                    if (parent::closer) then
                        latex:block($config, ., ("tei-signed1"), .)
                    else
                        latex:inline($config, ., ("tei-signed2"), .)
                case element(sp) return
                    latex:block($config, ., ("tei-sp"), .)
                case element(space) return
                    latex:inline($config, ., ("tei-space"), .)
                case element(speaker) return
                    latex:block($config, ., ("tei-speaker"), .)
                case element(spGrp) return
                    latex:block($config, ., ("tei-spGrp"), .)
                case element(stage) return
                    latex:block($config, ., ("tei-stage"), .)
                case element(subst) return
                    latex:inline($config, ., ("tei-subst"), .)
                case element(supplied) return
                    if (parent::choice) then
                        latex:inline($config, ., ("tei-supplied1"), .)
                    else
                        if (@reason='damage') then
                            latex:inline($config, ., ("tei-supplied2"), .)
                        else
                            if (@reason='illegible' or not(@reason)) then
                                latex:inline($config, ., ("tei-supplied3"), .)
                            else
                                if (@reason='omitted') then
                                    latex:inline($config, ., ("tei-supplied4"), .)
                                else
                                    latex:inline($config, ., ("tei-supplied5"), .)
                case element(table) return
                    latex:table($config, ., ("tei-table"), .)
                case element(profileDesc) return
                    latex:omit($config, ., ("tei-profileDesc"), .)
                case element(revisionDesc) return
                    latex:omit($config, ., ("tei-revisionDesc"), .)
                case element(encodingDesc) return
                    latex:omit($config, ., ("tei-encodingDesc"), .)
                case element(teiHeader) return
                    latex:metadata($config, ., ("tei-teiHeader1"), .)
                case element(author) return
                    if (ancestor::teiHeader) then
                        latex:block($config, ., ("tei-author1"), .)
                    else
                        latex:inline($config, ., ("tei-author2"), .)
                case element(availability) return
                    latex:block($config, ., ("tei-availability"), .)
                case element(edition) return
                    if (ancestor::teiHeader) then
                        latex:block($config, ., ("tei-edition"), .)
                    else
                        $config?apply($config, ./node())
                case element(idno) return
                    latex:omit($config, ., ("tei-idno2"), .)
                case element(publicationStmt) return
                    (
                        latex:paragraph($config, ., ("tei-publicationStmt1"), (publisher,pubPlace)),
                        latex:heading($config, ., ("tei-publicationStmt2"), 'Identifiers'),
                        latex:table($config, ., ("tei-publicationStmt3"), idno),
                        latex:paragraph($config, ., ("tei-publicationStmt4"), availability)
                    )

                case element(publisher) return
                    latex:inline($config, ., ("tei-publisher"), .)
                case element(pubPlace) return
                    latex:inline($config, ., ("tei-pubPlace"), .)
                case element(seriesStmt) return
                    latex:block($config, ., ("tei-seriesStmt"), .)
                case element(fileDesc) return
                    if ($parameters?header='short') then
                        (
                            latex:block($config, ., ("tei-fileDesc1", "header-short"), titleStmt),
                            latex:block($config, ., ("tei-fileDesc2", "header-short"), editionStmt)
                        )

                    else
                        (
                            latex:block($config, ., ("tei-fileDesc1"), titleStmt),
                            latex:block($config, ., ("tei-fileDesc2"), seriesStmt),
                            latex:paragraph($config, ., ("tei-fileDesc3"), editionStmt),
                            latex:block($config, ., ("tei-fileDesc5"), publicationStmt)
                        )

                case element(titleStmt) return
                    (: No function found for behavior: meta :)
                    $config?apply($config, ./node())
                case element(TEI) return
                    latex:document($config, ., ("tei-TEI"), .)
                case element(text) return
                    latex:body($config, ., ("tei-text"), .)
                case element(time) return
                    latex:inline($config, ., ("tei-time"), .)
                case element(title) return
                    if ($parameters?header='short') then
                        latex:heading($config, ., ("tei-title1"), .)
                    else
                        if (parent::titleStmt/parent::fileDesc) then
                            (
                                if (preceding-sibling::title) then
                                    latex:text($config, ., ("tei-title1"), ' — ')
                                else
                                    (),
                                latex:inline($config, ., ("tei-title2"), .)
                            )

                        else
                            if (not(@level) and parent::bibl) then
                                latex:inline($config, ., ("tei-title2"), .)
                            else
                                if (@level='m' or not(@level)) then
                                    (
                                        latex:inline($config, ., ("tei-title1"), .),
                                        if (ancestor::biblStruct or       ancestor::biblFull) then
                                            latex:text($config, ., ("tei-title2"), ', ')
                                        else
                                            ()
                                    )

                                else
                                    if (@level='s' or @level='j') then
                                        (
                                            latex:inline($config, ., ("tei-title1"), .),
                                            if (following-sibling::* and     (ancestor::biblStruct  or     ancestor::biblFull)) then
                                                latex:text($config, ., ("tei-title2"), ', ')
                                            else
                                                ()
                                        )

                                    else
                                        if (@level='u' or @level='a') then
                                            (
                                                latex:inline($config, ., ("tei-title1"), .),
                                                if (following-sibling::* and     (ancestor::biblStruct  or     ancestor::biblFull)) then
                                                    latex:text($config, ., ("tei-title2"), '. ')
                                                else
                                                    ()
                                            )

                                        else
                                            latex:inline($config, ., ("tei-title3"), .)
                case element(titlePage) return
                    latex:block($config, ., css:get-rendition(., ("tei-titlePage")), .)
                case element(titlePart) return
                    latex:block($config, ., css:get-rendition(., ("tei-titlePart")), .)
                case element(trailer) return
                    latex:block($config, ., ("tei-trailer"), .)
                case element(unclear) return
                    latex:inline($config, ., ("tei-unclear"), .)
                case element(w) return
                    latex:inline($config, ., ("tei-w"), .)
                case element() return
                    if (namespace-uri(.) = 'http://www.tei-c.org/ns/1.0') then
                        $config?apply($config, ./node())
                    else
                        .
                case text() | xs:anyAtomicType return
                    latex:escapeChars(.)
                default return 
                    $config?apply($config, ./node())

        )

};

declare function model:apply-children($config as map(*), $node as element(), $content as item()*) {
        
    $content ! (
        typeswitch(.)
            case element() return
                if (. is $node) then
                    $config?apply($config, ./node())
                else
                    $config?apply($config, .)
            default return
                latex:escapeChars(.)
    )
};

