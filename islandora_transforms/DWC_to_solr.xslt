<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:dcterms="http://purl.org/dc/terms/"
        xmlns:dwr="http://rs.tdwg.org/dwc/xsd/simpledarwincore/"
        xmlns:java="http://xml.apache.org/xalan/java" xmlns:dwc="http://rs.tdwg.org/dwc/terms/"
        exclude-result-prefixes="dwc foxml java dwr dcterms">
        <!-- HashSet to track single-valued fields. -->
        <xsl:variable name="dwc_single_valued_hashset" select="java:java.util.HashSet.new()"/>

        <xsl:template match="foxml:datastream[@ID='DWC']/foxml:datastreamVersion[last()]"
                name="index_DWC">
                <xsl:param name="content"/>
                <!-- Get nodes without children -->
                <xsl:for-each
                        select="$content//dwr:SimpleDarwinRecordSet[1]/dwr:SimpleDarwinRecord[1]/*[not(*)]">
                        <xsl:variable name="prefix">
                                <xsl:choose>
                                        <xsl:when
                                                test="self::dwc:*">
                                                <xsl:text>dwc_</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:text>dcterms_</xsl:text>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="field_name" select="concat($prefix, local-name())"/>
                        <field>
                                <xsl:attribute name="name">
                                        <xsl:choose>
                                                <xsl:when
                                                  test="java:add($dwc_single_valued_hashset, $field_name)">
                                                  <xsl:value-of select="concat($field_name, '_s')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="concat($field_name, '_ms')"
                                                  />
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(text())"/>
                        </field>
                </xsl:for-each>
        </xsl:template>
</xsl:stylesheet>
