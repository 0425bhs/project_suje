<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>주문서 작성</title>

        <link rel="stylesheet" href="/css/product/product_main.css">
        <link rel="stylesheet" href="/css/order-payment.css">

        <script src="/js/product_main.js" defer></script>
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

                                        <c:if test="${not empty vo.option_id}">
                                            <input type="hidden" name="option_id" value="${vo.option_id}">
                                        </c:if>
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

                                        <c:if test="${not empty vo.option_name}">
                                            <p class="order-option-text">
                                                옵션 : ${vo.option_name}

                                                <c:if test="${vo.option_price gt 0}">
                                                    (+<fmt:formatNumber value="${vo.option_price}" pattern="#,###" />원)
                                                </c:if>
                                            </p>
                                        </c:if>

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
                                </div>
                            </c:forEach>

                            <div class="artist-note">
                                <strong>작가 안내</strong>
                                <p>핸드메이드 상품은 결제 완료 후 제작 및 포장 준비가 시작됩니다.</p>
                            </div>
                        </div>

                        <aside class="panel side-panel">
                            <h3 class="panel-title">결제 요약</h3>

                            <div class="summary-line">
                                <span>총 상품금액</span>
                                <strong><fmt:formatNumber value="${totalOriginPrice}" pattern="#,###" />원</strong>
                            </div>

                            <div class="summary-line discount">
                                <span>즉시 할인금액</span>
                                <strong>
                                    -<fmt:formatNumber value="${totalDiscountPrice}" pattern="#,###" />원
                                </strong>
                            </div>

                            <div class="summary-line discount">
                                <span>쿠폰 할인금액</span>
                                <strong>
                                    -<fmt:formatNumber value="${couponPrice}" pattern="#,###" />원
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
                                <strong><fmt:formatNumber value="${totalDeliveryFee}" pattern="#,###" />원</strong>
                            </div>

                            <div class="summary-total">
                                <span>총 결제금액</span>
                                <strong><fmt:formatNumber value="${paymentPrice}" pattern="#,###" />원</strong>
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

    </body>
</html>