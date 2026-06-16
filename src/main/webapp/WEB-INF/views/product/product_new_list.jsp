<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>HANDMADE - 신제품</title>

        <!-- 상품 페이지 공통 레이아웃 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 공통 상품 카드 디자인 CSS -->
        <link rel="stylesheet" href="/css/product/product_card.css">

        <!-- 최신작품 페이지 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_new_list.css">

        <!-- 상품 공통 헤더, 카테고리 메뉴 관련 JS -->
        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <!-- 상품 공통 헤더에서 최신 작품 메뉴 활성화 -->
    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="new" />
    </jsp:include>


    <main class="new-page">

        <div class="new-page-title">
            <h2>최신작품</h2>
        </div>

        <c:choose>

            <c:when test="${empty list}">
                <div class="new-empty">
                    등록된 신제품이 없습니다.
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

        <!-- 최신작품 페이징 -->
        <div class="new-page-menu">
            ${pageMenu}
        </div>

    </main>

    </body>
</html>