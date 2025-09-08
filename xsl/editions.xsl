<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output encoding="UTF-8" media-type="text/xml" method="xml" indent="yes" omit-xml-declaration="yes"/>
    
     
    
<xsl:template match="/">
        <xsl:variable name="original-file" select="//tei:titleStmt/tei:title[1]/text()"/>
        <xsl:variable name="formatted-file">
            <xsl:call-template name="format-filename">
                <xsl:with-param name="filename" select="$original-file"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:result-document href="{$formatted-file}.xml" method="xml">
            <xsl:text disable-output-escaping='yes'>&lt;?xml version="1.0" encoding="UTF-8"?&gt;</xsl:text>
            <xsl:copy>
                <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="format-filename">
        <xsl:param name="filename"/>
        <xsl:variable name="no-spaces" select="translate($filename, ' ', '')"/>
        
        <!-- Check if filename ends with numbers -->
        <xsl:choose>
            <xsl:when test="matches($no-spaces, '^Hanslick.*\d+$')">
                <!-- Extract the trailing numbers -->
                <xsl:variable name="numbers" select="replace($no-spaces, '^Hanslick.*?(\d+)$', '$1')"/>
                <!-- Extract the middle part (everything after Hanslick and before the numbers) -->
                <xsl:variable name="middle-part" select="replace($no-spaces, '^Hanslick(.*?)(\d+)$', '$1')"/>
                <xsl:value-of select="concat('Hanslick_', $middle-part, '_', $numbers)"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- No trailing numbers, just add underscore after Hanslick -->
                <xsl:choose>
                    <xsl:when test="starts-with($no-spaces, 'Hanslick')">
                        <xsl:variable name="after-hanslick" select="substring-after($no-spaces, 'Hanslick')"/>
                        <xsl:value-of select="concat('Hanslick_', $after-hanslick)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$no-spaces"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

   


<xsl:template match="tei:publicationStmt">
        <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
            <publisher>Austrian Centre for Digital Humanities and Cultural Heritage</publisher>
            <pubPlace>Wien</pubPlace>
            <date when="2025">2025</date>
            <availability>
                <licence target="https://creativecommons.org/licenses/by/4.0">
                    <p>Sie dürfen: Teilen — das Material in jedwedem Format oder Medium
                        vervielfältigen und weiterverbreiten</p>
                    <p>Bearbeiten — das Material remixen, verändern und darauf aufbauen und zwar für
                        beliebige Zwecke, sogar kommerziell.</p>
                    <p>Der Lizenzgeber kann diese Freiheiten nicht widerrufen solange Sie sich an die
                        Lizenzbedingungen halten. Unter folgenden Bedingungen:</p>
                    <p>Namensnennung — Sie müssen angemessene Urheber- und Rechteangaben machen, einen
                        Link zur Lizenz beifügen und angeben, ob Änderungen vorgenommen wurden. Diese
                        Angaben dürfen in jeder angemessenen Art und Weise gemacht werden, allerdings
                        nicht so, dass der Eindruck entsteht, der Lizenzgeber unterstütze gerade Sie
                        oder Ihre Nutzung besonders.</p>
                    <p>Keine weiteren Einschränkungen — Sie dürfen keine zusätzlichen Klauseln oder
                        technische Verfahren einsetzen, die anderen rechtlich irgendetwas untersagen,
                        was die Lizenz erlaubt.</p>
                    <p>Hinweise:</p>
                    <p>Sie müssen sich nicht an diese Lizenz halten hinsichtlich solcher Teile des
                        Materials, die gemeinfrei sind, oder soweit Ihre Nutzungshandlungen durch
                        Ausnahmen und Schranken des Urheberrechts gedeckt sind.</p>
                    <p>Es werden keine Garantien gegeben und auch keine Gewähr geleistet. Die Lizenz
                        verschafft Ihnen möglicherweise nicht alle Erlaubnisse, die Sie für die
                        jeweilige Nutzung brauchen. Es können beispielsweise andere Rechte wie
                        Persönlichkeits- undDatenschutzrechte zu beachten sein, die Ihre Nutzung des
                        Materials entsprechend beschränken.</p>
                </licence>
            </availability>
        </publicationStmt>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="node()|@*"/>
            <encodingDesc>
                <tagsDecl>
                    <rendition xml:id="em" scheme="css" selector="hi">font-style:italic;</rendition>
                    <rendition xml:id="bold" scheme="css" selector="hi">font-weight:bold;</rendition>
                </tagsDecl>
                <!--<listPrefixDef>
                    <prefixDef ident="hsl" matchPattern="(.+)" replacementPattern="https://id.acdh.oeaw.ac.at/hsl-online/$1">
                        <p>Editionsregister</p>
                    </prefixDef>
                    <prefixDef ident="wrk" matchPattern="(.+)" replacementPattern="https://id.acdh.oeaw.ac.at/hsl-online/register/werke.xml#$1">
                        <p>Werkverzeichnis</p>
                    </prefixDef>
                    <prefixDef ident="prs" matchPattern="(.+)" replacementPattern="https://id.acdh.oeaw.ac.at/hsl-online/register/personen.xml#$1">
                        <p>Personenregister</p>
                    </prefixDef>
                    <prefixDef ident="plc" matchPattern="(.+)" replacementPattern="https://id.acdh.oeaw.ac.at/hsl-online/register/orte.xml#$1">
                        <p>Ortsregister</p>
                    </prefixDef>
                </listPrefixDef>-->
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="de">Deutsch</language>
                </langUsage>
            </profileDesc>
            <revisionDesc status="draft">
                <change who="kbamer ampfiel" when="2023-02-20">Transkribus OCR und Lektorat.</change>
                <change who="delsner" when="2023-02-20">Transformierung der Daten des Transkribus TEI-Export mit "editions.xsl".</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
    
    <xsl:template match="tei:seriesStmt">
        <xsl:copy>
            <p xmlns="http://www.tei-c.org/ns/1.0">Maschinenlesbares Transkript der Kritiken von Eduard Hanslick.</p>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc">
        <xsl:copy>
            <listBibl xmlns="http://www.tei-c.org/ns/1.0">
                <biblStruct xmlns="http://www.tei-c.org/ns/1.0">
                    <analytic xmlns="http://www.tei-c.org/ns/1.0">
                        <title xmlns="http://www.tei-c.org/ns/1.0">
                            <xsl:value-of select="normalize-space((//tei:titleStmt/tei:title[@type='main'])[1])"/>
                        </title>
                        <author xmlns="http://www.tei-c.org/ns/1.0" ref=""/>
                    </analytic>
                    <monogr xmlns="http://www.tei-c.org/ns/1.0">
                        <title type="main"></title>
                        <title type="sub"><xsl:value-of select="//tei:body/tei:div/tei:ab[1]//text()"/></title>
                        <respStmt>
                            <resp></resp>
                            <name type="person"></name>
                        </respStmt>
                        <imprint>
                            <pubPlace><xsl:value-of select="//tei:body/tei:div/tei:ab[2]/tei:rs[@type='place']"/></pubPlace>
                            <date when="{//tei:body/tei:div/tei:ab[2]/tei:date}"><xsl:value-of select="//tei:body/tei:div/tei:ab[2]/tei:date"/></date>
                        </imprint>
                    </monogr>
                </biblStruct>
            </listBibl>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:titleStmt">
        <titleStmt xmlns="http://www.tei-c.org/ns/1.0">
            <title level="s">Hanslick Edition: Dokumente zu „Vom Musikalisch-Schönen“</title>
            <xsl:choose>
                <xsl:when test="//tei:title[@type='main']">
                    <title level="a">
                        <!-- Take only the first title and normalize it -->
                        <xsl:value-of select="normalize-space((//tei:title[@type='main'])[1])"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <!-- fallback to previous logic if no main title found -->
                    <title level="a">
                        <xsl:value-of select="normalize-space((//tei:ab[2])[1])"/>
                    </title>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Add standard project author/editor/funder if they don't exist -->
            <xsl:if test="not(tei:author)">
                <author ref="#hsl_person_id_1">Hanslick, Eduard</author>
            </xsl:if>
            <xsl:if test="not(tei:editor)">
                <editor>
                    <name ref="https://orcid.org/0000-0002-0117-3574">Wilfing, Alexander</name>
                </editor>
            </xsl:if>
            <xsl:if test="not(tei:funder)">
                <funder>
                    <name>FWF Der Wissenschaftsfond.</name>
                    <address>
                        <street>Georg-Coch-Platz 2</street>
                        <postCode>1010 Wien</postCode>
                        <placeName>
                            <country>Österreich</country>
                            <settlement>Wien</settlement>
                        </placeName>
                    </address>
                </funder>
            </xsl:if>
            <!-- Apply templates to all non-title children to preserve them -->
            <xsl:apply-templates select="node()[not(self::tei:title)]"/>
        </titleStmt>
    </xsl:template>
          
    
    <xsl:template match="tei:principal"/>
    
    <xsl:template match="tei:graphic">
        <xsl:variable name="base" select="replace(tokenize(base-uri(/), '/')[last()], '_tei.xml', '_image_name.xml')"/>
        <xsl:variable name="items" select="doc(concat('../data/facs/', $base))"/>
        <xsl:variable name="pos" select="number(tokenize(parent::tei:surface/@xml:id, '_')[last()])"/>
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:attribute name="url">
                <xsl:value-of select="$items//item[$pos]"/>
            </xsl:attribute>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:body/tei:div">
        <div xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:for-each-group select="." group-starting-with="tei:pb">
                <xsl:apply-templates/>
            </xsl:for-each-group>
        </div>
    </xsl:template>
    <xsl:variable name="ab" select="//tei:ab"/>
    <xsl:template match="tei:ab">
        <xsl:variable name="pos" select="index-of($ab/@facs, @facs)"/>
        <cb xmlns="http://www.tei-c.org/ns/1.0" n="{$pos - 2}"/>
        <p xmlns="http://www.tei-c.org/ns/1.0"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="tei:lb">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:italic">
        <hi xmlns="http://www.tei-c.org/ns/1.0" rendition="#em"><xsl:apply-templates/></hi>
    </xsl:template>
    <xsl:template match="tei:work">
        <rs xmlns="http://www.tei-c.org/ns/1.0" type="bibl"><xsl:apply-templates/></rs>
    </xsl:template>
    <xsl:template match="tei:person_fictional">
        <rs xmlns="http://www.tei-c.org/ns/1.0" type="person"><xsl:apply-templates/></rs>
    </xsl:template>
    
</xsl:stylesheet>
