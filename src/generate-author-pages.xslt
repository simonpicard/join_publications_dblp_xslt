<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" encoding="UTF-8"  use-character-maps="unknowChar" />

<xsl:character-map name="unknowChar">
  <xsl:output-character character="&#150;" string="="/>
</xsl:character-map>

<xsl:variable name="root" select="/dblp"/> 
	
<xsl:template match="/">

    <!-- Creation de la table qui sera par la suite convertie en page html pour chaque publicateur -->
    <!-- publicateur = auteur ou editeur -->

    <xsl:variable name="table">

    <xsl:for-each-group select="dblp/*" group-by="author | editor">
    
        <!-- Groupement des publication (article/livre/etc) par publicateur -->
         
        <xsl:variable name="currentPublicator" select="current-grouping-key()"/>
        <publicator pubvalue="{$currentPublicator}">
        <!-- entré pour le publicateur courrant -->
        
        <publications>
            <!-- entrée publication qui servira a créer la table des publications -->
        
            <xsl:for-each-group select="current-group()" group-by="year">
                <!-- deuxieme groupement par année -->
            
                <xsl:sort select="year" order="descending"/>
                <xsl:variable name="currentYear" select="current-grouping-key()"/>
                
                <xsl:variable name="totalPubToYear" select="count( $root/*[(author = $currentPublicator or editor = $currentPublicator) and (year &lt;= $currentYear)])"/>
                
                <year value="{$currentYear}">
                
                <xsl:for-each select="current-group()">
                    <!-- création d'une nouvelle entrée dans l'année courante pour chaque publication publiée durant celle-ci -->
                
                    <xsl:sort select="title" order="descending"/>
        
                    <publication type = "{name()}">
                        <pos>
                            <xsl:value-of select="$totalPubToYear - position() + 1"/>
                        </pos>
                        <year>
                            <xsl:value-of select="year"/>
                        </year>
                        
                        <xsl:if test="ee">
                            <ee><xsl:value-of select="ee"/></ee>
                        </xsl:if>
                        
                        <authors>
                            <xsl:for-each select="author | editor">
                                <author> <xsl:value-of select="."/> </author>, 
                            </xsl:for-each>
                        </authors>
                        <title>
                            <xsl:value-of select="title"/>
                        </title>
                        
                        <xsl:if test="series">
                            <series><xsl:value-of select="series"/></series>
                        </xsl:if>

                        <xsl:if test="isbn">
                            <isbn><xsl:value-of select="isbn"/></isbn>
                        </xsl:if>

                        <xsl:if test="volume">
                            <volume><xsl:value-of select="volume"/></volume>
                        </xsl:if>

                        <xsl:if test="booktitle">
                            <booktitle><xsl:value-of select="booktitle"/></booktitle>
                        </xsl:if>

                        <xsl:if test="publisher">
                            <publisher><xsl:value-of select="publisher"/></publisher>
                        </xsl:if>

                        <xsl:if test="pages">
                            <pages><xsl:value-of select="pages"/></pages>
                        </xsl:if>

                        <xsl:if test="number">
                            <number><xsl:value-of select="number"/></number>
                        </xsl:if>

                        <xsl:if test="journal">
                            <journal><xsl:value-of select="journal"/></journal>
                        </xsl:if>

                        <xsl:if test="school">
                            <school><xsl:value-of select="school"/></school>
                        </xsl:if>
                    </publication>
                
                </xsl:for-each>
                
                </year>
            
            </xsl:for-each-group>
            
        </publications>
        
        <coauthors>
            <!-- entré reprend les différent co-publicateur avec lequel le publicateur a écrit -->
        
            <xsl:for-each-group select="current-group()[count(author) > 1 or count(editor) > 1 or (count(author) = 1 and count(editor) = 1 and count(author) != count(editor))]" group-by="author | editor">
            
                <!-- Deuxieme groupement sur les publicateurs avec les publication qui ont au moins deux publicateur différent -->
            
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

    <!-- recoit une table en parametre et crée une page html pour chaque publicateur -->

    <xsl:param name="table" />
    
    <xsl:for-each select="$table/publicator">
	
		<xsl:variable name="authorFullName" select="@pubvalue"/>
         
        <xsl:variable name="authorParsedName">
        <xsl:call-template name="parseName">
            <xsl:with-param name="fullName" select="$authorFullName" />
        </xsl:call-template>
        </xsl:variable>

		<xsl:result-document method="html"  href="./a-tree/{$authorParsedName/firstLetter}/{$authorParsedName/fileName}.html">
			 
			<html>
			  <head> <title>Publications of <xsl:value-of select="$authorParsedName/fullName"/></title> </head>
			  <body>
				<h1> <xsl:value-of select="$authorParsedName/fullName"/> </h1>
						
				<p>
                    <!-- table publication -->
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
                                <td align="left" valign="top"> 
                                
                                <xsl:for-each select="authors/author"> <!-- imprime les publicateurs -->
                                
                                    <xsl:choose>
                                        <xsl:when test=". != $authorParsedName/fullName">
                                            <xsl:call-template name="getUriName">
                                                <xsl:with-param name="fullName" select="." />
                                            </xsl:call-template>&#160;
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$authorParsedName/fullName" />&#160;
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                    
                                    
                                </xsl:for-each>: <!-- ajoute les autres informations pour la référence -->
                                
                                
                                <b><xsl:value-of select="title" /></b>.&#160;
    
                                <xsl:if test="booktitle">
                                    In&#160;&#160;<i><xsl:value-of select="booktitle" /></i>.&#160;
                                </xsl:if>
    
                                <xsl:if test="journal">
                                    In&#160;&#160;<i><xsl:value-of select="journal" /></i>.&#160;
                                </xsl:if>
    
                                <xsl:if test="school">
                                    <xsl:value-of select="school" />.&#160;
                                </xsl:if>
    
                                <xsl:if test="volume">
                                    Vol.&#160;<xsl:value-of select="volume" />&#160;
                                </xsl:if>
    
                                <xsl:if test="number">
                                    Num.&#160;<xsl:value-of select="number" />&#160;
                                </xsl:if>
                                
                                <xsl:if test="pages">
                                    (pp.&#160;<xsl:value-of select="pages" />).&#160;
                                </xsl:if>
                                
                                <xsl:if test="series">
                                    <xsl:value-of select="series" />.&#160;
                                </xsl:if>
    
                                <xsl:if test="publisher">
                                    Pub:&#160;<xsl:value-of select="publisher" />.&#160;
                                </xsl:if>
                                
                                <xsl:if test="year">
                                    <xsl:value-of select="year" />.&#160;
                                </xsl:if>
                                
                                <xsl:if test="isbn">
                                    <xsl:value-of select="isbn" />.&#160;
                                </xsl:if>
                                
                                </td>
                                
                                </tr>
                            </xsl:for-each>
                        </xsl:for-each>
					</table>
				</p>
				
				<h2> Co-author index </h2>
						
				<p>
					<table border="1">  <!-- table de co-publicateur -->
						<xsl:for-each select="coauthors/coauthor">
                            <xsl:variable name="coAuthorName" select="@CAvalue"/>
                            <tr>
                            <td align="right" valign="top">
                            
                            <xsl:call-template name="getUriName">
                                <xsl:with-param name="fullName" select="$coAuthorName" /> 
                            </xsl:call-template>
                            
                            </td>
                            
                            <td align="left" valign="top">
                            
                            <xsl:for-each select="$table/publicator[@pubvalue = $authorFullName]">
                                <xsl:for-each select="publications/year/publication[contains(authors, $coAuthorName)]"> <!-- récupere la postion des entrées de la table de publication de l'auteur courant dans lequel le co-publicateur a participé -->
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


<xsl:template name="parseName">
    <xsl:param name="fullName" />
    
    <!-- recoit un nom en parametre et renvoie le nom ainsi que son nom formaté et la première lettre de son nom de famille -->
		
    <xsl:variable name="fileNameTmp" select="replace($fullName, '[^a-zA-Z0-9\s]','=')"/>
    <xsl:variable name="fileName" select="replace($fileNameTmp, '\s','_')"/>
    
    <xsl:variable name="firstLetter" select="lower-case(substring(tokenize($fileName, '_')[last()], 1, 1))"/>
    
    <fullName><xsl:value-of select="$fullName" /></fullName>
    <firstLetter><xsl:value-of select="$firstLetter" /></firstLetter>
    <fileName><xsl:value-of select="$fileName" /></fileName>

</xsl:template>


<xsl:template name="getUriName">
    <xsl:param name="fullName" />
    
    <!-- recoit un nom en parametre et l'imprime, s'il est présent dans la table alors il y a un lien vers sa page -->
    
    <xsl:variable name="parsedName">
    <xsl:call-template name="parseName">
        <xsl:with-param name="fullName" select="$fullName" />
    </xsl:call-template>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="$root/*[author = $fullName or editor = $fullName]">
            <a href="../{$parsedName/firstLetter}/{$parsedName/fileName}.html"><xsl:value-of select="$fullName" /></a>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$fullName" />
        </xsl:otherwise>
    </xsl:choose>
    
</xsl:template>






</xsl:stylesheet>