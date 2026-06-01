<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>내 주문 내역</title>
        <link rel="stylesheet" href="/css/order-payment.css">
    </head>

    <body>

    <header class="site-header">
        <div class="header-inner">
            <a class="brand" href="/product/list.do">
                HAND<span>MADE</span>
            </a>

            <nav class="main-nav">
                <a href="/product/list.do">상품보기</a>
                <a href="#">선물추천</a>
                <a href="#">베스트</a>
                <a href="#">취향발견</a>
                <a href="#">최신작품</a>
                <a href="#">작가</a>
            </nav>

            <div class="header-actions">
                <a href="/order/my">주문내역</a>
                <a href="#">관심</a>
                <a href="#">장바구니</a>
            </div>
        </div>
    </header>

    <c:set var="totalCount" value="0" />
    <c:set var="pendingCount" value="0" />
    <c:set var="paidCount" value="0" />
    <c:set var="deliveryCount" value="0" />
    <c:set var="cancelCount" value="0" />

    <c:forEach var="order" items="${allOrderList}">
        <c:set var="totalCount" value="${totalCount + 1}" />

        <c:if test="${order.status eq 'PENDING'}">
            <c:set var="pendingCount" value="${pendingCount + 1}" />
        </c:if>

        <c:if test="${order.status eq 'PAID'}">
            <c:set var="paidCount" value="${paidCount + 1}" />
        </c:if>

        <c:if test="${order.status eq 'PAID' || order.status eq 'PREPARING' || order.status eq 'SHIPPING' || order.status eq 'DELIVERED'}">
            <c:set var="deliveryCount" value="${deliveryCount + 1}" />
        </c:if>

        <c:if test="${order.status eq 'CANCELLED'}">
            <c:set var="cancelCount" value="${cancelCount + 1}" />
        </c:if>
    </c:forEach>

    <section class="page-block soft my-order-page">
        <div class="block-inner">

            <div class="my-order-title">
                <div>
                    <span>MY ORDER</span>
                    <h2>내 주문 내역</h2>
                    <p>주문한 상품의 결제 상태와 배송 상태를 확인할 수 있습니다.</p>
                </div>
            </div>

            <div class="order-stat-grid">
                <div class="order-stat-card">
                    <span>전체 주문</span>
                    <strong>${totalCount}</strong>
                    <p>지금까지 주문한 전체 내역입니다.</p>
                </div>

                <div class="order-stat-card">
                    <span>결제 대기</span>
                    <strong>${pendingCount}</strong>
                    <p>아직 결제가 필요한 주문입니다.</p>
                </div>

                <div class="order-stat-card">
                    <span>결제 완료</span>
                    <strong>${paidCount}</strong>
                    <p>결제가 완료된 주문입니다.</p>
                </div>

                <div class="order-stat-card">
                    <span>배송 확인</span>
                    <strong>${deliveryCount}</strong>
                    <p>배송 상태를 확인할 수 있습니다.</p>
                </div>
            </div>

            <div class="order-table-card">

                <div class="order-table-head">
                    <div>
                        <h3>최근 주문 내역</h3>
                        <p>주문번호를 기준으로 상세 정보와 배송 상태를 확인할 수 있습니다.</p>
                    </div>

                    <div class="order-filter">
                        <button type="button"
                                class="${empty selectedStatus ? 'active' : ''}"
                                onclick="location.href='/order/my'">
                            전체
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'PAID' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=PAID'">
                            결제완료
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'PREPARING' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=PREPARING'">
                            준비중
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'SHIPPING' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=SHIPPING'">
                            배송중
                        </button>

                        <button type="button"
                                class="${selectedStatus eq 'CANCELLED' ? 'active' : ''}"
                                onclick="location.href='/order/my?status=CANCELLED'">
                            취소
                        </button>
                    </div>
                </div>

                <div class="table-wrap">
                    <table class="order-table">
                        <thead>
                            <tr>
                                <th>주문번호</th>
                                <th>결제금액</th>
                                <th>주문상태</th>
                                <th>주문일</th>
                                <th>확인</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:choose>
                                <c:when test="${empty orderList}">
                                    <tr>
                                        <td colspan="5" class="empty-order">
                                            아직 주문 내역이 없습니다.
                                        </td>
                                    </tr>
                                </c:when>

                                <c:otherwise>
                                    <c:forEach var="order" items="${orderList}">
                                        <tr>
                                            <td>
                                                <strong class="order-number">
                                                    #${order.order_id}
                                                </strong>
                                            </td>

                                            <td>
                                                <strong class="order-amount">
                                                    <fmt:formatNumber value="${order.total_amount}" pattern="#,###"/>원
                                                </strong>
                                            </td>

                                            <td>
                                                <span class="badge ${order.status}">
                                                    <c:choose>
                                                        <c:when test="${order.status eq 'PENDING'}">주문 접수</c:when>
                                                        <c:when test="${order.status eq 'PAID'}">결제 완료</c:when>
                                                        <c:when test="${order.status eq 'PREPARING'}">제작 준비중</c:when>
                                                        <c:when test="${order.status eq 'SHIPPING'}">배송중</c:when>
                                                        <c:when test="${order.status eq 'DELIVERED'}">배송 완료</c:when>
                                                        <c:when test="${order.status eq 'CANCELLED'}">주문 취소</c:when>
                                                        <c:otherwise>${order.status}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>

                                            <td>${order.created_at}</td>

                                            <td class="order-actions">
                                                <a href="/order/detail?order_id=${order.order_id}">상세보기</a>

                                                <c:if test="${order.status eq 'PENDING'}">
                                                    <a href="/payment/ready?order_id=${order.order_id}">결제하기</a>

                                                    <form action="/order/cancel" method="post" class="inline-form">
                                                        <input type="hidden" name="order_id" value="${order.order_id}">
                                                        <button type="submit" class="link-button"
                                                                onclick="return confirm('주문을 취소하시겠습니까?');">
                                                            주문취소
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <c:if test="${order.status eq 'PAID'}">
                                                    <a href="/order/delivery?order_id=${order.order_id}">배송조회</a>

                                                    <form action="/payment/toss/cancel" method="post" class="inline-form">
                                                        <input type="hidden" name="order_id" value="${order.order_id}">
                                                        <button type="submit" class="link-button"
                                                                onclick="return confirm('결제를 취소하시겠습니까?');">
                                                            결제취소
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <c:if test="${order.status eq 'PREPARING' || order.status eq 'SHIPPING' || order.status eq 'DELIVERED'}">
                                                    <a href="/order/delivery?order_id=${order.order_id}">배송조회</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

            </div>

        </div>
    </section>

    <footer class="site-footer">
        <div class="footer-inner">
            <strong>HANDMADE</strong>
            <p>주문한 상품의 결제 상태와 배송 상태를 확인할 수 있습니다.</p>
        </div>
    </footer>

    </body>

</html>