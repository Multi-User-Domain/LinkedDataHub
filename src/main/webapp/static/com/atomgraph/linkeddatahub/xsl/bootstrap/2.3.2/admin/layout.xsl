<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY lacl   "https://w3id.org/atomgraph/linkeddatahub/admin/acl/domain#">
    <!ENTITY lmod   "https://w3id.org/atomgraph/linkeddatahub/admin/modules/domain#">
    <!ENTITY apl    "https://w3id.org/atomgraph/linkeddatahub/domain#">
    <!ENTITY rdf    "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <!ENTITY ldt    "https://www.w3.org/ns/ldt#">
    <!ENTITY foaf   "http://xmlns.com/foaf/0.1/">
]>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xhtml="http://www.w3.org/1999/xhtml"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns:lacl="&lacl;"
xmlns:rdf="&rdf;"
xmlns:ldt="&ldt;"
xmlns:apl="&apl;"
xmlns:foaf="&foaf;"
xmlns:bs2="http://graphity.org/xsl/bootstrap/2.3.2"
exclude-result-prefixes="#all">

    <xsl:import href="../layout.xsl"/>
    <xsl:include href="acl/layout.xsl"/>
    <xsl:include href="sitemap/layout.xsl"/>

    <!-- allow subject editing in admin EditMode -->
    <xsl:template match="*[*][@rdf:about or @rdf:nodeID]" mode="bs2:FormControl">
        <xsl:apply-imports>
            <xsl:with-param name="show-subject" select="true()" tunnel="yes"/>
        </xsl:apply-imports>
    </xsl:template>
        
    <xsl:template match="*[rdf:type/@rdf:resource][foaf:isPrimaryTopicOf/@rdf:resource][$ldt:ontology][apl:listSuperClasses(rdf:type/@rdf:resource) = '&lmod;Module']" mode="bs2:Actions">
        <xsl:if test="$lacl:Agent//@rdf:about">
            <form class="pull-right" action="{foaf:isPrimaryTopicOf/@rdf:resource[starts-with(., $ldt:base)]}" method="get">
                <input type="hidden" name="install"/>
                <button class="btn btn-primary" type="submit">Install</button>
            </form>
        </xsl:if>

        <xsl:next-match/>
    </xsl:template>
    
</xsl:stylesheet>