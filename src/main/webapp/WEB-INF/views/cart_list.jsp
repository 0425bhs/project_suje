<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>   

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

        <form action="/order_cart_form.do" method="post" name="cartForm" onsubmit="return cartOrderCheck();">

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

                        <c:set var="sellerOriginTotal" value="0" />
                        <c:set var="sellerItemTotal" value="0" />
                        <c:set var="sellerDiscountTotal" value="0" />

                        <div class="seller-cart-box" data-seller-id="${group.seller_id}">

                            <div class="seller-cart-head">
                                <label>
                                    <input type="checkbox" class="seller-check" data-seller-id="${group.seller_id}" checked onclick="sellerCartCheck(this)" />
                                    <span>${group.seller_name}</span>
                                </label>
                            </div>


                            <c:set var="prevProductId" value="-1" />

                            <c:forEach var="item" items="${group.itemList}" varStatus="status">

                                <c:set var="sellerOriginTotal" value="${sellerOriginTotal + item.origin_total}" />
                                <c:set var="sellerItemTotal" value="${sellerItemTotal + item.item_total}" />
                                <c:set var="sellerDiscountTotal" value="${sellerDiscountTotal + item.discount_total}" />

                                <c:if test="${prevProductId ne item.product_id}">

                                    <div class="cart-product-group"
                                        data-product-id="${item.product_id}">

                                        <div class="cart-product-head"
                                            data-product-id="${item.product_id}"
                                            onclick="goProductDetail(this)">

                                            <div class="cart-item-check">
                                                <input type="checkbox"
                                                    class="product-group-check"
                                                    data-seller-id="${group.seller_id}"
                                                    data-product-id="${item.product_id}"
                                                    checked
                                                    onclick="event.stopPropagation(); productGroupCheck(this);" />
                                            </div>

                                            <div class="cart-item-img-box">
                                                <c:choose>
                                                    <c:when test="${not empty item.image_l and fn:trim(item.image_l) ne 'no_file'}">
                                                        <c:set var="cartImagePath" value="${fn:trim(item.image_l)}" />

                                                        <c:choose>
                                                            <c:when test="${fn:startsWith(cartImagePath, '/upload/')}">
                                                                <img class="cart-product-img"
                                                                    src="${cartImagePath}"
                                                                    alt="${item.name}"
                                                                    onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=&quot;cart-no-image&quot;>이미지 없음</div>';">
                                                            </c:when>

                                                            <c:otherwise>
                                                                <img class="cart-product-img"
                                                                    src="/upload/${cartImagePath}"
                                                                    alt="${item.name}"
                                                                    onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=&quot;cart-no-image&quot;>이미지 없음</div>';">
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <div class="cart-no-image">이미지 없음</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="cart-product-head-info">

                                                <div class="cart-product-name">
                                                    ${item.name}
                                                </div>

                                                <c:choose>
                                                    <c:when test="${item.sale_price > 0 and item.sale_price < item.price}">
                                                        <div class="cart-price-box">
                                                            <p class="cart-origin-price">
                                                                <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
                                                            </p>

                                                            <p class="cart-sale-price">
                                                                <span>${item.sale_rate}%</span>
                                                                <strong>
                                                                    <fmt:formatNumber value="${item.sale_price}" pattern="#,###"/>원
                                                                </strong>
                                                            </p>
                                                        </div>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <p class="cart-normal-price">
                                                            <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
                                                        </p>
                                                    </c:otherwise>
                                                </c:choose>

                                            </div>

                                        </div>

                                        <div class="cart-option-list">
                                </c:if>

                                            <div class="cart-option-row"
                                                data-product-id="${item.product_id}"
                                                data-cart-id="${item.cart_id}">

                                                <input type="checkbox"
                                                    name="cart_id"
                                                    value="${item.cart_id}"
                                                    class="cart-check cart-option-check"
                                                    data-seller-id="${group.seller_id}"
                                                    data-product-id="${item.product_id}"
                                                    data-price="${item.item_total}"
                                                    data-origin-price="${item.origin_total}"
                                                    data-discount="${item.discount_total}"
                                                    data-delivery-fee="${item.delivery_fee}"
                                                    data-free-shipping="${item.free_shipping}"
                                                    checked
                                                    onclick="calcCartTotal();" />

                                                <div class="cart-option-name">
                                                    <c:choose>
                                                        <c:when test="${not empty item.option_name}">
                                                            ${item.option_name}
                                                        </c:when>
                                                        <c:otherwise>
                                                            기본 옵션
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="cart-quantity-box">

                                                    <button type="button"
                                                            class="cart-qty-btn"
                                                            onclick="event.stopPropagation(); cartQtyMinus(this)"
                                                            ${not empty item.option_id ? (item.option_stock le 0 ? 'disabled' : '') : (item.stock le 0 ? 'disabled' : '')}>
                                                        −
                                                    </button>

                                                    <input type="number"
                                                        class="cart-qty-input"
                                                        name="quantity"
                                                        value="${item.quantity}"
                                                        min="1"
                                                        max="${not empty item.option_id ? item.option_stock : item.stock}"
                                                        data-cart-id="${item.cart_id}"
                                                        onclick="event.stopPropagation();"
                                                        ${not empty item.option_id ? (item.option_stock le 0 ? 'disabled' : '') : (item.stock le 0 ? 'disabled' : '')} />

                                                    <button type="button"
                                                            class="cart-qty-btn"
                                                            onclick="event.stopPropagation(); cartQtyPlus(this)"
                                                            ${not empty item.option_id ? (item.option_stock le 0 ? 'disabled' : '') : (item.stock le 0 ? 'disabled' : '')}>
                                                        +
                                                    </button>

                                                </div>

                                                <div class="cart-option-price">
                                                    <fmt:formatNumber value="${item.item_total}" pattern="#,###"/>원
                                                </div>

                                                <button type="button"
                                                        class="cart-option-delete"
                                                        onclick="event.stopPropagation(); deleteOneCart(${item.cart_id});">
                                                    ×
                                                </button>

                                            </div>

                                <c:if test="${status.last or group.itemList[status.index + 1].product_id ne item.product_id}">
                                        </div>
                                    </div>
                                </c:if>

                                <c:set var="prevProductId" value="${item.product_id}" />

                            </c:forEach>

                            <div class="seller-delivery-row">

                                <div class="seller-delivery-main-line">
                                    <span class="delivery-tip-wrap">
                                        총 배송비

                                        <button type="button"
                                                class="delivery-tip-btn"
                                                onclick="toggleDeliveryTip(event, this)">
                                            ?
                                        </button>

                                        <div class="delivery-tip-box">
                                            <button type="button"
                                                    class="delivery-tip-close"
                                                    onclick="closeDeliveryTip(event, this)">
                                                ×
                                            </button>

                                            <strong>업체 배송</strong>

                                            <p>합배송 물품중에 무료배송 물품이 포함되면 무료배송</p>
                                            <p>무료배송 상품이 없다면 높은 택배비로 지불됩니다.</p>
                                        </div>
                                    </span>
                                    <strong class="seller-main-delivery-text ${group.delivery_fee == 0 ? 'delivery-free' : ''}">
                                        <c:choose>
                                            <c:when test="${group.delivery_fee == 0}">
                                                무료
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${group.delivery_fee}" pattern="#,###"/>원
                                            </c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>

                                <button type="button" class="seller-order-toggle" onclick="toggleSellerOrderSummary(this)">

                                    <span class="seller-order-title">예상 주문금액</span>

                                    <span class="seller-order-right">
                                        <strong class="seller-summary-total">
                                            <fmt:formatNumber value="${sellerItemTotal + group.delivery_fee}" pattern="#,###"/>원
                                        </strong>
                                        <span class="seller-order-arrow">∨</span>
                                    </span>

                                </button>

                                <div class="seller-order-detail">

                                    <div class="seller-order-detail-row">
                                        <span>선택상품금액</span>
                                        <strong class="seller-detail-product-total">
                                            <fmt:formatNumber value="${sellerOriginTotal}" pattern="#,###"/>원
                                        </strong>
                                    </div>

                                    <div class="seller-order-detail-row discount">
                                        <span>즉시할인예상금액</span>
                                        <strong class="seller-detail-discount-total">
                                            -<fmt:formatNumber value="${sellerDiscountTotal}" pattern="#,###"/>원
                                        </strong>
                                    </div>

                                    <div class="seller-order-detail-row discount">
                                        <span>쿠폰할인예상금액</span>
                                        <strong>0원</strong>
                                    </div>

                                    <div class="seller-order-detail-row">
                                        <span>
                                            배송비
                                        </span>
                                        <strong class="seller-detail-delivery-fee">
                                            <fmt:formatNumber value="${group.delivery_fee}" pattern="#,###"/>원
                                        </strong>
                                    </div>

                                    <div class="seller-order-detail-final">
                                        <span>총 주문금액</span>
                                        <strong class="seller-detail-final-total">
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