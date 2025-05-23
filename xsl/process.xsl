<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output encoding="UTF-8" media-type="text/xml" method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping='yes'>&lt;?xml version="1.0" encoding="UTF-8"?&gt;</xsl:text>
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="//tei:name[@ref='https://orcid.org/0000-0002-8815-6741' or @ref='https://d-nb.info/gnd/1297553608']">
        <name xmlns="http://www.tei-c.org/ns/1.0" ref="https://orcid.org/0000-0002-8815-6741">Sanz-Lázaro, Fernando</name>
    </xsl:template>
    
</xsl:stylesheet>
