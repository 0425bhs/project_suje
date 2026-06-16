<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 베스트</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_card.css">
        <link rel="stylesheet" href="/css/product/product_best_list.css?v=3">

        <script src="/js/product_main.js" defer></script>
        <script src="/js/product_best_list.js" defer></script>
    </head>

    <body>

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


        <!-- 카테고리별 베스트 -->
        <c:forEach var="big" items="${bigCategoryList}">

            <section class="best-category-section" id="best-category-${big.category_id}">

                <div class="best-section-title-row">
                    <h2>${big.name} 베스트</h2>

                    <a href="/category_list.do?category_id=${big.category_id}">
                        더보기 〉
                    </a>
                </div>

                <div class="common-product-wrap">

                    <c:set var="rank" value="0" />

                    <c:forEach var="vo" items="${list}">

                        <c:set var="isMatch" value="${vo.category_id eq big.category_id}" />

                        <c:forEach var="small" items="${smallCategoryList}">
                            <c:if test="${small.parent_id eq big.category_id and vo.category_id eq small.category_id}">
                                <c:set var="isMatch" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${isMatch and rank lt 10}">

                            <c:set var="rank" value="${rank + 1}" />

                            <div class="best-card-wrap">

                                <span class="best-rank-badge">
                                    ${rank}
                                </span>

                                <%@ include file="/WEB-INF/views/product/product_card.jspf" %>

                            </div>

                        </c:if>

                    </c:forEach>

                </div>

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