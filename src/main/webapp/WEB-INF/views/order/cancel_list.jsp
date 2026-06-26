<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>취소/환불 내역</title>
    <link rel="stylesheet" href="/css/product/product_main.css">
    <link rel="stylesheet" href="/css/order-payment.css">
    <script src="/js/product_main.js" defer></script>
</head>
<body>

<jsp:include page="/WEB-INF/views/product/product_header.jsp">
    <jsp:param name="activeMenu" value="myshop" />
</jsp:include>

<section class="page-block soft">
    <div class="block-inner">
        <div class="page-title-row">
            <div>
                <span>MY SHOP</span>
                <h2>취소/환불 내역</h2>
            </div>
            <p>취소된 주문 내역을 확인합니다.</p>
        </div>

        <c:choose>
            <c:when test="${empty cancelList}">
                <div class="panel" style="text-align:center; padding: 60px;">
                    <p style="color:#777; font-size:16px;">취소된 주문이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="order" items="${cancelList}">
                    <div class="panel" style="margin-bottom: 20px;">


                        <!-- 취소 상품 목록 -->
                        <c:forEach var="item" items="${cancelItemMap[order.order_id]}">
                            <div class="order-item">
                                <img src="/upload/${item.imageL}"
                                     alt="${item.productName}"
                                     onerror="this.src='/images/no_image.png';">

                                <div class="item-info">
                                    <strong>${item.productName}</strong>
                                    <c:if test="${not empty item.optionName}">
                                        <p>옵션: ${item.optionName}</p>
                                    </c:if>
                                    <p>수량: ${item.quantity}개</p>
                                    <p>단가: <fmt:formatNumber value="${item.price}" pattern="#,###" />원</p>
                                </div>

                                <div class="item-price">
                                    <strong>
                                        <fmt:formatNumber value="${item.subtotalAmount}" pattern="#,###" />원
                                    </strong>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- 총 결제금액 -->
                        <div class="summary-total">
                            <span>총 결제금액</span>
                            <strong><fmt:formatNumber value="${order.total_amount}" pattern="#,###" />원</strong>
                        </div>


                         <!-- 주문 기본 정보 -->
                        <div class="info-box order-summary-box">

                            <div>
                                <span>취소일</span>
                                <strong>${order.cancelled_at}</strong>
                            </div>
                            <div>
                                <span>취소사유</span>
                                <strong>${not empty order.cancel_reason ? order.cancel_reason : '-'}</strong>
                            </div>
                        </div>

                        
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

    </div>
</section>

</body>
</html>