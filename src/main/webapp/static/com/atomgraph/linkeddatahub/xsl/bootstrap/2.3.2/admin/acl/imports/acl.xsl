<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY apl    "https://w3id.org/atomgraph/linkeddatahub/domain#">
    <!ENTITY ac     "https://w3id.org/atomgraph/client#">
    <!ENTITY lacl   "https://w3id.org/atomgraph/linkeddatahub/admin/acl/domain#">
    <!ENTITY lsm    "https://w3id.org/atomgraph/linkeddatahub/admin/sitemap/domain#">
    <!ENTITY rdf    "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <!ENTITY rdfs   "http://www.w3.org/2000/01/rdf-schema#">
    <!ENTITY owl    "http://www.w3.org/2002/07/owl#">
    <!ENTITY acl    "http://www.w3.org/ns/auth/acl#">
    <!ENTITY ldt    "https://www.w3.org/ns/ldt#">
    <!ENTITY c      "https://www.w3.org/ns/ldt/core/domain#"> 
    <!ENTITY prov   "http://www.w3.org/ns/prov#">
    <!ENTITY foaf   "http://xmlns.com/foaf/0.1/">
    <!ENTITY sioc   "http://rdfs.org/sioc/ns#">
    <!ENTITY dct    "http://purl.org/dc/terms/">
]>
<xsl:stylesheet version="2.0"
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:ac="&ac;"
xmlns:lacl="&lacl;"
xmlns:lsm="&lsm;"
xmlns:rdf="&rdf;"
xmlns:rdfs="&rdfs;"
xmlns:owl="&owl;"
xmlns:acl="&acl;"
xmlns:ldt="&ldt;"
xmlns:core="&c;"
xmlns:foaf="&foaf;"
xmlns:sioc="&sioc;"
xmlns:bs2="http://graphity.org/xsl/bootstrap/2.3.2"
exclude-result-prefixes="#all">
    
    <xsl:template match="acl:mode/@rdf:resource | acl:mode/@rdf:nodeID" mode="bs2:FormControl" priority="1">
        <xsl:variable name="this" select="../concat(namespace-uri(), local-name())" as="xs:string"/>
        <xsl:variable name="properties" select="../../*[concat(namespace-uri(), local-name()) = $this]" as="element()*"/>

        <xsl:variable name="modes" select="key('resources-by-subclass', '&acl;Access', document('&acl;'))" as="element()*"/>
        <select name="ou" id="{generate-id()}" multiple="multiple" size="{count($modes)}">
            <xsl:for-each select="$modes">
                <xsl:sort select="ac:label(.)" lang="{$ldt:lang}"/>
                <xsl:apply-templates select="." mode="xhtml:Option">
                    <xsl:with-param name="selected" select="@rdf:about = $properties/@rdf:resource"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </select>

        <span class="help-inline">Resource</span>
    </xsl:template>

    <xsl:template match="acl:mode[position() &gt; 1]" mode="bs2:FormControl" priority="2"/>

    <xsl:template match="*[lacl:requestAccessTo/@rdf:resource]" mode="bs2:Block" priority="1">
        <xsl:next-match/>
        
        <xsl:if test="lacl:requestMode/@rdf:resource = '&acl;Control'">
            <div class="alert">
                <p>
                    <strong>Warning!</strong> By allowing <code>Control</code> access mode you are effectively granting full control of the dataspace.
                </p>
            </div>
        </xsl:if>
        
        <form method="post" action="{resolve-uri('acl/authorizations/?forClass=' || encode-for-uri(resolve-uri('ns#Authorization', $ldt:base)), $ldt:base)}">
            <xsl:comment>This form uses RDF/POST encoding: http://www.lsrn.org/semweb/rdfpost.html</xsl:comment>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'rdf'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>

            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'sb'"/>
                <xsl:with-param name="value" select="'auth'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&rdf;type'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ou'"/>
                <xsl:with-param name="value" select="resolve-uri('ns#Authorization', $ldt:base)"/> <!-- Authorization class URI -->
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&foaf;isPrimaryTopicOf'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ob'"/>
                <xsl:with-param name="value" select="'auth-item'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&rdfs;label'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:variable name="label" select="string-join(lacl:requestMode/@rdf:resource/ac:label(key('resources', ., document('&acl;'))), ', ')" as="xs:string"/>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ol'"/>
                <xsl:with-param name="value" select="'Allowed ' || $label || ' access'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&acl;agent'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ou'"/>
                <xsl:with-param name="value" select="lacl:requestAgent/@rdf:resource"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:for-each select="lacl:requestAccessTo/@rdf:resource">
                <xsl:call-template name="xhtml:Input">
                    <xsl:with-param name="name" select="'pu'"/>
                    <xsl:with-param name="value" select="'&acl;accessTo'"/>
                    <xsl:with-param name="type" select="'hidden'"/>
                </xsl:call-template>
                <xsl:call-template name="xhtml:Input">
                    <xsl:with-param name="name" select="'ou'"/>
                    <xsl:with-param name="value" select="."/>
                    <xsl:with-param name="type" select="'hidden'"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="lacl:requestAccessToClass/@rdf:resource">
                <xsl:call-template name="xhtml:Input">
                    <xsl:with-param name="name" select="'pu'"/>
                    <xsl:with-param name="value" select="'&acl;accessToClass'"/>
                    <xsl:with-param name="type" select="'hidden'"/>
                </xsl:call-template>
                <xsl:call-template name="xhtml:Input">
                    <xsl:with-param name="name" select="'ou'"/>
                    <xsl:with-param name="value" select="."/>
                    <xsl:with-param name="type" select="'hidden'"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="lacl:requestMode/@rdf:resource">
                <xsl:call-template name="xhtml:Input">
                    <xsl:with-param name="name" select="'pu'"/>
                    <xsl:with-param name="value" select="'&acl;mode'"/>
                    <xsl:with-param name="type" select="'hidden'"/>
                </xsl:call-template>
                <xsl:call-template name="xhtml:Input">
                    <xsl:with-param name="name" select="'ou'"/>
                    <xsl:with-param name="value" select="."/>
                    <xsl:with-param name="type" select="'hidden'"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&prov;wasDerivedFrom'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ou'"/>
                <xsl:with-param name="value" select="@rdf:about"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>

            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'sb'"/>
                <xsl:with-param name="value" select="'auth-item'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&rdf;type'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ou'"/>
                <xsl:with-param name="value" select="resolve-uri('ns#AuthorizationItem', $ldt:base)"/> <!-- AuthorizationItem class URI -->
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&sioc;has_container'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ou'"/>
                <xsl:with-param name="value" select="resolve-uri('acl/authorizations/', $ldt:base)"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&dct;title'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:variable name="label" select="string-join(lacl:requestMode/@rdf:resource/ac:label(key('resources', ., document('&acl;'))), ', ')" as="xs:string"/>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ol'"/>
                <xsl:with-param name="value" select="'Allowed ' || $label || ' access'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'pu'"/>
                <xsl:with-param name="value" select="'&foaf;primaryTopic'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>
            <xsl:call-template name="xhtml:Input">
                <xsl:with-param name="name" select="'ob'"/>
                <xsl:with-param name="value" select="'auth'"/>
                <xsl:with-param name="type" select="'hidden'"/>
            </xsl:call-template>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Allow</button>
            </div>
        </form>
    </xsl:template>
    
</xsl:stylesheet>