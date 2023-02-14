<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:t="http://www.moj.go.jp/MINJI/tizuxml"
    xmlns:z="http://www.moj.go.jp/MINJI/tizuzumen" version="1.0" exclude-result-prefixes="t z">
    <xsl:output indent="yes" encoding="UTF-8"/>

    <xsl:key name="geometry" match="/t:地図/t:空間属性/*" use="@id" />

    <xsl:template name="min">
        <xsl:param name="elements"/>
        <xsl:for-each select="$elements">
            <xsl:sort data-type="number" select="." order="ascending"/>
            <xsl:if test="position()=1">
                <xsl:value-of select="number(.)"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="max">
        <xsl:param name="elements"/>
        <xsl:for-each select="$elements">
            <xsl:sort data-type="number" select="." order="descending"/>
            <xsl:if test="position()=1">
                <xsl:value-of select="number(.)"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:variable name="minx">
        <xsl:call-template name="min">
            <xsl:with-param name="elements" select="/t:地図/t:図郭/*/z:X"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="maxx">
        <xsl:call-template name="max">
            <xsl:with-param name="elements" select="/t:地図/t:図郭/*/z:X"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="miny">
        <xsl:call-template name="min">
            <xsl:with-param name="elements" select="/t:地図/t:図郭/*/z:Y"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="maxy">
        <xsl:call-template name="max">
            <xsl:with-param name="elements" select="/t:地図/t:図郭/*/z:Y"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="title" select="concat(/t:地図/t:市区町村名,' ',/t:地図/t:地図名, '(',/t:地図/t:座標系,')')"/>

    <!-- Document root -->
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
                <style>
                 dt{font-weight:bold;}
                 footer{margin:1.5em auto;}
                 #svg{width:100%;background:#eee;}
                 footer{text-align:center;}
                </style>
            </head>
            <body>
                <div style="margin:10px;">
                    <h1>
                        <xsl:value-of select="$title"/>
                    </h1>
                    <dl>
                        <xsl:for-each select="/t:地図/*[not(*)]">
                            <dt>
                                <xsl:value-of select="name(.)"/>
                            </dt>
                            <dd>
                                <xsl:value-of select="string(.)"/>
                            </dd>
                        </xsl:for-each>
                    </dl>
                    <div>
                        <svg:svg id="svg" version="1.1" viewBox="0 0 {$maxx - $minx} {$maxy - $miny}">
                            <svg:g class="図郭" style="fill:none;stroke:gray;stroke-width:3px;stroke-dasharray:3 3;">
                                <xsl:apply-templates select="/t:地図/t:図郭"/>
                            </svg:g>
                            <svg:g class="筆" style="fill:black;stroke:white;stroke-width:1px;">
                                <xsl:apply-templates select="/t:地図/t:主題属性/t:筆"/>
                            </svg:g>
                            <svg:g class="筆界線" style="fill:none;stroke:orange;stroke-width:1px;">
                                <xsl:apply-templates select="/t:地図/t:主題属性/t:筆界線"/>
                            </svg:g>
                            <svg:g class="仮行政界線" style="fill:none;stroke:red;stroke-width:1px;">
                                <xsl:apply-templates select="/t:地図/t:主題属性/t:仮行政界線"/>
                            </svg:g>
                            <svg:g class="筆界点" style="fill:lime;stroke:none;">
                                <xsl:apply-templates select="/t:地図/t:主題属性/t:筆界点"/>
                            </svg:g>
                        </svg:svg>
                    </div>
                    <footer>Preview stylesheet by <a href="https://github.com/frogcat">frogcat</a>
                    </footer>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="t:図郭">
        <svg:polygon>
            <xsl:attribute name="points">
                <xsl:apply-templates select="t:左下座標"/>
                <xsl:apply-templates select="t:右下座標"/>
                <xsl:apply-templates select="t:右上座標"/>
                <xsl:apply-templates select="t:左上座標"/>
                <xsl:apply-templates select="t:左下座標"/>
            </xsl:attribute>
        </svg:polygon>
    </xsl:template>

    <xsl:template match="t:筆">
        <svg:polygon>
            <xsl:attribute name="points">
                <xsl:apply-templates select="key('geometry',t:形状/@idref)"/>
            </xsl:attribute>
        </svg:polygon>
    </xsl:template>

    <xsl:template match="t:筆界線|t:仮行政界線">
        <svg:polyline>
            <xsl:attribute name="points">
                <xsl:apply-templates select="key('geometry',t:形状/@idref)"/>
            </xsl:attribute>
        </svg:polyline>
    </xsl:template>

    <xsl:template match="t:筆界点">
        <xsl:for-each select="key('geometry',t:形状/@idref)/z:GM_Point.position/z:DirectPosition">
            <svg:circle cx="{z:X - $minx}" cy="{z:Y - $miny}" r="2"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="z:DirectPosition|z:GM_Position.direct|t:右下座標|t:右上座標|t:左下座標|t:左上座標">
        <xsl:value-of select="concat(z:X - $minx,' ',z:Y - $miny,' ')"/>
    </xsl:template>

    <xsl:template match="z:GM_Curve">
        <xsl:apply-templates select="z:GM_Curve.segment/z:GM_LineString/z:GM_LineString.controlPoint/z:GM_PointArray.column"/>
    </xsl:template>

    <xsl:template match="z:GM_Surface">
        <xsl:apply-templates select="key('geometry',z:GM_Surface.patch/z:GM_Polygon/z:GM_Polygon.boundary/z:GM_SurfaceBoundary/z:GM_SurfaceBoundary.exterior/z:GM_Ring/z:GM_CompositeCurve.generator/@idref)/z:GM_Curve.segment/z:GM_LineString/z:GM_LineString.controlPoint/z:GM_PointArray.column"/>
    </xsl:template>

    <xsl:template match="z:GM_PointArray.column">
        <xsl:apply-templates select="z:GM_Position.direct|z:GM_Position.indirect/z:GM_PointRef.point"/>
    </xsl:template>

    <xsl:template match="z:GM_PointRef.point">
        <xsl:apply-templates select="key('geometry',@idref)/z:GM_Point.position/z:DirectPosition"/>
    </xsl:template>

</xsl:stylesheet>
