<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>상품 상세</title>
        <link rel="stylesheet" href="/css/product/product_main.css">
        <script src="/js/product_main.js" defer></script>
        <script src="/js/cart.js" defer></script>
    </head>

    <body>
        <jsp:include page="/WEB-INF/views/product/product_header.jsp">
            <jsp:param name="activeMenu" value="detail" />
        </jsp:include>

        <div class="product-detail-page">

            <div class="product-detail-layout">

                <div class="product-detail-panel">
                    <h2 class="product-detail-title">상품 상세</h2>

                    <div class="product-detail-main">
                        <div class="product-detail-image-card">
                            <img class="product-detail-img" src="${vo.image_s}" alt="${vo.name}">

                            <div class="product-detail-card-info">
                                <span class="product-badge">무료배송</span>
                                <h3>${vo.name}</h3>
                                <p class="product-card-subtitle">${vo.description}</p>

                                <div class="product-detail-price-box">
                                    <c:choose>
                                        <c:when test="${vo.sale_price > 0 && vo.sale_price < vo.price}">

                                            <div class="price-top">
                                                <span class="price-rate">${vo.sale_rate}%</span>
                                                <span class="origin-price">
                                                    <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                                </span>
                                            </div>

                                            <div class="sale-price">
                                                <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                            </div>

                                        </c:when>

                                        <c:otherwise>
                                            <div class="sale-price">
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="new-review-line">
                                    <span class="review-star">★</span>
                                    <span class="review-score">
                                        <fmt:formatNumber value="${vo.review_avg}" pattern="0.00"/>
                                    </span>
                                    <span class="review-dot">·</span>
                                    <span class="review-count">리뷰 ${vo.review_count}</span>
                                </div>
                            </div>
                        </div>

                        <div class="product-detail-info">
                            <div class="product-label">
                                <a href="/seller_shop_homepage.do?seller_id=${vo.seller_id}">
                                    ${vo.company_name}샵 보기
                                </a>
                            </div>

                            <p>재고: ${vo.stock}개</p>
                            <p>배송비: <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원</p>
                            <p>무료배송 조건:
                                <c:choose>
                                    <c:when test="${vo.free_shipping > 0}">
                                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상 구매 시 무료배송
                                    </c:when>
                                    <c:otherwise>
                                        무료배송 조건 없음
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <p>
                                판매자 : <a href="/seller_shop_homepage.do?seller_id=${vo.seller_id}">${vo.company_name}</a>
                            </p>
                        </div>
                    </div>

                    <div class="product-detail-desc">
                        <strong>상세정보</strong>
                        <p>${vo.description}</p>
                    </div>
                </div>

                <div class="product-order-box">
                    <h3>주문 선택</h3>

                    <form action="/order/form" method="get">
                        <input type="hidden" name="product_id" value="${vo.product_id}">

                        <div class="product-summary-line">
                            <span>수량</span>
                            <strong>
                                <input class="product-quantity" id="quantity" type="number" name="quantity" value="1" min="1">
                            </strong>
                        </div>

                        <div class="product-summary-line">
                            <span>배송비</span>
                            <strong>
                                <fmt:formatNumber value="${vo.delivery_fee}" pattern="#,###"/>원
                            </strong>
                        </div>

                        <div class="product-summary-line">
                            <span>무료배송</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${vo.free_shipping > 0}">
                                        <fmt:formatNumber value="${vo.free_shipping}" pattern="#,###"/>원 이상
                                    </c:when>

                                    <c:otherwise>
                                        조건 없음
                                    </c:otherwise>
                                </c:choose>
                            </strong>
                        </div>

                        <div class="product-summary-total">
                            <span>판매가</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${vo.sale_price > 0}">
                                        <fmt:formatNumber value="${vo.sale_price}" pattern="#,###"/>원
                                    </c:when>

                                    <c:otherwise>
                                        <fmt:formatNumber value="${vo.price}" pattern="#,###"/>원
                                    </c:otherwise>
                                </c:choose>
                            </strong>
                        </div>

                        <div class="product-btn-row">
                            <button type="submit" class="product-btn primary full">
                                주문하기
                            </button>
                        </div>
                    </form>

                    <input type="hidden" id="product_id" value="${vo.product_id}">
                    <div class="product-btn-row">
                        <button type="button" class="product-btn primary full" onclick="cartInsert()">
                            장바구니 담기
                        </button>
                    </div>

                    <div class="product-btn-row">
                        <a class="product-btn light full" href="/product/main.do">
                            상품 목록으로
                        </a>
                    </div>
                </div>

                <div class="product-review-box">
                    <strong>리뷰</strong>

                    <c:choose>
                        <c:when test="${empty review_list}">
                            <p>아직 등록된 리뷰가 없습니다.</p>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="review" items="${review_list}">
                                <div class="review-item">
                                    <div>
                                        <span class="review-star">★</span>
                                        <strong>${review.rating}</strong>
                                    </div>

                                    <p>${review.content}</p>
                                    <small>${review.created_at}</small>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>

        </div>

        <footer class="product-footer">
            <div class="product-footer-inner">
                <strong>HANDMADE</strong>
                <p>작가 상품을 둘러보고 마음에 드는 작품을 주문할 수 있습니다.</p>
            </div>
        </footer>

    </body>

</html>