<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <title>HANDMADE - 할인</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/product/product_card.css">
        <link rel="stylesheet" href="/css/product/product_sale_list.css">

        <script src="/js/product_main.js" defer></script>
        <script src="/js/product_sale_list.js" defer></script>
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="sale" />
    </jsp:include>

    <c:set var="totalSaleCount" value="${saleCount == null ? 0 : saleCount}" />

    <div class="sale-page">

        <!-- 상단 할인 슬라이드 -->
        <section class="sale-hero">
            <div class="sale-hero-inner">

                <h1>오늘 하루만 특별 할인</h1>

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
                                <div class="sale-feature-track" id="saleFeatureTrack">

                                    <c:forEach var="vo" items="${list}">
                                        <a class="sale-feature-card"
                                        href="/product_detail.do?product_id=${vo.product_id}">

                                            <div class="sale-feature-img">
                                                <c:choose>
                                                    <c:when test="${vo.image_s != null && vo.image_s != 'no_file'}">
                                                        <img src="${vo.image_s}" alt="${vo.name}">
                                                    </c:when>

                                                    <c:otherwise>
                                                        <img src="/images/no_image.png" alt="이미지 없음">
                                                    </c:otherwise>
                                                </c:choose>

                                                <span class="sale-heart">♡</span>
                                            </div>

                                            <div class="sale-feature-info">
                                                <p class="sale-feature-name">${vo.name}</p>

                                                <div class="sale-feature-price">
                                                    <em>${vo.sale_rate}%</em>
                                                    <strong>
                                                        <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                                    </strong>
                                                </div>
                                            </div>

                                        </a>
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


        <!-- 하단 할인 목록 -->
        <section class="sale-list-section" id="saleList">

            <div class="sale-tab-menu">
                <button type="button" class="active">전체</button>
                <button type="button">깜짝할인</button>
                <button type="button">월할인</button>
                <button type="button">오늘만할인</button>
                <button type="button">시즌할인</button>
            </div>

            <div class="sale-filter-row">
                <button type="button">쿠폰/할인 ⌄</button>
                <button type="button">예상출발일 ⌄</button>
                <button type="button">가격대 ⌄</button>
                <button type="button">작품 특징 ⌄</button>
                <button type="button">카테고리 ⌄</button>
            </div>

            <div class="sale-sort-row">

                <div class="sale-sort-left">
                    <strong>✓ 인기순</strong>
                    <span>|</span>
                    <a href="#">최신순(NEW)</a>
                    <span>|</span>
                    <a href="#">찜 많은순</a>
                    <span>|</span>
                    <a href="#">구매후기 많은순</a>
                    <span>|</span>
                    <a href="#">판매수 많은순</a>
                    <span>|</span>
                    <a href="#">할인율 높은순</a>
                    <span>|</span>
                    <a href="#">낮은 가격순</a>
                    <span>|</span>
                    <a href="#">높은 가격순</a>
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