<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>HANDMADE - 할인</title>

        <!-- 메인 상단바 공통 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_card.css">
        <link rel="stylesheet" href="/css/product/product_sale_list.css">

        <!-- 전체 카테고리 열고 닫는 JS -->
        <script src="/js/product_main.js" defer></script>

        <!-- 할인 페이지 JS -->
        <script src="/js/product_sale_list.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="sale" />
    </jsp:include>

    <c:set var="totalSaleCount" value="${saleCount == null ? 0 : saleCount}" />
    <c:set var="sortValue" value="${empty currentSort ? 'popular' : currentSort}" />
    <c:set var="saleTypeValue" value="${empty currentSaleType ? 'all' : currentSaleType}" />

    <div class="sale-page">

        <!-- 상단 할인 슬라이드 -->
        <section class="sale-hero">
            <div class="sale-hero-inner">

                <h1>지금 진행 중인 특별 할인</h1>

                <!-- 할인 타이머 -->
                <div class="sale-countdown">
                    <strong id="saleHour">00</strong>
                    <span>:</span>
                    <strong id="saleMinute">00</strong>
                    <span>:</span>
                    <strong id="saleSecond">00</strong>
                </div>

                <c:choose>
                    <c:when test="${empty list}">
                        <div class="sale-empty">
                            현재 할인 중인 상품이 없습니다.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="sale-feature-wrap">

                            <button type="button" class="sale-slide-btn sale-slide-prev" id="salePrevBtn">
                                ‹
                            </button>

                            <button type="button" class="sale-slide-btn sale-slide-next" id="saleNextBtn">
                                ›
                            </button>

                            <div class="sale-feature-viewport">
                                <div class="sale-feature-track common-product-wrap" id="saleFeatureTrack">
                                    <c:forEach var="vo" items="${list}">
                                        <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="sale-feature-dots" id="saleFeatureDots"></div>

                            <a href="#saleList" class="sale-more-btn">
                                할인작품 더보기 〉
                            </a>

                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </section>


        <!-- 할인 유형 탭 -->
        <section class="sale-type-section">
            <div class="sale-type-tabs">

                <a class="${saleTypeValue == 'all' ? 'active' : ''}"
                href="/product_sale.do?saleType=all&sort=${sortValue}">
                    전체 할인
                </a>

                <a class="${saleTypeValue == 'period' ? 'active' : ''}"
                href="/product_sale.do?saleType=period&sort=${sortValue}">
                    기간 할인
                </a>

                <a class="${saleTypeValue == 'always' ? 'active' : ''}"
                href="/product_sale.do?saleType=always&sort=${sortValue}">
                    상시 할인
                </a>

            </div>
        </section>


        <!-- 하단 할인 목록 -->
        <section class="sale-list-section" id="saleList">

            <div class="sale-sort-row">
                <div class="sale-sort-left">

                    <c:choose>
                        <c:when test="${sortValue == 'popular'}">
                            <strong>✓ 인기순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=popular">인기순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'new'}">
                            <strong>✓ 최신순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=new">최신순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'likes'}">
                            <strong>✓ 찜 많은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=likes">찜 많은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'reviews'}">
                            <strong>✓ 구매후기 많은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=reviews">구매후기 많은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'sales'}">
                            <strong>✓ 판매수 많은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=sales">판매수 많은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'discount'}">
                            <strong>✓ 할인율 높은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=discount">할인율 높은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'lowPrice'}">
                            <strong>✓ 낮은 가격순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=lowPrice">낮은 가격순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue == 'highPrice'}">
                            <strong>✓ 높은 가격순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&sort=highPrice">높은 가격순</a>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

            <p class="sale-count-text">
                총 <fmt:formatNumber value="${totalSaleCount}" pattern="#,###"/>개
            </p>

            <c:choose>
                <c:when test="${empty list}">
                    <div class="sale-empty">
                        현재 할인 중인 상품이 없습니다.
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

            <div class="sale-page-menu">
                ${pageMenu}
            </div>

        </section>

    </div>


    <footer class="product-footer">
        <div class="product-footer-inner">
            <strong>HANDMADE</strong>
            <p>작가 상품을 둘러보고 마음에 드는 작품을 주문할 수 있습니다.</p>
        </div>
    </footer>

    </body>
</html>