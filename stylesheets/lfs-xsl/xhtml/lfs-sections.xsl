<?xml version='1.0' encoding='UTF-8'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">

  <!-- This stylesheet controls how preface, chapter, and sections are handled -->

    <!-- Chunk the first top-level section? 1 = yes, 0 = no
         If preface and chapters TOC are generated, this must be 1. -->
  <xsl:param name="chunk.first.sections" select="1"/>

    <!-- preface:
         Output non sect1 child elements before the TOC
         Output title outside of the <div> because we want to be able to
         use it at a fixed position -->
    <!-- The original template is in {docbook-xsl}/xhtml/components.xsl -->
  <xsl:template match="preface">
    <xsl:call-template name="id.warning"/>
    <xsl:call-template name="preface.titlepage"/>
    <xsl:call-template name="component.separator"/>
    <div>
      <xsl:apply-templates select="." mode="class.attribute"/>
      <xsl:call-template name="dir">
        <xsl:with-param name="inherit" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="language.attribute"/>
      <xsl:if test="$generate.id.attributes != 0">
        <xsl:attribute name="id">
          <xsl:call-template name="object.id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')">
        <xsl:call-template name="component.toc">
          <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
        </xsl:call-template>
        <xsl:call-template name="component.toc.separator"/>
      </xsl:if>
      <xsl:call-template name="process.footnotes"/>
    </div>
  </xsl:template>

    <!-- part:
         Output non sect1 child elements before the TOC
         Output title outside of the <div> because we want to be able to
         use it at a fixed position -->
    <!-- The original template is in {docbook-xsl}/xhtml/divisions.xsl -->
  <xsl:template match="part">
    <xsl:call-template name="id.warning"/>

    <xsl:call-template name="part.titlepage"/>

    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>

      <xsl:apply-templates/>
      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not(partintro) and contains($toc.params, 'toc')">
        <xsl:call-template name="division.toc"/>
      </xsl:if>
    </div>
  </xsl:template>

    <!-- chapter:
           Output non sect1 child elements before the TOC
           Output title before div to be able to fix the title position -->
    <!-- The original template is in {docbook-xsl}/xhtml/components.xsl -->
  <xsl:template match="chapter">
    <xsl:call-template name="id.warning"/>
    <xsl:call-template name="chapter.titlepage"/>
    <xsl:call-template name="component.separator"/>
    <div>
      <xsl:apply-templates select="." mode="class.attribute"/>
      <xsl:call-template name="dir">
        <xsl:with-param name="inherit" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="language.attribute"/>
      <xsl:if test="$generate.id.attributes != 0">
        <xsl:attribute name="id">
          <xsl:call-template name="object.id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="contains($toc.params, 'toc')">
        <xsl:call-template name="component.toc">
          <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
        </xsl:call-template>
        <xsl:call-template name="component.toc.separator"/>
      </xsl:if>
      <xsl:call-template name="process.footnotes"/>
    </div>
  </xsl:template>

    <!-- appendix:
           Output non sect1 child elements before the TOC
           Output title before div to be able to fix the title position -->
    <!-- The original template is in {docbook-xsl}/xhtml/components.xsl -->
  <xsl:template match="appendix">

    <xsl:call-template name="id.warning"/>

    <xsl:call-template name="appendix.titlepage"/>

    <xsl:element name="div" namespace="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="common.html.attributes">
        <xsl:with-param name="inherit" select="1"/>
      </xsl:call-template>
      <xsl:call-template name="id.attribute">
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>

      <xsl:apply-templates/>

      <xsl:variable name="toc.params">
        <xsl:call-template name="find.path.params">
          <xsl:with-param name="table" select="normalize-space($generate.toc)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:if test="contains($toc.params, 'toc')">
        <xsl:call-template name="component.toc">
          <xsl:with-param name="toc.title.p" select="contains($toc.params, 'title')"/>
        </xsl:call-template>
      </xsl:if>

    </xsl:element>
  </xsl:template>

    <!-- sect1:
           When there is a role attibute, use it as the class value.
           Process the SVN keywords found in sect1info as a footnote.
           Output title before the containing <div> so that the title
           can be at a fixed position.
           Removed unused code. -->
    <!-- The original template is in {docbook-xsl}/xhtml/sections.xsl -->
  <xsl:template match="sect1">
    <xsl:call-template name="sect1.titlepage"/>
    <div>
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="class.attribute"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="language.attribute"/>
      <xsl:apply-templates/>
      <xsl:call-template name="process.footnotes"/>
    </div>
  </xsl:template>

    <!-- sect2:
           When there is a role attibute, use it as the class value.
           Removed unused code. -->
    <!-- The original template is in {docbook-xsl}/xhtml/sections.xsl -->
  <xsl:template match="sect2">
    <div>
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:value-of select="name(.)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="language.attribute"/>
      <xsl:call-template name="sect2.titlepage"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

    <!-- sect3: treat as sect2 (for Python and Perl modules
           When there is a role attibute, use it as the class value.
           Removed unused code. -->
    <!-- The original template is in {docbook-xsl}/xhtml/sections.xsl -->
  <xsl:template match="sect3">
    <div>
      <xsl:choose>
        <xsl:when test="@role">
          <xsl:attribute name="class">
            <xsl:value-of select="@role"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">
            <xsl:value-of select="name(.)"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="language.attribute"/>
      <xsl:call-template name="sect3.titlepage"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

    <!-- sect1info mode svn-keys:
           Self-made template to process SVN keywords found in sect1info. -->
  <xsl:template match="sect1info" mode="svn-keys">
    <!-- <p class="updated">Last updated --><!-- by
      <xsl:apply-templates select="othername" mode="svn-keys"/> -->
    <!--  on
      <xsl:apply-templates select="date" mode="svn-keys"/>
    </p> -->
  </xsl:template>

    <!-- othername mode svn-keys:
           Self-made template to process the $LastChangedBy SVN keyword. -->
  <xsl:template match="othername" mode="svn-keys">
    <xsl:variable name="author">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:variable name="nameonly">
      <xsl:value-of select="substring($author,16)"/>
    </xsl:variable>
    <xsl:value-of select="substring-before($nameonly,'$')"/>
  </xsl:template>

    <!-- date mode svn-keys:
           Self-made template to process the $Date SVN keyword. -->
  <xsl:template match="date" mode="svn-keys">
    <xsl:variable name="date">
      <xsl:value-of select="."/>
    </xsl:variable>
    <xsl:value-of select="substring($date,7,26)"/>
  </xsl:template>

</xsl:stylesheet>
