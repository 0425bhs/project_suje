<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>HANDMADE - 판매자샵</title>

        <!-- 공통 상단 헤더 CSS가 product_main.css 안에 있으니까 이거 사용 -->
        <link rel="stylesheet" href="/css/product/product_main.css">

        <!-- 구매자용 판매자샵 전용 CSS -->
        <link rel="stylesheet" href="/css/seller/seller_shop_homepage.css">

        <script src="/js/product_main.js" defer></script>
        <script src="/js/seller_shop_homepage.js" defer></script>
        
    </head>

    <body>

    <jsp:include page="/WEB-INF/views/product/product_header.jsp">
        <jsp:param name="activeMenu" value="shop" />
    </jsp:include>

        <div class="shop-breadcrumb">
            <div class="shop-inner">
                HANDMADE 홈 &gt; 판매자샵
            </div>
        </div>

        <main class="buyer-shop">

            <section class="buyer-shop-header">

                <div class="seller-profile">
                    <div class="seller-logo">
                        <c:choose>
                            <c:when test="${not empty seller.photo_name and seller.photo_name ne 'no_file'}">
                                <img src="/upload/${seller.photo_name}" alt="${seller.company_name}">
                            </c:when>

                            <c:otherwise>
                                <img src="/images/no_image.png" alt="이미지 없음">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div>
                        <h2>${seller.company_name}</h2>  
                        <div class="seller-shop-stats">
                            <strong class="seller-interest-count">
        
                                팔로워 
                                <span id="sellerFavoriteCount" data-raw-count="${favoriteCount}">
                                    ${sellerFavoriteCountText}
                                </span>
                                | 관심
                                <span id="sellerProductFavoriteCount" data-raw-count="${seller.product_favorite_count}">
                                    ${productFavoriteCountText}
                                </span>
                            </strong>

                            <div class="seller-rating-box">
                                <span class="seller-star-wrap" style="--rating-percent:${seller.review_avg * 20}%;">
                                    <span class="seller-star-base">★★★★★</span>
                                    <span class="seller-star-fill">★★★★★</span>
                                </span>

                                <strong>
                                    <fmt:formatNumber value="${seller.review_avg}" pattern="0.0" />
                                </strong>

                                <span class="seller-review-count">
                                    (<fmt:formatNumber value="${seller.review_count}" pattern="#,###" />)
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <button type="button" class="wish-shop-btn ${favorite ? 'active' : ''}" id="sellerWishBtn" data-seller-id="${seller_id}">
                    <span class="wish-shop-heart">
                        ${favorite ? '♥' : '♡'}
                    </span>
                    <span class="wish-shop-text">
                        ${favorite ? '찜 취소' : '작가샵 찜하기'}
                    </span>
                </button>

            </section>

            <nav class="buyer-shop-tabs">
                <a href="#" class="active">홈</a>
                <a href="#">전체 상품</a>
                <a href="#">할인상품</a>
                <a href="#">후기</a>
            </nav>

            <section class="buyer-shop-toolbar">

                <div class="sort-box">

                    <a href="/seller_shop_homepage.do?seller_id=${seller_id}&sort=rank"
                    class="${sort eq 'rank' or empty sort ? 'active' : ''}">
                        랭킹순
                    </a>

                    <span>|</span>

                    <a href="/seller_shop_homepage.do?seller_id=${seller_id}&sort=lowPrice"
                    class="${sort eq 'lowPrice' ? 'active' : ''}">
                        낮은가격순
                    </a>

                    <span>|</span>

                    <a href="/seller_shop_homepage.do?seller_id=${seller_id}&sort=highPrice"
                    class="${sort eq 'highPrice' ? 'active' : ''}">
                        높은가격순
                    </a>

                    <span>|</span>

                    <a href="/seller_shop_homepage.do?seller_id=${seller_id}&sort=sales"
                    class="${sort eq 'sales' ? 'active' : ''}">
                        판매량순
                    </a>

                    <span>|</span>

                    <a href="/seller_shop_homepage.do?seller_id=${seller_id}&sort=new"
                    class="${sort eq 'new' ? 'active' : ''}">
                        최신순
                    </a>

                </div>

                <form class="shop-search" action="/seller_shop_homepage.do" method="get">
                    <input type="hidden" name="seller_id" value="${seller_id}">
                    <input type="hidden" name="sort" value="${sort}">
                    <input type="text" name="keyword" value="${keyword}" placeholder="샵 내에서 상품을 검색하세요.">
                    <button type="submit">🔍</button>
                </form>

            </section>

            <section class="buyer-product-grid">

                <c:forEach var="vo" items="${list}">

                    <div class="buyer-product-card">

                        <a class="product-img-box" href="/product_detail.do?product_id=${vo.product_id}">
                            <c:choose>
                                <c:when test="${not empty vo.image_l and vo.image_l ne 'no_file'}">
                                    <img src="/upload/${vo.image_l}" alt="${vo.name}">
                                </c:when>

                                <c:otherwise>
                                    <img src="/images/no_image.png" alt="이미지 없음">
                                </c:otherwise>
                            </c:choose>
                        </a>

                        <div class="product-name">
                            <a href="/product_detail.do?product_id=${vo.product_id}">
                                ${vo.name}
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                                <p class="origin-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </p>

                                <p class="sale-price">
                                    <strong>${vo.sale_rate}%</strong>
                                    <span>
                                        <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                    </span>
                                </p>
                            </c:when>

                            <c:otherwise>
                                <p class="product-price">
                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                </p>
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${vo.delivery_fee == 0}">
                                <p class="delivery-info">무료배송</p>
                            </c:when>

                            <c:when test="${vo.free_shipping > 0}">
                                <p class="delivery-info">
                                    <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 무료배송
                                </p>
                            </c:when>

                            <c:otherwise>
                                <p class="delivery-info">
                                    배송비 <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                                </p>
                            </c:otherwise>
                        </c:choose>

                    </div>

                </c:forEach>

            </section>

        </main>

    </body>
</html>