<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" encoding="UTF-8"/>


<xsl:variable name="root" select="/dblp"/> 
	
<xsl:template match="/">
	<xsl:param name="authors" select="distinct-values(//author | //editor)"/>
	
	<xsl:for-each select="$authors">
	
		<xsl:variable name="authorFullName" select="."/>
		
		<xsl:variable name="firstLetter" select="substring(tokenize($authorFullName, '\s')[last()], 1, 1)"/>
		
		<xsl:variable name="fileNameTmp" select="replace($authorFullName, '[^a-zA-Z0-9\s]','=')"/>
		<xsl:variable name="fileName" select="replace($fileNameTmp, '\s','_')"/>

		<xsl:result-document method="html"  href="./output/{$firstLetter}/{$fileName}.html">
			 
			<html>
			  <head> <title>Publications of <xsl:value-of select="$authorFullName"/></title> </head>
			  <body>
				<h1> <xsl:value-of select="$authorFullName"/> </h1>
				
				<xsl:variable name="table">
					<xsl:call-template name="createTable">
						<xsl:with-param name="authorFullName" select="$authorFullName"/>
					</xsl:call-template>
				</xsl:variable>
						
				<p>
					<table border="1"> 
						<xsl:call-template name="writeAuthorPublications">
							<xsl:with-param name="table" select="$table"/>
						</xsl:call-template>
					</table>
				</p>
				
				<h2> Co-author index </h2>
				
			  </body>
			</html>
		</xsl:result-document>
	
	</xsl:for-each>
	
	
</xsl:template>


<xsl:template name="createTable">
	<xsl:param name="authorFullName"/>
	
	<xsl:value-of select="$authorFullName"/>
	
	
	<test>
		<xsl:for-each-group select="root/*[author = $authorFullName or editor = $authorFullName]" group-by="year">
			<xsl:copy-of select="current-group( )[1]"/>
		</xsl:for-each-group>
	</test>
	
</xsl:template>





</xsl:stylesheet>