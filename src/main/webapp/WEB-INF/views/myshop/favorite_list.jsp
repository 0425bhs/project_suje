<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="tab" value="${empty selectedTab ? 'all' : selectedTab}" />

<!-- 빠른 메뉴 -->
<jsp:include page="/WEB-INF/views/myshop/common/myshop_quick_card.jsp" />

<!-- 관심 상태 요약 -->
<section class="myshop-status-card favorite-status-card">

    <button type="button"
            class="${tab eq 'all' ? 'active' : ''}"
            onclick="location.href='/myshop/my_favorite_list.do'">
        <span>전체</span>
        <strong>${totalCount}</strong>
    </button>

    <button type="button"
            class="${tab eq 'product' ? 'active' : ''}"
            onclick="location.href='/myshop/my_favorite_list.do?tab=product'">
        <span>찜한 상품</span>
        <strong>${productFavoriteCount}</strong>
    </button>

    <button type="button"
            class="${tab eq 'seller' ? 'active' : ''}"
            onclick="location.href='/myshop/my_favorite_list.do?tab=seller'">
        <span>찜한 작가</span>
        <strong>${sellerFavoriteCount}</strong>
    </button>

</section>

<!-- 관심 목록 -->
<section class="myshop-order-section">

    <div class="myshop-section-head">
        <div>
            <h2>관심 목록</h2>
            <p>찜한 상품과 찜한 작가를 확인할 수 있습니다.</p>
        </div>

        <a href="/myshop/my_favorite_list.do">전체보기</a>
    </div>

    <!-- 찜한 상품 -->
    <c:if test="${tab eq 'all' or tab eq 'product'}">

        <div class="favorite-block">

            <div class="favorite-block-title">
                <h3>찜한 상품</h3>
                <span>${productFavoriteCount}개</span>
            </div>

            <c:choose>
                <c:when test="${empty favoriteProductList}">
                    <div class="myshop-empty-order">
                        찜한 상품이 없습니다.
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="myshop-order">

                        <c:forEach var="item" items="${favoriteProductList}">

                            <article class="myshop-order-card">

                                <div class="myshop-order-top">
                                    <div>
                                        <strong class="myshop-status-badge favorite-product-badge">
                                            찜한 상품
                                        </strong>
                                    </div>

                                    <a href="/product_detail.do?product_id=${item.product_id}">
                                        상품상세 &gt;
                                    </a>
                                </div>

                                <div class="myshop-order-body">

                                    <div class="myshop-product-thumb">
                                        <c:choose>

                                            <c:when test="${not empty item.image_l and item.image_l ne 'no_file'}">
                                                <img src="/upload/${item.image_l}" alt="${item.name}">
                                            </c:when>

                                            <c:otherwise>
                                                <img src="/images/no_image.png" alt="이미지 없음">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="myshop-product-info">

                                        <p class="myshop-product-date">
                                            찜한 날짜 ${item.created_at}
                                        </p>

                                        <h3>
                                            <a href="/product_detail.do?product_id=${item.product_id}">
                                                ${item.name}
                                            </a>
                                        </h3>

                                        <p class="favorite-seller-name">
                                            ${item.company_name}
                                        </p>

                                        <div class="myshop-product-price">
                                            <c:choose>
                                                <c:when test="${item.sale_price > 0 and item.sale_price < item.price}">
                                                    <span class="origin-price">
                                                        <fmt:formatNumber value="${item.price}" pattern="#,###" />원
                                                    </span>

                                                    <strong>
                                                        <fmt:formatNumber value="${item.sale_price}" pattern="#,###" />원
                                                    </strong>
                                                </c:when>

                                                <c:otherwise>
                                                    <strong>
                                                        <fmt:formatNumber value="${item.price}" pattern="#,###" />원
                                                    </strong>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                    </div>

                                    <div class="myshop-order-actions">

                                        <button type="button"
                                                onclick="location.href='/product_detail.do?product_id=${item.product_id}'">
                                            상품 보기
                                        </button>

                                        <form action="/favorite_product_cancel.do" method="post">
                                            <input type="hidden" name="product_id" value="${item.product_id}">
                                            <button type="submit" class="danger">
                                                찜 삭제
                                            </button>
                                        </form>

                                    </div>

                                </div>

                            </article>

                        </c:forEach>

                    </div>
                </c:otherwise>
            </c:choose>

        </div>

    </c:if>

    <!-- 찜한 작가 -->
    <c:if test="${tab eq 'all' or tab eq 'seller'}">

        <div class="favorite-block">

            <div class="favorite-block-title">
                <h3>찜한 작가</h3>
                <span>${sellerFavoriteCount}명</span>
            </div>

            <c:choose>
                <c:when test="${empty favoriteSellerList}">
                    <div class="myshop-empty-order">
                        찜한 작가가 없습니다.
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="myshop-order">

                        <c:forEach var="seller" items="${favoriteSellerList}">

                            <article class="myshop-order-card">

                                <div class="myshop-order-top">
                                    <div>
                                        <strong class="myshop-status-badge favorite-seller-badge">
                                            찜한 작가
                                        </strong>
                                    </div>

                                    <a href="/seller_shop_homepage.do?seller_id=${seller.seller_id}">
                                        작가샵 &gt;
                                    </a>
                                </div>

                                <div class="myshop-order-body">

                                    <div class="myshop-product-thumb seller-thumb">
                                        <c:choose>
                                            <c:when test="${not empty seller.photo_name and seller.photo_name ne 'no_file'}">
                                                <img src="/upload/${seller.photo_name}" alt="${seller.company_name}">
                                            </c:when>

                                            <c:otherwise>
                                                <img src="/images/no_image.png" alt="이미지 없음">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="myshop-product-info">

                                        <p class="myshop-product-date">
                                            찜한 날짜
                                            ${fn:replace(fn:substring(seller.created_at, 0, 16), 'T', ' ')}
                                        </p>
                                        <h3>
                                            <a href="/seller_shop_homepage.do?seller_id=${seller.seller_id}">
                                                ${seller.company_name}
                                            </a>
                                        </h3>

                                        <p class="favorite-seller-name">
                                            Handmade Seller
                                        </p>

                                    </div>

                                    <div class="myshop-order-actions">

                                        <button type="button" onclick="location.href='/seller_shop_homepage.do?seller_id=${seller.seller_id}'">
                                            작가샵 보기
                                        </button>

                                        <form action="/favorite_seller_cancel_mypage.do" method="post">
                                            <input type="hidden" name="seller_id" value="${seller.seller_id}">
                                            <button type="submit" class="danger">
                                                찜 삭제
                                            </button>
                                        </form>

                                    </div>

                                </div>

                            </article>

                        </c:forEach>

                    </div>
                </c:otherwise>
            </c:choose>

        </div>

    </c:if>

</section>
