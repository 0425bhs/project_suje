<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>HANDMADE</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/product/product_card.css">
    <script src="/js/product_main.js"></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="main" />
</jsp:include>

<section class="home-visual">
    <div class="home-visual-inner">

        <!-- 메인 배너 -->
        <div class="home-main-slider">
            <a href="/product_discovery.do" class="home-main-banner hero-slide"
               style="background-image: url('/upload/main_author.jpg');">
                <div class="hero-slide-content">
                    <span class="banner-label">HANDMADE MARKET</span>
                    <h1>
                        작가의 취향이 담긴<br>
                        특별한 작품을 만나보세요
                    </h1>
                    <p>
                        일상 속 작은 선물부터 나만의 취향을 담은 소품까지,
                        손으로 만든 상품을 둘러보고 주문할 수 있습니다.
                    </p>
                </div>
            </a>
        </div>

        <!-- 오른쪽 작은 배너 -->
        <div class="home-side-banners">
            <a href="/product_gift.do" class="side-banner peach" style="background-image: url('/upload/main_gift.jpg');">
                <span>오늘의 추천</span>
                <strong>
                    소중한 사람에게<br>
                    전하기 좋은 선물
                </strong>
            </a>

            <a href="/all_list.do?sort=new" class="side-banner yellow" style="background-image: url('/upload/main_handmade.jpg');">
                <span>NEW</span>
                <strong>
                    새롭게 등록된<br>
                    작가 상품
                </strong>
            </a>
        </div>

    </div>
</section>

<main class="product-home">

    <!-- 작가 상품 둘러보기 -->
    <section class="home-section">
        <div class="section-title-row">
            <div>
                <span>HANDMADE PRODUCTS</span>
                <h2>작가 상품 둘러보기</h2>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty mainProductList}">
                <p>등록된 상품이 없습니다.</p>
            </c:when>

            <c:otherwise>
                <div class="common-product-wrap">
                    <c:forEach var="vo" items="${mainProductList}">
                        <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- 추천 작가 상품 -->
    <section class="home-section">
        <div class="section-title-row">
            <div>
                <span>RECOMMEND</span>
                <h2>추천 작가 상품</h2>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty recommendList}">
                <p>추천 상품이 없습니다.</p>
            </c:when>

            <c:otherwise>
                <div class="common-product-wrap">
                    <c:forEach var="vo" items="${recommendList}" varStatus="st">
                        <c:if test="${st.index < 10}">
                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                        </c:if>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- 취향 발견 -->
    <section class="home-section">
        <div class="section-title-row">
            <div>
                <span>DISCOVERY</span>
                <h2>취향 발견의 재미를 느껴보세요</h2>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty discoveryList}">
                <p>추천할 상품이 없습니다.</p>
            </c:when>

            <c:otherwise>
                <div class="common-product-wrap">
                    <c:forEach var="vo" items="${discoveryList}">
                        <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</main>

<footer class="product-footer">
    <div class="product-footer-inner">
        <strong>HANDMADE</strong>
    </div>
</footer>

</body>
</html>