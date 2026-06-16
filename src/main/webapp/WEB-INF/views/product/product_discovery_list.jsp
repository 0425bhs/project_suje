<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 취향발견</title>

        <!-- 상품 페이지 공통 레이아웃 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 공통 상품 카드 디자인 CSS -->
        <link rel="stylesheet" href="/css/product/product_card.css">

        <!-- 취향발견 페이지 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_discovery_list.css?v=2">

        <!-- 상품 공통 헤더, 카테고리 메뉴 관련 JS -->
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="discovery" />
    </jsp:include>

    <main class="discovery-page">

        <section class="discovery-list-section">

            <div class="discovery-section-title">
                <h3>
                    <c:choose>
                        <c:when test="${isFallback}">
                            지금 둘러보기 좋은 상품
                        </c:when>
                        <c:otherwise>
                            회원님을 위한 추천 상품
                        </c:otherwise>
                    </c:choose>
                </h3>

                <c:choose>
                    <c:when test="${isFallback}">
                    </c:when>

                    <c:otherwise>
                        <p>구매, 찜, 장바구니, 최근 조회 기록을 기준으로 추천된 상품입니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${empty list}">
                    <div class="discovery-empty">
                        추천할 상품이 없습니다.
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="common-product-wrap">
                        <c:forEach var="vo" items="${list}">
                            <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </section>

    </main>

    </body>
</html>