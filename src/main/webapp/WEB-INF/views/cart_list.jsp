<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>장바구니</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/cart.css">

    <script src="/js/cart.js" defer></script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="cart" />
</jsp:include>

<div class="cart-wrap">

    <div class="cart-top">
        <div class="cart-title">장바구니</div>

        <div class="cart-step">
            <span>01 옵션선택</span>
            <span>〉</span>
            <span class="active">02 장바구니</span>
            <span>〉</span>
            <span>03 주문/결제</span>
            <span>〉</span>
            <span>04 주문완료</span>
        </div>
    </div>

    <c:if test="${empty sellerGroupList}">
        <div class="empty-cart">
            장바구니에 담긴 상품이 없습니다.
        </div>
    </c:if>

    <c:if test="${not empty sellerGroupList}">

        <form action="/order_form.do" method="post" name="cartForm">

            <div class="cart-layout">

                <div class="cart-left">

                    <div class="cart-control-row">

                        <label class="cart-all-check">
                            <input type="checkbox" id="allCheck" checked onclick="allCartCheck()">
                            <span>전체 선택</span>
                        </label>

                        <div class="cart-btns">
                            <button type="button" class="cart-btn" onclick="deleteSelectedCart()">
                                선택삭제
                            </button>
                        </div>

                    </div>

                    <c:forEach var="group" items="${sellerGroupList}">

                        <c:set var="sellerItemTotal" value="0" />

                        <div class="seller-cart-box" data-seller-id="${group.seller_id}">

                            <div class="seller-cart-head">
                                <label>
                                    <input type="checkbox" class="seller-check" data-seller-id="${group.seller_id}" checked onclick="sellerCartCheck(this)" />
                                    <span>${group.seller_name}</span>
                                </label>
                            </div>


                            <c:forEach var="item" items="${group.itemList}">

                                <c:set var="sellerItemTotal" value="${sellerItemTotal + item.item_total}" />

                                <div class="cart-item-row" data-product-id="${item.product_id}" onclick="goProductDetail(this)">

                                    <div class="cart-item-check">
                                        <input type="checkbox" name="cart_id" value="${item.cart_id}" class="cart-check" data-seller-id="${group.seller_id}" data-price="${item.item_total}"
                                            data-origin-price="${item.origin_total}" data-discount="${item.discount_total}" checked onclick="event.stopPropagation(); calcCartTotal();" />
                                    </div>

                                    <div class="cart-item-img-box">
                                        <img class="cart-product-img" src="${item.image_l}" onerror="this.src='/images/no_image.png'" />
                                    </div>

                                    <div class="cart-item-info">

                                        <div class="cart-product-name">
                                            ${item.name}
                                        </div>

                                        <div class="cart-product-price">
                                            <fmt:formatNumber value="${item.item_price}" pattern="#,###"/>원
                                        </div>

                                        <div class="cart-quantity-box">

                                            <button type="button" class="cart-qty-btn" onclick="event.stopPropagation(); cartQtyMinus(this)"  ${item.stock le 0 ? 'disabled' : ''}>
                                                −
                                            </button>

                                            <input type="number" class="cart-qty-input" name="quantity" value="${item.quantity}" min="1" max="${item.stock}" data-cart-id="${item.cart_id}"
                                                onclick="event.stopPropagation();" ${item.stock le 0 ? 'disabled' : ''} />

                                            <button type="button" class="cart-qty-btn" onclick="event.stopPropagation(); cartQtyPlus(this)" ${item.stock le 0 ? 'disabled' : ''}>
                                                +
                                            </button>

                                        </div>

                                    </div>

                                    <div class="cart-item-total">
                                        <strong>
                                            <fmt:formatNumber value="${item.item_total}" pattern="#,###"/>원
                                        </strong>
                                    </div>

                                </div>

                            </c:forEach>

                            <div class="seller-delivery-row">

                                <button type="button"
                                        class="seller-order-toggle"
                                        onclick="toggleSellerOrderSummary(this)">

                                    <span class="seller-order-title">예상 주문금액</span>

                                    <span class="seller-order-right">
                                        <strong>
                                            <fmt:formatNumber value="${sellerItemTotal + group.delivery_fee}" pattern="#,###"/>원
                                        </strong>
                                        <span class="seller-order-arrow">∨</span>
                                    </span>

                                </button>

                                <div class="seller-order-detail">

                                    <div class="seller-delivery-line">
                                        <span>
                                            총 배송비
                                            <small>?</small>
                                        </span>

                                        <strong>
                                            <c:choose>
                                                <c:when test="${group.delivery_fee == 0}">
                                                    무료배송
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${group.delivery_fee}" pattern="#,###"/>원
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </div>

                                    <div class="seller-order-line">
                                        <span>예상 주문금액</span>

                                        <strong>
                                            <fmt:formatNumber value="${sellerItemTotal + group.delivery_fee}" pattern="#,###"/>원
                                        </strong>
                                    </div>

                                </div>

                                <input type="hidden" class="seller-delivery-fee" data-seller-id="${group.seller_id}" value="${group.delivery_fee}" />

                            </div>

                        </div>

                    </c:forEach>

                </div>

                <aside class="cart-order-side">

                    <div class="cart-order-box">

                        <h3>주문 예상 금액</h3>

                        <div class="order-price-row">
                            <span>총 선택상품금액</span>
                            <strong id="originTotal">
                                <fmt:formatNumber value="${totalOriginPrice}" pattern="#,###"/>원
                            </strong>
                        </div>

                        <div class="order-price-row discount">
                            <span>즉시할인예상금액</span>
                            <strong id="discountTotal">
                                -<fmt:formatNumber value="${totalDiscountPrice}" pattern="#,###"/>원
                            </strong>
                        </div>

                        <div class="order-price-row discount">
                            <span>쿠폰할인예상금액</span>
                            <strong id="couponTotal">
                                -<fmt:formatNumber value="${couponPrice}" pattern="#,###"/>원
                            </strong>
                        </div>

                        <div class="order-price-row">
                            <span>총 배송비</span>
                            <strong id="deliveryTotal">
                                +<fmt:formatNumber value="${totalDeliveryFee}" pattern="#,###"/>원
                            </strong>
                        </div>

                        <div class="order-final-row">
                            <span>총 주문 예상 금액</span>
                            <strong id="orderTotal">
                                <fmt:formatNumber value="${paymentPrice}" pattern="#,###"/>원
                            </strong>
                        </div>

                        <button type="submit" class="order-btn">
                            주문하기
                            <span id="orderCountBadge">0</span>
                        </button>

                    </div>

                </aside>

            </div>

        </form>

    </c:if>

</div>

</body>
</html>