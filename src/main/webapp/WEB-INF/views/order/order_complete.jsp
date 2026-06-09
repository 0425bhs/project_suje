<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>주문 완료</title>
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
                <div class="complete-box">
                    <div class="complete-icon">✓</div>

                    <h2>주문이 완료되었습니다</h2>
                    <p>작가의 손길이 담긴 상품 주문이 정상적으로 접수되었습니다.</p>

                    <div class="complete-detail">
                        <div>
                            <span>주문번호</span>
                            <strong>${order.order_id}</strong>
                        </div>

                        <div>
                            <span>총 결제금액</span>
                            <strong>${order.total_amount}원</strong>
                        </div>

                        <div>
                            <span>주문상태</span>
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

                        <div>
                            <span>결제상태</span>
                            <strong>
                                <span class="badge ${payment.status}">
                                    <c:choose>
                                        <c:when test="${payment.status eq 'READY'}">결제 대기</c:when>
                                        <c:when test="${payment.status eq 'SUCCESS'}">결제 완료</c:when>
                                        <c:when test="${payment.status eq 'FAIL'}">결제 실패</c:when>
                                        <c:otherwise>${payment.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </strong>
                        </div>
                    </div>

                    <div class="order-guide">
                        작가가 상품 제작 및 포장 준비를 시작하면 배송 상태가 변경됩니다.
                    </div>

                    <div class="btn-row">
                        <a class="btn light full" href="/order/detail?order_id=${order.order_id}">
                            주문 상세 보기
                        </a>
                        <a class="btn primary full" href="/order/my">
                            내 주문 내역 보기
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <footer class="site-footer">
            <div class="footer-inner">
                <strong>HANDMADE</strong>
                <p>작가의 손길이 담긴 상품을 주문하고 결제하는 공간입니다.</p>
            </div>
        </footer>

    </body>
</html>