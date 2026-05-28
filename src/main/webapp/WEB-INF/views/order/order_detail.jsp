<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>주문 상세</title>
        <link rel="stylesheet" href="/css/order-payment.css">
    </head>
    
    <body>

    <header class="site-header">
        <div class="header-inner">
            <div class="brand">HAND<span>MADE</span></div>

            <nav class="main-nav">
                <a href="#">선물추천</a>
                <a href="#">베스트</a>
                <a href="#">취향발견</a>
                <a href="#">최신작품</a>
                <a href="#">작가</a>
                <a href="#">커뮤니티</a>
            </nav>

            <div class="header-actions">
                <a href="/order/my">주문내역</a>
                <a href="#">관심</a>
                <a href="#">장바구니</a>
            </div>
        </div>
    </header>

    <section class="page-block soft">
        <div class="block-inner">
            <div class="page-title-row">
                <div>
                    <span>ORDER DETAIL</span>
                    <h2>주문 상세</h2>
                </div>
                <p>주문한 상품과 결제 정보를 확인합니다.</p>
            </div>

            <div class="order-detail-grid">

                <div class="order-main-column">

                    <div class="info-box order-summary-box">
                        <div>
                            <span>주문번호</span>
                            <strong>${order.order_id}</strong>
                        </div>

                        <div>
                            <span>주문일</span>
                            <strong>${order.created_at}</strong>
                        </div>
                    </div>

                    <div class="panel">
                        <h3 class="panel-title">주문 상품</h3>

                        <c:forEach var="item" items="${orderItemList}">
                            <div class="order-item">
                                <img src="/images/${item.imageS}" alt="상품 이미지">

                                <div class="item-info">
                                    <div class="creator-line">작가 상품</div>
                                    <strong>${item.productName}</strong>
                                    <p>가격 ${item.price}원</p>
                                    <p>수량 ${item.quantity}개</p>
                                </div>

                                <div class="item-price">
                                    ${item.subtotalAmount}원
                                </div>
                            </div>
                        </c:forEach>

                        <div class="delivery-info-card">
                            <h4>배송 정보</h4>
                            <p><strong>배송지번호</strong> ${order.address_id}</p>
                            <p>상세 배송지는 배송지 테이블 연동 후 표시 예정입니다.</p>
                        </div>
                    </div>

                </div>

                <div class="order-side-column">

                    <div class="order-status-card">
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

                    <aside class="panel side-panel">
                        <h3 class="panel-title">결제 정보</h3>

                        <div class="summary-line">
                            <span>결제수단</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${payment.payment_method eq 'CARD'}">카드</c:when>
                                    <c:when test="${payment.payment_method eq 'TOSS'}">토스페이</c:when>
                                    <c:when test="${payment.payment_method eq 'KAKAO'}">카카오페이</c:when>
                                    <c:otherwise>${payment.payment_method}</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>

                        <div class="summary-line">
                            <span>결제상태</span>
                            <span class="badge ${payment.status}">
                                <c:choose>
                                    <c:when test="${payment.status eq 'READY'}">결제 대기</c:when>
                                    <c:when test="${payment.status eq 'SUCCESS'}">결제 완료</c:when>
                                    <c:when test="${payment.status eq 'FAIL'}">결제 실패</c:when>
                                    <c:otherwise>${payment.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="summary-line">
                            <span>거래번호</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${empty payment.transaction_id}">-</c:when>
                                    <c:otherwise>${payment.transaction_id}</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>

                        <div class="summary-total">
                            <span>총 결제금액</span>
                            <strong>${payment.amount}원</strong>
                        </div>

                        <div class="btn-row">
                            <a class="btn light full" href="/order/my">목록으로</a>
                        </div>

                        <div class="btn-row">
                            <a class="btn primary full" href="/order/delivery?order_id=${order.order_id}">
                                배송 상태 확인
                            </a>
                        </div>
                    </aside>

                </div>

            </div>
        </div>
    </section>

    <footer class="site-footer">
        <div class="footer-inner">
            <strong>HANDMADE</strong>
            <p>주문 상세와 결제 정보를 한눈에 확인할 수 있습니다.</p>
        </div>
    </footer>

    </body>
</html>