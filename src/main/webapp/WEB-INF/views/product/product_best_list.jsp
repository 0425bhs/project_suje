<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>HANDMADE - 베스트</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_best_list.css">

        <script src="/js/product_main.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="best" />
    </jsp:include>

    <main class="best-page" id="bestTop">

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


        <c:forEach var="big" items="${bigCategoryList}">

            <section class="best-category-section" id="best-category-${big.category_id}">

                <div class="best-section-title-row">
                    <h2>${big.name}</h2>

                    <a href="/category_list.do?category_id=${big.category_id}">
                        더보기 〉
                    </a>
                </div>

                <div class="best-product-grid">

                    <c:set var="rank" value="0" />

                    <c:forEach var="vo" items="${list}">

                        <c:set var="isMatch" value="${vo.category_id == big.category_id}" />

                        <c:forEach var="small" items="${smallCategoryList}">
                            <c:if test="${small.parent_id == big.category_id and vo.category_id == small.category_id}">
                                <c:set var="isMatch" value="true" />
                            </c:if>
                        </c:forEach>

                        <c:if test="${isMatch and rank < 10}">

                            <c:set var="rank" value="${rank + 1}" />

                            <a class="best-product-card"
                            href="/product_detail.do?product_id=${vo.product_id}">

                                <div class="best-product-img">

                                    <span class="best-rank">${rank}</span>

                                    <c:choose>
                                        <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                            <img src="${vo.image_l}" alt="${vo.name}">
                                        </c:when>

                                        <c:when test="${not empty vo.image_s and vo.image_s ne 'no_file'}">
                                            <img src="${vo.image_s}" alt="${vo.name}">
                                        </c:when>

                                        <c:otherwise>
                                            <img src="/images/no_image.png" alt="이미지 없음">
                                        </c:otherwise>
                                    </c:choose>

                                    <span class="best-heart">♡</span>

                                </div>

                                <div class="best-product-info">

                                    <p class="best-product-name">
                                        ${vo.name}
                                    </p>

                                    <c:choose>

                                        <c:when test="${vo.sale_price > 0}">
                                            <p class="best-origin-price">
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </p>

                                            <p class="best-sale-price">
                                                <span>${vo.sale_rate}%</span>
                                                <strong>
                                                    <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                                </strong>
                                            </p>
                                        </c:when>

                                        <c:otherwise>
                                            <p class="best-normal-price">
                                                <strong>
                                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                                </strong>
                                            </p>
                                        </c:otherwise>

                                    </c:choose>

                                    <p class="best-review">
                                        후기 준비중
                                    </p>

                                </div>

                            </a>

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