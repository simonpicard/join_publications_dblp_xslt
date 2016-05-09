<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:variable name="root" select="/dblp"/> 
	
<xsl:template match="/">

    <xsl:variable name="table">

    <xsl:for-each-group select="dblp/*" group-by="author | editor">
    
            
        <xsl:variable name="currentPublicator" select="current-grouping-key()"/>
        <publicator pubvalue="{$currentPublicator}">
        
        <publications>
        
            <xsl:for-each-group select="current-group()" group-by="year">
            
                <xsl:sort select="year" order="descending"/>
                <xsl:variable name="currentYear" select="current-grouping-key()"/>
                
                <xsl:variable name="totalPubToYear" select="count( $root/*[(author = $currentPublicator or editor = $currentPublicator) and (year &lt;= $currentYear)])"/>
                
                <year value="{$currentYear}">
                
                <xsl:for-each select="current-group()">
                
                    <xsl:sort select="title" order="descending"/>
        
                    <publication type = "{name()}">
                        <pos>
                            <xsl:value-of select="$totalPubToYear - position() + 1"/>
                        </pos>
                        
                        <xsl:if test="ee">
                            <ee><xsl:value-of select="ee"/></ee>
                        </xsl:if>
                        
                        <authors>
                            <xsl:value-of select="author"/>
                        </authors>
                        <title>
                            <xsl:value-of select="title"/>
                        </title>
                    </publication>
                
                </xsl:for-each>
                
                </year>
            
            </xsl:for-each-group>
            
        </publications>
        
        <coauthors>
        
            <xsl:for-each-group select="current-group()[count(author) > 1]" group-by="author">
            
                <xsl:sort select="tokenize(current-grouping-key(), '\s')[last()]" />
            
                <xsl:variable name="currentCoauthor" select="current-grouping-key()"/>
                
                
                <xsl:if test="$currentPublicator ne $currentCoauthor">
                
                <coauthor CAvalue="{$currentCoauthor}" />
                
                </xsl:if>
            
            </xsl:for-each-group>
        
        </coauthors>
        
        
        </publicator>
    </xsl:for-each-group>
    </xsl:variable>
    
    <xsl:call-template name="printTables">
        <xsl:with-param name="table" select="$table"/>
    </xsl:call-template>
	
</xsl:template>


<xsl:template name="printTables">

    <xsl:param name="table" />
    
    <xsl:for-each select="$table/publicator">
	
		<xsl:variable name="authorFullName" select="@pubvalue"/>
		
		<xsl:variable name="firstLetter" select="substring(tokenize($authorFullName, '\s')[last()], 1, 1)"/>
		
		<xsl:variable name="fileNameTmp" select="replace($authorFullName, '[^a-zA-Z0-9\s]','=')"/>
		<xsl:variable name="fileName" select="replace($fileNameTmp, '\s','_')"/>

		<xsl:result-document method="html"  href="./output/{$firstLetter}/{$fileName}.html">
			 
			<html>
			  <head> <title>Publications of <xsl:value-of select="$authorFullName"/></title> </head>
			  <body>
				<h1> <xsl:value-of select="$authorFullName"/> </h1>
						
				<p>
					<table border="1"> 
						<xsl:for-each select="publications/year">
                            <tr><th colspan="3" bgcolor="#FFFFCC"> <xsl:value-of select="@value"/> </th></tr>
                            <xsl:for-each select="publication">
                                <tr>
                                <td align="right" valign="top"><a name="p{pos}"/><xsl:value-of select="pos" /></td>
                                <td align="right" valign="top">
                                    <xsl:if test="ee">
                                        <a href="{ee}">
                                        <img alt="Electronic Edition" title="Electronic Edition"
                                        src="http://www.informatik.uni-trier.de/~ley/db/ee.gif"
                                        border="0" height="16" width="16"/>
                                        </a>
                                    </xsl:if>
                                </td>
                                <td align="right" valign="top"><xsl:value-of select="authors" />: <xsl:value-of select="title" /></td>
                                </tr>
                            </xsl:for-each>
                        </xsl:for-each>
					</table>
				</p>
				
				<h2> Co-author index </h2>
						
				<p>
					<table border="1"> 
						<xsl:for-each select="coauthors/coauthor">
                            <xsl:variable name="coAuthorName" select="@CAvalue"/>
                            <tr>
                            <td align="left" valign="top"><xsl:value-of select="@CAvalue" /></td>
                            
                            <td align="right" valign="top">
                            
                            <xsl:for-each select="$table/publicator[@pubvalue = $authorFullName]">
                                <xsl:for-each select="publications/year/publication[contains(authors, $coAuthorName)]">
                                    [<a href="#p{pos}"><xsl:value-of select="pos" /></a>]
                                </xsl:for-each>
                            </xsl:for-each>
                            
                            </td>
                            </tr>
                        </xsl:for-each>
					</table>
				</p>
				
			  </body>
			</html>
		</xsl:result-document>
    
    
    
    </xsl:for-each>

</xsl:template>





</xsl:stylesheet>