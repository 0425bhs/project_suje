<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 할인</title>

        <!-- 상품 페이지 공통 레이아웃 CSS -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 공통 상품 카드 디자인 CSS -->
        <link rel="stylesheet" href="/css/product/product_card.css">

        <!-- 할인 상품 페이지 전용 CSS -->
        <link rel="stylesheet" href="/css/product/product_sale_list.css?v=14">

        <!-- 상품 공통 헤더, 카테고리 메뉴 관련 JS -->
        <script src="/js/product_main.js" defer></script>

        <!-- 할인 슬라이드, 카운트다운 관련 JS -->
        <script src="/js/product_sale_list.js" defer></script>
    </head>

    <body>

    <!-- 상품 공통 헤더에서 할인 메뉴를 활성화 -->
    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="sale" />
    </jsp:include>

    <!-- 정렬, 할인 유형, 총 상품 수 기본값 설정 -->
    <c:set var="sortValue" value="${empty currentSort ? 'popular' : currentSort}" />
    <c:set var="saleTypeValue" value="${empty currentSaleType ? 'all' : currentSaleType}" />
    <c:set var="totalSaleCount" value="${saleCount == null ? 0 : saleCount}" />

    <div class="sale-page">

        <!-- 상단 대표 할인 상품 슬라이드 영역 -->
        <section class="sale-hero">
            <div class="sale-hero-inner">

                <h1>지금 진행 중인 특별 할인</h1>

                <!-- 할인 카운트다운 표시 영역 -->
                <div class="sale-countdown">
                    <strong id="saleHour">00</strong>
                    <span>:</span>
                    <strong id="saleMinute">00</strong>
                    <span>:</span>
                    <strong id="saleSecond">00</strong>
                </div>

                <c:choose>
                    <c:when test="${empty saleFeatureList}">
                        <div class="sale-empty">
                            현재 할인 중인 상품이 없습니다.
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="sale-feature-wrap">

                            <!-- 할인 상품 슬라이드 이전 버튼 -->
                            <button type="button" class="sale-slide-btn sale-slide-prev" id="salePrevBtn">
                                ‹
                            </button>

                            <!-- 할인 상품 슬라이드 다음 버튼 -->
                            <button type="button" class="sale-slide-btn sale-slide-next" id="saleNextBtn">
                                ›
                            </button>

                            <!-- 상단 대표 할인 상품 목록 -->
                            <div class="sale-feature-viewport">
                                <div class="sale-feature-track common-product-wrap" id="saleFeatureTrack">
                                    <c:forEach var="vo" items="${saleFeatureList}">
                                        <%@ include file="/WEB-INF/views/product/product_card.jspf" %>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- 슬라이드 페이지 점 표시 영역 -->
                            <div class="sale-feature-dots" id="saleFeatureDots"></div>

                            <!-- 하단 할인 목록으로 이동 -->
                            <a href="#saleList" class="sale-more-btn">
                                할인작품 더보기 〉
                            </a>

                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </section>


        <!-- 할인 유형 탭: 전체 할인 / 기간 할인 / 상시 할인 -->
        <section class="sale-type-section">
            <div class="sale-type-tabs">

                <a class="${saleTypeValue eq 'all' ? 'active' : ''}"
                href="/product_sale.do?saleType=all&amp;sort=${sortValue}">
                    전체 할인
                </a>

                <a class="${saleTypeValue eq 'period' ? 'active' : ''}"
                href="/product_sale.do?saleType=period&amp;sort=${sortValue}">
                    기간 할인
                </a>

                <a class="${saleTypeValue eq 'always' ? 'active' : ''}"
                href="/product_sale.do?saleType=always&amp;sort=${sortValue}">
                    상시 할인
                </a>

            </div>
        </section>


        <!-- 하단 할인 상품 목록 영역 -->
        <section class="sale-list-section" id="saleList">

            <div class="sale-sort-row">

                <!-- 현재 할인 유형은 유지하고 정렬 기준만 변경 -->
                <div class="sale-sort-left">

                    <c:choose>
                        <c:when test="${sortValue eq 'popular'}">
                            <strong>✓ 인기순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=popular">인기순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'new'}">
                            <strong>✓ 최신순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=new">최신순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'likes'}">
                            <strong>✓ 찜 많은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=likes">찜 많은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'reviews'}">
                            <strong>✓ 구매후기 많은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=reviews">구매후기 많은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'sales'}">
                            <strong>✓ 판매수 많은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=sales">판매수 많은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'discount'}">
                            <strong>✓ 할인율 높은순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=discount">할인율 높은순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'lowPrice'}">
                            <strong>✓ 낮은 가격순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=lowPrice">낮은 가격순</a>
                        </c:otherwise>
                    </c:choose>

                    <span>|</span>

                    <c:choose>
                        <c:when test="${sortValue eq 'highPrice'}">
                            <strong>✓ 높은 가격순</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="/product_sale.do?saleType=${saleTypeValue}&amp;sort=highPrice">높은 가격순</a>
                        </c:otherwise>
                    </c:choose>

                </div>

            </div>

            <!-- 현재 조건에 맞는 할인 상품 총 개수 -->
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

            <!-- 할인 상품 목록 페이징 -->
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