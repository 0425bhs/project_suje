<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 베스트</title>

        <!-- 상품 공통 레이아웃 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 상품 카드 공통 CSS -->
        <link rel="stylesheet" href="/css/product/product_card.css">

        <!-- 베스트 페이지 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_best_list.css?v=3">

        <!-- 상품 헤더, 전체 카테고리 메뉴용 공통 JS -->
        <script src="/js/product_main.js" defer></script>

        <!-- 베스트 페이지 카테고리 이동 메뉴용 JS -->
        <script src="/js/product_best_list.js" defer></script>
    </head>

    <body>

    <!-- 상품 공통 헤더에서 베스트 메뉴를 활성화 -->
    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="best" />
    </jsp:include>

    <main class="best-page" id="bestTop">

        <!-- 상단 카테고리 이동 메뉴 -->
        <section class="best-category-nav">
            <div class="best-category-inner">

                <a href="#bestTop" class="active">
                    전체
                </a>

                <c:forEach var="big" items="${bigCategoryList}">
                    <a href="#best-category-${big.category_id}">
                        ${big.name}
                    </a>
                </c:forEach>

            </div>
        </section>


        <!-- 대분류 카테고리별 베스트 상품 출력 -->
        <c:forEach var="big" items="${bigCategoryList}">

            <section class="best-category-section" id="best-category-${big.category_id}">

                <div class="best-section-title-row">
                    <h2>${big.name} 베스트</h2>

                    <a href="/category_list.do?category_id=${big.category_id}">
                        더보기 〉
                    </a>
                </div>

                <div class="common-product-wrap">

                    <!-- 카테고리별 순위 초기화 -->
                    <c:set var="rank" value="0" />

                    <c:forEach var="vo" items="${list}">

                        <!-- 대분류에 직접 속한 상품인지 확인 -->
                        <c:set var="isMatch" value="${vo.category_id eq big.category_id}" />

                        <!-- 대분류의 소분류에 속한 상품인지 확인 -->
                        <c:forEach var="small" items="${smallCategoryList}">
                            <c:if test="${small.parent_id eq big.category_id and vo.category_id eq small.category_id}">
                                <c:set var="isMatch" value="true" />
                            </c:if>
                        </c:forEach>

                        <!-- 현재 카테고리에 해당하는 상품만 10개까지 출력 -->
                        <c:if test="${isMatch and rank lt 10}">

                            <c:set var="rank" value="${rank + 1}" />

                            <div class="best-card-wrap">

                                <span class="best-rank-badge">
                                    ${rank}
                                </span>

                                <!-- 공통 상품 카드: product_card.jspf는 vo 변수를 사용 -->
                                <%@ include file="/WEB-INF/views/product/product_card.jspf" %>

                            </div>

                        </c:if>

                    </c:forEach>

                </div>

                <!-- 해당 카테고리에 출력할 상품이 없을 때 -->
                <c:if test="${rank == 0}">
                    <div class="best-empty">
                        해당 카테고리에 등록된 상품이 없습니다.
                    </div>
                </c:if>

            </section>

        </c:forEach>

    </main>

    </body>
</html>