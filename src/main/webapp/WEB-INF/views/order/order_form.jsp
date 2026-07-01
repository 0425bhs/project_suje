<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>주문서 작성</title>

    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css">

    <script src="/js/product_main.js" defer></script>
    <script src="/js/order_form.js" defer></script>
    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
        function openAddressModal() {
            document.getElementById("addressModal").classList.add("open");
        }

        function closeAddressModal() {
            document.getElementById("addressModal").classList.remove("open");
        }

        function selectAddressButton(button) {
            const id = button.dataset.id;
            const name = button.dataset.name;
            const address = button.dataset.address;

            document.getElementById("selectedAddressId").value = id;
            document.getElementById("selectedAddressText").innerText = name + " | " + address;

            closeAddressModal();
        }

        function search() {
            new kakao.Postcode({
                oncomplete: function (data) {
                    alert("선택된 주소: " + data.roadAddress + " (" + data.zonecode + ")");
                }
            }).open();
        }
    </script>
</head>

<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="detail" />
</jsp:include>

<section class="page-block soft">
    <div class="block-inner">

        <div class="page-title-row">
            <div>
                <span>ORDER FORM</span>
                <h2>주문서 작성</h2>
            </div>
            <p>주문 상품과 결제 금액을 확인합니다.</p>
        </div>

        <form action="/order/create" method="post">

            <input type="hidden" id="totalItemPrice" value="${totalItemPrice}">
            <input type="hidden" id="totalDeliveryFee" value="${totalDeliveryFee}">
            <input type="hidden" id="pointBalance" value="${empty pointBalance ? 0 : pointBalance}">

            <input type="hidden"
                   name="address_id"
                   id="selectedAddressId"
                   value="${defaultAddr.address_id}" />

            <div class="order-layout">

                <div class="panel">
                    <h3 class="panel-title">주문 상품</h3>

                    <c:forEach var="vo" items="${orderItemList}">
                        <c:choose>
                            <c:when test="${vo.cart_id ne 0}">
                                <input type="hidden" name="cart_id" value="${vo.cart_id}">
                            </c:when>

                            <c:otherwise>
                                <input type="hidden" name="product_id" value="${vo.product_id}">
                                <input type="hidden" name="quantity" value="${vo.quantity}">
                            </c:otherwise>
                        </c:choose>

                        <div class="order-item">

                            <c:choose>
                                <c:when test="${not empty vo.image_l and fn:trim(vo.image_l) ne 'no_file'}">
                                    <c:set var="orderImagePath" value="${fn:trim(vo.image_l)}" />

                                    <c:choose>
                                        <c:when test="${fn:startsWith(orderImagePath, '/upload/')}">
                                            <img src="${orderImagePath}"
                                                 alt="${vo.name}"
                                                 onerror="this.outerHTML='<div class=&quot;order-no-image&quot;>이미지 없음</div>';">
                                        </c:when>

                                        <c:otherwise>
                                            <img src="/upload/${orderImagePath}"
                                                 alt="${vo.name}"
                                                 onerror="this.outerHTML='<div class=&quot;order-no-image&quot;>이미지 없음</div>';">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>

                                <c:otherwise>
                                    <div class="order-no-image">이미지 없음</div>
                                </c:otherwise>
                            </c:choose>

                            <div class="item-info">
                                <div class="creator-line">작가 상품</div>
                                <strong>${vo.name}</strong>

                                <c:choose>
                                    <c:when test="${vo.sale_price > 0 and vo.sale_price < vo.price}">
                                        <div class="order-price-box">
                                            <p class="order-origin-price">
                                                <fmt:formatNumber value="${vo.price}" pattern="#,###" />원
                                            </p>

                                            <p class="order-sale-price">
                                                가격
                                                <strong>
                                                    <fmt:formatNumber value="${vo.item_price}" pattern="#,###" />원
                                                </strong>
                                            </p>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <p class="order-normal-price">
                                            가격
                                            <strong>
                                                <fmt:formatNumber value="${vo.item_price}" pattern="#,###" />원
                                            </strong>
                                        </p>
                                    </c:otherwise>
                                </c:choose>

                                <p>수량 ${vo.quantity}개</p>
                            </div>

                            <div class="item-price">
                                <strong>
                                    <fmt:formatNumber value="${vo.item_total}" pattern="#,###" />원
                                </strong>
                            </div>
                            <div class="cancel-modal-body">
                                <c:choose>
                                    <c:when test="${not empty param.product_id}">
                                        <c:set var="currentUrl"
                                            value="${pageContext.request.requestURL}${not empty pageContext.request.queryString ? '?'.concat(pageContext.request.queryString) : ''}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="currentUrl"
                                            value="${pageContext.request.contextPath}/order_cart_form.do" />
                                    </c:otherwise>
                                </c:choose>

                                <c:url value="/insertAddress.do" var="addAddressUrl">
                                    <c:param name="returnUrl" value="${currentUrl}" />
                                </c:url>

                                <div style="margin-bottom: 16px; display: flex; justify-content: flex-end;">
                                    <a href="${addAddressUrl}" class="btn light">+ 새 배송지 추가</a>
                                </div>

                                <div>
                                    <c:forEach var="addr" items="${list}">
                                        <div
                                            style="display:flex; justify-content:space-between; align-items:center; padding:14px 0; border-bottom:1px solid #eee;">
                                            <div>
                                                <c:if test="${addr.is_default == 'true'}">
                                                    <span class="default-badge">기본배송지</span>
                                                </c:if>
                                                <strong>${addr.address_name}</strong>
                                                <p style="margin:4px 0; color:#666; font-size:14px;">
                                                    ${addr.address} ${addr.detail_address}
                                                </p>
                                            </div>
                                            <button type="button" class="btn light"
                                                onclick="selectAddress(${addr.address_id}, '${addr.address_name}', '${addr.address} ${addr.detail_address}')">
                                                선택
                                            </button>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="artist-note">
                        <strong>작가 안내</strong>
                        <p>핸드메이드 상품은 결제 완료 후 제작 및 포장 준비가 시작됩니다.</p>
                    </div>

                    <div class="delivery-section">
                        <div class="artist-note"
                             style="display:flex; justify-content:space-between; align-items:center;">
                            <div>
                                <strong style="font-size:16px; font-weight:900; color:#171717;">배송지</strong>

                                <p id="selectedAddressText">
                                    ${defaultAddr.address_name} | ${defaultAddr.address} ${defaultAddr.detail_address}
                                </p>
                            </div>

                            <button type="button" class="btn light" onclick="openAddressModal()">
                                변경
                            </button>
                        </div>
                    </div>
                </div>

                <aside class="panel side-panel">
                    <h3 class="panel-title">결제 요약</h3>

                    <div class="summary-line">
                        <span>총 상품금액</span>
                        <strong>
                            <fmt:formatNumber value="${totalOriginPrice}" pattern="#,###" />원
                        </strong>
                    </div>

                    <div class="summary-line discount">
                        <span>즉시 할인금액</span>
                        <strong>
                            -<fmt:formatNumber value="${totalDiscountPrice}" pattern="#,###" />원
                        </strong>
                    </div>

                    <div class="summary-line">
                        <span>쿠폰 선택</span>

                        <strong>
                            <select name="user_coupon_id" id="userCouponId">
                                <option value="0" data-discount="0">쿠폰 사용 안 함</option>

                                <c:forEach var="coupon" items="${couponList}">
                                    <option value="${coupon.user_coupon_id}"
                                            data-discount="${coupon.discount_amount}">
                                        ${coupon.coupon_name}
                                        (-<fmt:formatNumber value="${coupon.discount_amount}" pattern="#,###" />원)
                                    </option>
                                </c:forEach>
                            </select>
                        </strong>
                    </div>

                    <div class="summary-line discount">
                        <span>쿠폰 할인금액</span>
                        <strong>
                            <span id="couponPriceText">
                                -<fmt:formatNumber value="${couponPrice}" pattern="#,###" />원
                            </span>
                        </strong>
                    </div>

                    <div class="summary-line">
                        <span>보유 포인트</span>
                        <strong>
                            <fmt:formatNumber value="${empty pointBalance ? 0 : pointBalance}" pattern="#,###" /> P
                        </strong>
                    </div>

                    <div class="summary-line">
                        <span>사용 포인트</span>

                        <strong>
                            <input type="number"
                                   name="use_point"
                                   id="usePointInput"
                                   min="0"
                                   max="${empty pointBalance ? 0 : pointBalance}"
                                   value="0">

                            <button type="button" id="useAllPointBtn">
                                전액사용
                            </button>
                        </strong>
                    </div>

                    <div class="summary-line discount">
                        <span>포인트 할인</span>
                        <strong id="pointPriceText">
                            -0원
                        </strong>
                    </div>

                    <div class="summary-line">
                        <span>상품 금액</span>
                        <strong>
                            <fmt:formatNumber value="${totalItemPrice}" pattern="#,###" />원
                        </strong>
                    </div>

                    <div class="summary-line">
                        <span>배송비</span>
                        <strong>
                            <fmt:formatNumber value="${totalDeliveryFee}" pattern="#,###" />원
                        </strong>
                    </div>

                    <div class="summary-total">
                        <span>총 결제금액</span>
                        <strong id="paymentPriceText">
                            <fmt:formatNumber value="${paymentPrice}" pattern="#,###" />원
                        </strong>
                    </div>

                    <div class="btn-row">
                        <button type="submit" class="btn primary full">
                            주문하고 결제하기
                        </button>
                    </div>
                </aside>

            </div>
        </form>
    </div>
</section>

<footer class="site-footer">
    <div class="footer-inner">
        <strong>HANDMADE</strong>
        <p>주문 상품과 결제 금액을 확인한 뒤 결제를 진행합니다.</p>
    </div>
</footer>

<div class="cancel-modal-wrap" id="addressModal">
    <div class="cancel-modal-bg" onclick="closeAddressModal()"></div>

    <div class="cancel-modal-box">
        <div class="cancel-modal-head">
            <h3>배송지 선택</h3>

            <button type="button"
                    class="cancel-modal-close"
                    onclick="closeAddressModal()">
                ×
            </button>
        </div>

        <div class="cancel-modal-body">
            <div style="margin-bottom: 16px; display: flex; justify-content: flex-end;">
                <a href="/insertAddress.do" class="btn light">+ 새 배송지 추가</a>
            </div>

            <div>
                <c:forEach var="addr" items="${list}">
                    <div style="display:flex; justify-content:space-between; align-items:center; padding:14px 0; border-bottom:1px solid #eee;">
                        <div>
                            <c:if test="${addr.is_default == 'true'}">
                                <span class="default-badge">기본배송지</span>
                            </c:if>

                            <strong>${addr.address_name}</strong>

                            <p style="margin:4px 0; color:#666; font-size:14px;">
                                ${addr.address} ${addr.detail_address}
                            </p>
                        </div>

                        <button type="button"
                            class="btn light"
                            data-id="${addr.address_id}"
                            data-name="${fn:escapeXml(addr.address_name)}"
                            data-address="${fn:escapeXml(addr.address)} ${fn:escapeXml(addr.detail_address)}"
                            onclick="selectAddressButton(this)">
                        선택
                    </button>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

</body>
</html>