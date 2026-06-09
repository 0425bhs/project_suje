<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>배송 상태 확인</title>
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
                        <span>DELIVERY</span>
                        <h2>배송 상태 확인</h2>
                    </div>
                    <p>작가 상품의 준비 상태와 배송 진행 상황을 확인합니다.</p>
                </div>

                <div class="info-box">
                    <div>
                        <span>주문번호</span>
                        <strong>${order.order_id}</strong>
                    </div>

                    <div>
                        <span>주문일</span>
                        <strong>${order.created_at}</strong>
                    </div>

                    <div>
                        <span>현재 상태</span>
                        <strong>
                            <span class="badge ${order.status}">
                                <c:choose>
                                    <c:when test="${order.status eq 'PENDING'}">주문 접수</c:when>
                                    <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                    <c:when test="${order.status eq 'PREPARING'}">제작/배송 준비중</c:when>
                                    <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                    <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                    <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                    <c:otherwise>${order.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </strong>
                    </div>
                </div>

                <div class="delivery-box">
                    <div class="delivery-steps">
                        <div class="delivery-step">
                            <div class="num">1</div>
                            <strong>주문 접수</strong>
                            <span>주문 확인</span>
                        </div>

                        <div class="delivery-step">
                            <div class="num">2</div>
                            <strong>결제 완료</strong>
                            <span>결제 확인</span>
                        </div>

                        <div class="delivery-step">
                            <div class="num">3</div>
                            <strong>상품 준비중</strong>
                            <span>제작/포장</span>
                        </div>

                        <div class="delivery-step">
                            <div class="num">4</div>
                            <strong>배송중</strong>
                            <span>배송 이동</span>
                        </div>

                        <div class="delivery-step">
                            <div class="num">5</div>
                            <strong>배송 완료</strong>
                            <span>수령 완료</span>
                        </div>
                    </div>

                    <div class="notice-box">
                        현재 주문 상태는
                        <strong>
                            <c:choose>
                                <c:when test="${order.status eq 'PENDING'}">주문 접수</c:when>
                                <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                <c:when test="${order.status eq 'PREPARING'}">제작/배송 준비중</c:when>
                                <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </strong>
                        입니다.
                    </div>

                    <div class="btn-row">
                        <a class="btn light" href="/order/detail?order_id=${order.order_id}">
                            주문 상세로
                        </a>
                        <a class="btn primary" href="/order/my">
                            내 주문 내역으로
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <footer class="site-footer">
            <div class="footer-inner">
                <strong>HANDMADE</strong>
                <p>작가 상품의 배송 진행 상황을 확인할 수 있습니다.</p>
            </div>
        </footer>

    </body>
</html>