<?xml version='1.0' encoding='UTF-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

    <!-- LFS top-level chunk templates. -->
  <xsl:import href="lfs-xsl/chunkfast.xsl"/>

    <!-- The LFS book type to be processed (lfs, blfs, clfs, or hlfs) -->
  <xsl:param name="book-type">blfs</xsl:param>

    <!-- Are sections enumerated? 1 = yes, 0 = no
           Note: Activating this will increase a lot rendering time. -->
  <xsl:param name="section.autolabel" select="0"/>

    <!-- Do section labels include the component label? 1 = yes, 0 = no -->
  <xsl:param name="section.label.includes.component.label" select="0"/>

<xsl:template match="para[@role='required']">
  <p>
    <xsl:value-of select="."/>
    <span class="role">
      (<xsl:choose>
         <xsl:when test="@role='required'">Påkrevd</xsl:when>
         <xsl:otherwise><xsl:value-of select="@role"/></xsl:otherwise>
      </xsl:choose>)
    </span>
  </p>
</xsl:template>

<xsl:template match="para[@role='recommended']">
  <p>
    <xsl:value-of select="."/>
    <span class="role">
      (<xsl:choose>
         <xsl:when test="@role='recommended'">Anbefalt</xsl:when>
         <xsl:otherwise><xsl:value-of select="@role"/></xsl:otherwise>
      </xsl:choose>)
    </span>
  </p>
  
<xsl:template match="para[@role='optional']">
  <p>
    <xsl:value-of select="."/>
    <span class="role">
      (<xsl:choose>
         <xsl:when test="@role='optional'">Valgfri</xsl:when>
         <xsl:otherwise><xsl:value-of select="@role"/></xsl:otherwise>
      </xsl:choose>)
    </span>
  </p>

</xsl:template>
</xsl:stylesheet>
