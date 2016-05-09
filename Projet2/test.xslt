<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:template match="dblp">
		
		
		<xsl:text>&#xA;</xsl:text>
		<authors>
			<xsl:apply-templates select=".//author"/>
			<xsl:text>&#xA;</xsl:text>
		</authors>
	</xsl:template>
	
	
	
	<xsl:template match="author">
		<xsl:param name="firstLetter" select="substring(tokenize(., '\s')[last()], 1, 1)"/>
		
		<xsl:param name="fileName" select="replace(., '[^a-zA-Z0-9\s]','=')"/>
		<xsl:param name="fileName2" select="replace($fileName, '\s','_')"/>
		<xsl:text>&#xA;</xsl:text>
		<author>
			<xsl:value-of select="$firstLetter" />
		</author>
		<xsl:text>&#xA;</xsl:text>
		<author>
			<xsl:value-of select="$fileName2" />
		</author>
	</xsl:template>
	
	
	


</xsl:stylesheet>