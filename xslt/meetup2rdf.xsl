<?xml version="1.0" encoding="UTF-8"?>
<!--
 -
 -  $Id: meetup2rdf.xsl,v 1.14 2009-05-19 10:47:39 source Exp $
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
<!ENTITY xml 'http://www.w3.org/XML/1998/namespace#'>
<!ENTITY foaf "http://xmlns.com/foaf/0.1/">
<!ENTITY sioc "http://rdfs.org/sioc/ns#">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:foaf="&foaf;"
    xmlns:sioc="&sioc;"
	xmlns:virtrdf="http://www.openlinksw.com/schemas/XHTML#"
	xmlns:vi="http://www.openlinksw.com/virtuoso/xslt/"
	xmlns:v="http://www.w3.org/2006/vcard/ns#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#"
	xmlns:opl-meetup="http://www.openlinksw.com/schemas/meetup/"
    xmlns:c   ="http://www.w3.org/2002/12/cal/icaltzd#"
	version="1.0">
	<xsl:variable name="ns">http://getsatisfaction.com</xsl:variable>
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="baseUri" />
	<xsl:param name="base" />
	<xsl:param name="what" />

    <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZ </xsl:variable>
    <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyz_</xsl:variable>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:apply-templates select="results/items" />
		</rdf:RDF>
	</xsl:template>
	<xsl:template match="results/items">
		<xsl:if test="$what = 'events' or $what = 'event' or $what = 'comments'">
			<foaf:Document rdf:about="{$baseUri}">
				<foaf:primaryTopic>
					<xsl:if test="$what = 'events' or $what = 'comments'">
						<foaf:Group rdf:about="{vi:proxyIRI($base)}" >
							<xsl:for-each select="item">
								<xsl:if test="$what = 'events'">
									<foaf:made rdf:resource="{event_url}"/>
								</xsl:if>
								<xsl:if test="$what = 'comments'">
									<foaf:made rdf:resource="{vi:proxyIRI($base, '', link)}"/>
								</xsl:if>
							</xsl:for-each>
						</foaf:Group>
					</xsl:if>
					<xsl:if test="$what = 'event'">
						<c:Vevent rdf:about="{vi:proxyIRI(item/event_url)}"/>
					</xsl:if>
				</foaf:primaryTopic>
			</foaf:Document>
		</xsl:if>
		<xsl:if test="$what = 'members'">
			<foaf:Document rdf:about="{$base}">
				<foaf:primaryTopic>
					<foaf:Group rdf:about="{vi:proxyIRI($base)}">
						<xsl:for-each select="item">
							<foaf:member rdf:resource="{vi:proxyIRI(link)}"/>
						</xsl:for-each>
					</foaf:Group>
				</foaf:primaryTopic>
			</foaf:Document>
		</xsl:if>
		<xsl:for-each select="item">
			<xsl:if test="$what = 'comments'">
				<rdf:Description rdf:about="{vi:proxyIRI($base, '', link)}">
					<rdf:type rdf:resource="&sioct;Comment"/>
					<sioc:has_container rdf:resource="{vi:proxyIRI ($base)}"/>
					<sioc:has_creator rdf:resource="{vi:proxyIRI (link)}"/>
					<geo:lng rdf:datatype="&xsd;float">
						<xsl:value-of select="lon"/>
					</geo:lng>
					<geo:lat rdf:datatype="&xsd;float">
						<xsl:value-of select="lat"/>
					</geo:lat>
					<dcterms:created rdf:datatype="&xsd;dateTime">
						<xsl:value-of select="created"/>
					</dcterms:created>
					<dc:description>
						<xsl:value-of select="comment"/>
					</dc:description>
					<xsl:if test="string-length(state) &gt; 0">
					<vcard:Region rdf:resource="{vi:dbpIRI ('', translate (state, $lc, $uc))}"/>
					<vcard:Region>
						<xsl:value-of select="state" />
					</vcard:Region>
					</xsl:if>
					<xsl:if test="string-length(zip) &gt; 0">
					<vcard:Pcode>
						<xsl:value-of select="zip" />
					</vcard:Pcode>
					</xsl:if>
					<xsl:if test="string-length(country) &gt; 0">
					<vcard:Country rdf:resource="{vi:dbpIRI ('', translate (country, $lc, $uc))}"/>
					<vcard:Country>
						<xsl:value-of select="country" />
					</vcard:Country>
					</xsl:if>
				</rdf:Description>
			</xsl:if>
			<xsl:if test="$what = 'events' or $what = 'event'">
				<foaf:Document rdf:about="{event_url}">
					<foaf:primaryTopic>
						<c:Vevent rdf:about="{vi:proxyIRI(event_url)}">
							<c:dtstart>
								<xsl:value-of select="time"/>
							</c:dtstart>
							<dcterms:modified rdf:datatype="&xsd;dateTime">
								<xsl:value-of select="updated"/>
							</dcterms:modified>
							<c:summary>
								<xsl:value-of select="name"/>
							</c:summary>
							<c:description>
								<xsl:value-of select="description"/>
							</c:description>
							<c:location>
								<xsl:value-of select="venue_name"/>
							</c:location>
							<geo:lng rdf:datatype="&xsd;float">
								<xsl:value-of select="venue_lon"/>
							</geo:lng>
							<geo:lat rdf:datatype="&xsd;float">
								<xsl:value-of select="venue_lat"/>
							</geo:lat>
							<opl-meetup:id>
								<xsl:value-of select="id" />
							</opl-meetup:id>
							<xsl:if test="photo_url != ''">
								<foaf:depiction rdf:resource="{photo_url}" />
							</xsl:if>
							<opl-meetup:group_name>
								<xsl:value-of select="group_name" />
							</opl-meetup:group_name>
							<sioc:has_creator rdf:resource="{vi:proxyIRI($base)}" />
						</c:Vevent>
					</foaf:primaryTopic>
				</foaf:Document>
			</xsl:if>
			<xsl:if test="$what = 'groups'">
				<foaf:Document rdf:about="{$base}">
					<foaf:primaryTopic>
						<foaf:Group rdf:about="{vi:proxyIRI($base)}">
							<foaf:name>
								<xsl:value-of select="name" />
							</foaf:name>
							<geo:lng rdf:datatype="&xsd;float">
								<xsl:value-of select="lon"/>
							</geo:lng>
							<geo:lat rdf:datatype="&xsd;float">
								<xsl:value-of select="lat"/>
							</geo:lat>
							<dc:description>
								<xsl:value-of select="description" />
							</dc:description>
							<xsl:if test="string-length(state) &gt; 0">
							<vcard:Region>
								<xsl:value-of select="state" />
							</vcard:Region>
							<vcard:Region rdf:resource="{vi:dbpIRI ('', translate (state, $lc, $uc))}"/>
							</xsl:if>
							<xsl:if test="string-length(zip) &gt; 0">
							<vcard:Pcode>
								<xsl:value-of select="zip" />
							</vcard:Pcode>
							</xsl:if>
							<opl-meetup:id>
								<xsl:value-of select="id" />
							</opl-meetup:id>
							<foaf:homepage rdf:resource="{link}" />
							<xsl:if test="string-length(country) &gt; 0">
							<vcard:Country>
								<xsl:value-of select="country" />
							</vcard:Country>
							<vcard:Country rdf:resource="{vi:dbpIRI ('', translate (country, $lc, $uc))}"/>
							</xsl:if>
							<xsl:if test="photo_url != ''">
								<foaf:depiction rdf:resource="{photo_url}" />
							</xsl:if>
							<dcterms:created rdf:datatype="&xsd;dateTime">
								<xsl:value-of select="created"/>
							</dcterms:created>
							<opl-meetup:members>
								<xsl:value-of select="members" />
							</opl-meetup:members>
							<xsl:if test="string-length(city) &gt; 0">
							<vcard:Locality>
								<xsl:value-of select="city" />
							</vcard:Locality>
							<vcard:Locality rdf:resource="{vi:dbpIRI ('', translate (city, ' ', '_'))}"/>
							</xsl:if>	
							<dcterms:modified rdf:datatype="&xsd;dateTime">
								<xsl:value-of select="updated"/>
							</dcterms:modified>
							<!--rdfs:seeAlso rdf:resource="{organizerProfileURL}" /-->
							<!--rdfs:seeAlso rdf:resource="{concat(link, 'members')}" /-->
							<!--rdfs:seeAlso rdf:resource="{concat(link, 'calendar')}" /-->
						</foaf:Group>
					</foaf:primaryTopic>
				</foaf:Document>
			</xsl:if>
			<xsl:if test="$what = 'members' or $what = 'member'">
				<xsl:if test="$what = 'members' and contains($baseUri, id) ">
					<foaf:Document rdf:about="{$baseUri}">
						<foaf:primaryTopic>
							<foaf:Person rdf:about="{vi:proxyIRI(link)}"/>
						</foaf:primaryTopic>
					</foaf:Document>
				</xsl:if>

				<foaf:Document rdf:about="{link}">
					<foaf:primaryTopic>
						<foaf:Person rdf:about="{vi:proxyIRI(link)}">
							<foaf:name>
								<xsl:value-of select="name" />
							</foaf:name>
							<geo:lng rdf:datatype="&xsd;float">
								<xsl:value-of select="lon"/>
							</geo:lng>
							<geo:lat rdf:datatype="&xsd;float">
								<xsl:value-of select="lat"/>
							</geo:lat>
							<dc:description>
								<xsl:value-of select="bio" />
							</dc:description>
							<xsl:if test="string-length(state) &gt; 0">
							<vcard:Region>
								<xsl:value-of select="state" />
							</vcard:Region>
							<vcard:Region rdf:resource="{vi:dbpIRI ('', translate (state, $lc, $uc))}"/>
							</xsl:if>
							<xsl:if test="string-length(zip) &gt; 0">
							<vcard:Pcode>
								<xsl:value-of select="zip" />
							</vcard:Pcode>
							</xsl:if>
							<opl-meetup:id>
								<xsl:value-of select="id" />
							</opl-meetup:id>
							<foaf:homepage rdf:resource="{link}" />
							<xsl:if test="string-length(country) &gt; 0">
							<vcard:Country>
								<xsl:value-of select="country" />
							</vcard:Country>
							<vcard:Country rdf:resource="{vi:dbpIRI ('', translate (country, $lc, $uc))}"/>
							</xsl:if>
							<xsl:if test="photo_url != ''">
								<foaf:depiction rdf:resource="{photo_url}" />
							</xsl:if>
							<dcterms:created rdf:datatype="&xsd;dateTime">
								<xsl:value-of select="joined"/>
							</dcterms:created>
							<xsl:if test="string-length(city) &gt; 0">
							<vcard:Locality rdf:resource="{vi:dbpIRI ('', translate (city, ' ', '_'))}"/>
							<vcard:Locality>
								<xsl:value-of select="city" />
							</vcard:Locality>
							</xsl:if>
							<dcterms:modified rdf:datatype="&xsd;dateTime">
								<xsl:value-of select="visited"/>
							</dcterms:modified>
							<xsl:if test="$what = 'members'">
								<foaf:topic_interest rdf:resource="{vi:proxyIRI($base)}" />
							</xsl:if>
						</foaf:Person>
					</foaf:primaryTopic>
				</foaf:Document>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
