<?xml version="1.0" encoding="UTF-8"?>
<!--
 -
 -  $Id: lod2rdf.xsl,v 1.2 2009-05-20 14:59:20 source Exp $
 -
 -  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
 -  project.
 -
 -  Copyright (C) 1998-2009 OpenLink Software
 -
 -  This project is free software; you can redistribute it and/or modify it
 -  under the terms of the GNU General Public License as published by the
 -  Free Software Foundation; only version 2 of the License, dated June 1991.
 -
 -  This program is distributed in the hope that it will be useful, but
 -  WITHOUT ANY WARRANTY; without even the implied warranty of
 -  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 -  General Public License for more details.
 -
 -  You should have received a copy of the GNU General Public License along
 -  with this program; if not, write to the Free Software Foundation, Inc.,
 -  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
-->
<!DOCTYPE xsl:stylesheet [
<!ENTITY xsd "http://www.w3.org/2001/XMLSchema#">
<!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#">
<!ENTITY foaf "http://xmlns.com/foaf/0.1/">
<!ENTITY bibo "http://purl.org/ontology/bibo/">
<!ENTITY dc "http://purl.org/dc/elements/1.1/">
<!ENTITY nyt "http://www.nytimes.com/">
<!ENTITY sioc "http://rdfs.org/sioc/ns#">
<!ENTITY fct "http://openlinksw.com/services/facets/1.0/">
]>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:vi="http://www.openlinksw.com/virtuoso/xslt/"
    xmlns:opl="http://www.openlinksw.com/schema/attribution#"
    xmlns:dcterms = "http://purl.org/dc/terms/"
    xmlns:rdf="&rdf;"
    xmlns:rdfs="&rdfs;"
    xmlns:foaf="&foaf;"
    xmlns:bibo="&bibo;"
    xmlns:dc="&dc;"
    xmlns:nyt="&nyt;"
    xmlns:sioc="&sioc;"
    xmlns:fct="http://openlinksw.com/services/facets/1.0/"
    >
    
    <xsl:param name="baseUri" />

    <xsl:output method="xml" indent="yes" />

    <xsl:template match="/fct:facets/fct:result">
		<rdf:Description rdf:about="{$baseUri}">
			<xsl:for-each select="fct:row">
				<xsl:if test="not(fct:column[@datatype = 'url'] like 'nodeID://%')">
					<rdfs:seeAlso rdf:resource="{fct:column[@datatype = 'url']}"/>
				</xsl:if>
			</xsl:for-each>
		</rdf:Description>
		<xsl:for-each select="fct:row">
			<xsl:if test="not(fct:column[@datatype = 'url'] like 'nodeID://%')">
				<rdf:Description rdf:about="{fct:column[@datatype = 'url']}">
				<rdf:type rdf:resource="&foaf;Document"/>
				<rdf:type rdf:resource="&bibo;Document"/>
				<xsl:for-each select="fct:column[string-length(@datatype) = 0]">
					<dc:description>
						<xsl:value-of select="."/>
					</dc:description>
				</xsl:for-each>
					<bibo:uri rdf:resource="{fct:column[@datatype = 'url']}" />
					<sioc:link rdf:resource="{fct:column[@datatype = 'url']}" />					
			</rdf:Description>
			</xsl:if>
		</xsl:for-each>
    </xsl:template>

    <xsl:template match="text()|@*"/>

</xsl:stylesheet>
